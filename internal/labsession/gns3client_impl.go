package labsession

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"
)

// HTTPGNS3Client implements GNS3Client against a GNS3 v2 controller.
type HTTPGNS3Client struct {
	baseURL       string // e.g. "http://10.0.0.5:3080"
	username      string
	password      string
	http          *http.Client
	kaliPinnedTag string // immutable tag from KALI_PINNED_TAG env var
}

func NewHTTPGNS3Client(baseURL, username, password, kaliPinnedTag string) *HTTPGNS3Client {
	return &HTTPGNS3Client{
		baseURL:       baseURL,
		username:      username,
		password:      password,
		http:          &http.Client{Timeout: 30 * time.Second},
		kaliPinnedTag: kaliPinnedTag,
	}
}

func (c *HTTPGNS3Client) do(ctx context.Context, method, path string, body any, out any) error {
	var reqBody io.Reader
	if body != nil {
		b, err := json.Marshal(body)
		if err != nil {
			return err
		}
		reqBody = bytes.NewReader(b)
	}

	req, err := http.NewRequestWithContext(ctx, method, c.baseURL+path, reqBody)
	if err != nil {
		return err
	}
	req.Header.Set("Content-Type", "application/json")
	if c.username != "" {
		req.SetBasicAuth(c.username, c.password)
	}

	resp, err := c.http.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	respBody, _ := io.ReadAll(resp.Body)

	if resp.StatusCode >= 400 {
		return fmt.Errorf("gns3 %s %s: status %d: %s", method, path, resp.StatusCode, string(respBody))
	}
	if out != nil && len(respBody) > 0 {
		if err := json.Unmarshal(respBody, out); err != nil {
			return fmt.Errorf("gns3 %s %s: decode response: %w", method, path, err)
		}
	}
	return nil
}

// --- EnsureKaliImage ---

type gns3DockerImage struct {
	Image string `json:"image"`
}

// EnsureKaliImage queries the GNS3 compute node's Docker image list and
// confirms the pinned Kali tag is present. Fails closed — any transport
// error, unexpected response, or missing image surfaces with an actionable
// message ("run build.sh") rather than letting GNS3 produce a generic
// "image not found" at node-creation time.
func (c *HTTPGNS3Client) EnsureKaliImage(ctx context.Context, computeID string) error {
	var images []gns3DockerImage
	path := fmt.Sprintf("/v2/computes/%s/docker/images", computeID)
	if err := c.do(ctx, http.MethodGet, path, nil, &images); err != nil {
		return fmt.Errorf("cannot list docker images on compute %q: %w; is GNS3 reachable?", computeID, err)
	}

	pinned := c.kaliPinnedTag
	for _, img := range images {
		if img.Image == pinned {
			return nil // found — safe to provision
		}
	}

	return fmt.Errorf("kali image %q not found on Falcon compute %q; "+
		"run ~/netbreaker/docker/kali/build.sh on Falcon to rebuild", pinned, computeID)
}

// --- CreateProject ---

type gns3Project struct {
	ProjectID string `json:"project_id"`
	Name      string `json:"name"`
}

func (c *HTTPGNS3Client) CreateProject(ctx context.Context, computeID string, userID, labID int) (string, error) {
	// Name must be unique per GNS3 controller. Scoping by user+lab is the
	// isolation guarantee — never reuse a project across students, per spec.
	name := fmt.Sprintf("nb-u%d-l%d-%d", userID, labID, time.Now().Unix())

	var proj gns3Project
	err := c.do(ctx, http.MethodPost, "/v2/projects", map[string]any{
		"name": name,
	}, &proj)
	if err != nil {
		return "", err
	}
	return proj.ProjectID, nil
}

// --- ProvisionTopology ---

type gns3NodeCreate struct {
	Name       string         `json:"name"`
	NodeType   string         `json:"node_type"`
	ComputeID  string         `json:"compute_id"`
	TemplateID string         `json:"template_id,omitempty"`
	Properties map[string]any `json:"properties,omitempty"`
}

type gns3Node struct {
	NodeID      string `json:"node_id"`
	Name        string `json:"name"`
	Console     int    `json:"console"`
	ConsoleType string `json:"console_type"`
	Status      string `json:"status"`
}

type gns3LinkNode struct {
	NodeID        string `json:"node_id"`
	AdapterNumber int    `json:"adapter_number"`
	PortNumber    int    `json:"port_number"`
}

type gns3LinkCreate struct {
	Nodes []gns3LinkNode `json:"nodes"`
}

func (c *HTTPGNS3Client) ProvisionTopology(ctx context.Context, projectID string, template TopologyTemplate) (NodeMap, error) {
	nodes := make(NodeMap)

	// created holds name -> gns3 node, so link creation (next step, not yet
	// wired since link topology isn't in TopologyTemplate yet) can reference
	// node IDs by name.
	created := make(map[string]gns3Node)

	for _, nt := range template.Nodes {
		payload := gns3NodeCreate{
			Name:       nt.Name,
			NodeType:   nt.NodeType,
			ComputeID:  template.ComputeID,
			TemplateID: nt.TemplateID,
		}

		// Merge explicit properties from the topology template with
		// node-type-specific defaults. Explicit properties win.
		props := make(map[string]any)
		if nt.Properties != nil {
			for k, v := range nt.Properties {
				props[k] = v
			}
		}

		switch nt.NodeType {
		case "iou":
			// Always disable console/vty timeouts so lab sessions don't disconnect
			// after 10 minutes of idle (default IOS exec-timeout).
			base := "line con 0\nexec-timeout 0 0\nline vty 0 4\nexec-timeout 0 0\n"
			if nt.StartupConfig != "" {
				props["startup_config_content"] = base + nt.StartupConfig
			} else {
				props["startup_config_content"] = base
			}
		case "dynamips":
			// Properties from the topology template must include
			// platform, image, ram etc. — no defaults to guess.
			base := "line con 0\nexec-timeout 0 0\nline vty 0 4\nexec-timeout 0 0\n"
			if nt.StartupConfig != "" {
				props["startup_config_content"] = base + nt.StartupConfig
			} else {
				props["startup_config_content"] = base
			}
		case "qemu":
			// QEMU nodes boot from their disk image, no startup config.
			// Properties (disk image, adapters) come from the template.
			// BUT: the template's qemu_path doesn't reliably propagate
			// into node creation — GNS3 uses a default that doesn't
			// exist (qemu-system-None). Inject the system path so the
			// node boots instead of returning 409.
			if _, ok := props["qemu_path"]; !ok {
				props["qemu_path"] = "/usr/bin/qemu-system-x86_64"
			}
		case "docker":
			// Docker containers: GNS3 requires image and console_type in the
			// node creation payload even when using a template that specifies
			// them.
			if _, ok := props["image"]; !ok {
				// The topology template didn't supply an image — this is
				// the normal path (no template sets image; we always pin
				// it here). Read the single source of truth so a rebuild
				// propagates everywhere without multi-place manual edits.
				props["image"] = c.kaliPinnedTag
			}
			if _, ok := props["console_type"]; !ok {
				props["console_type"] = "telnet"
			}
		case "vpcs":
			// Built-in Virtual PC Simulator — no startup config, no properties.
		case "ethernet_hub":
			// Virtual Ethernet hub — no startup config, no properties.
		default:
			return nil, fmt.Errorf("unsupported node type %q for node %q", nt.NodeType, nt.Name)
		}

		if len(props) > 0 {
			payload.Properties = props
		}

		var node gns3Node
		path := fmt.Sprintf("/v2/projects/%s/nodes", projectID)
		if err := c.do(ctx, http.MethodPost, path, payload, &node); err != nil {
			return nil, fmt.Errorf("create node %q: %w", nt.Name, err)
		}

		created[nt.Name] = node
		nodes[nt.Name] = NodeInfo{
			GNS3NodeID:  node.NodeID,
			ConsolePort: node.Console,
			ConsoleType: node.ConsoleType,
			NodeType:    nt.NodeType,
		}
	}

	// Create links between nodes using the interface labels from the
	// topology template, translated to GNS3 adapter/port numbers per
	// node type.
	if err := c.createLinks(ctx, projectID, template, created); err != nil {
		return nil, err
	}
	return nodes, nil
}

// --- Links ---

// interfaceToPort converts a Cisco-style interface name to GNS3's
// (adapter_number, port_number) pair for a given node type.
//
// The IOU L2 image convention maps Fa0/N → adapter 0, port N.
// This has been verified against the i86bi-linux-l2-adventerprisek9
// image (common GNS3 IOU L2 image); if your compute box runs a
// different image, create one test node + one link to confirm.
func interfaceToPort(nodeType, iface string) (adapter, port int, err error) {
	switch nodeType {
	case "iou":
		// IOU L2 image: Et0/N → adapter 0, port N (confirmed via test).
		// Also accept Fa0/N for compatibility with IOS config references
		// in lab content (IOS accepts both interface names).
		var n int
		if _, err := fmt.Sscanf(iface, "Et0/%d", &n); err == nil {
			return 0, n, nil
		}
		if _, err := fmt.Sscanf(iface, "Fa0/%d", &n); err == nil {
			return 0, n, nil
		}
		return 0, 0, fmt.Errorf("unrecognized %s interface %q (expected Et0/N or Fa0/N)", nodeType, iface)

	case "dynamips":
		// c3725: Fa<N>/M → adapter N (slot number), port M.
		// Slot0 = GT96100-FE (built-in, Fa0/0-Fa0/1)
		// Slot1 = NM-16ESW (switch module, Fa1/0-Fa1/15)
		// Slot2 = NM-1FE-TX (Fa2/0)
		var slot, portN int
		if _, err := fmt.Sscanf(iface, "Fa%d/%d", &slot, &portN); err == nil {
			return slot, portN, nil
		}
		// Also accept Gi0/N — maps to the same built-in ports (Fa0/N)
		// Lab content sometimes reads Gi0/0 and Gi0/1 for c3725 even though
		// the actual IOS image only supports FastEthernet on these slots.
		if _, err := fmt.Sscanf(iface, "Gi0/%d", &slot); err == nil {
			// Gi0/0 → Fa0/0, Gi0/1 → Fa0/1 (same adapter/port)
			return 0, slot, nil
		}
		// NM-16ESW switchports (slot1): IOS calls them GigabitEthernet0/1-16
		// but in GNS3 they are on adapter 1, port N-1.
		if _, err := fmt.Sscanf(iface, "Gi1/%d", &portN); err == nil {
			return 1, portN - 1, nil
		}
		return 0, 0, fmt.Errorf("unrecognized dynamips interface %q (expected Fa<N>/<M> or Gi0/N)", iface)

	case "vpcs":
		// VPCS has a single built-in Ethernet port always at adapter 0, port 0.
		return 0, 0, nil

	case "ethernet_hub":
		// Ethernet hub: ports are e0, e1, e2... → adapter 0, port N
		var port int
		if _, err := fmt.Sscanf(iface, "e%d", &port); err == nil {
			return 0, port, nil
		}
		return 0, 0, fmt.Errorf("unrecognized hub interface %q (expected e<N>)", iface)

	case "docker":
		// Docker containers: eth0 → adapter 0, port 0; ethN → adapter N, port 0.
		if iface == "eth0" {
			return 0, 0, nil
		}
		var n int
		if _, err := fmt.Sscanf(iface, "eth%d", &n); err == nil {
			return n, 0, nil
		}
		return 0, 0, fmt.Errorf("unrecognized docker interface %q (expected ethN)", iface)

	case "qemu":
		// QEMU: eth0 / Ethernet0 → adapter 0, port 0.
		// Kali/Docker-via-QEMU uses ethN; ASA uses Ethernet{0} (template
		// port_name_format). Both map the same way: <name><N> → adapter N.
		if iface == "eth0" || iface == "Ethernet0" {
			return 0, 0, nil
		}
		var n int
		if _, err := fmt.Sscanf(iface, "eth%d", &n); err == nil {
			return n, 0, nil
		}
		if _, err := fmt.Sscanf(iface, "Ethernet%d", &n); err == nil {
			return n, 0, nil
		}
		return 0, 0, fmt.Errorf("unrecognized qemu interface %q (expected ethN or EthernetN)", iface)

	default:
		return 0, 0, fmt.Errorf("no port mapping for node type %q", nodeType)
	}
}

func nodeTypeOf(t TopologyTemplate, name string) string {
	for _, n := range t.Nodes {
		if n.Name == name {
			return n.NodeType
		}
	}
	return ""
}

func (c *HTTPGNS3Client) createLinks(ctx context.Context, projectID string, template TopologyTemplate, created map[string]gns3Node) error {
	for _, link := range template.Links {
		nodeA, ok := created[link.NodeA]
		if !ok {
			return fmt.Errorf("link references unknown node %q", link.NodeA)
		}
		nodeB, ok := created[link.NodeB]
		if !ok {
			return fmt.Errorf("link references unknown node %q", link.NodeB)
		}

		adapterA, portA, err := interfaceToPort(nodeTypeOf(template, link.NodeA), link.IfaceA)
		if err != nil {
			return fmt.Errorf("link %s:%s: %w", link.NodeA, link.IfaceA, err)
		}
		adapterB, portB, err := interfaceToPort(nodeTypeOf(template, link.NodeB), link.IfaceB)
		if err != nil {
			return fmt.Errorf("link %s:%s: %w", link.NodeB, link.IfaceB, err)
		}

		payload := gns3LinkCreate{Nodes: []gns3LinkNode{
			{NodeID: nodeA.NodeID, AdapterNumber: adapterA, PortNumber: portA},
			{NodeID: nodeB.NodeID, AdapterNumber: adapterB, PortNumber: portB},
		}}

		path := fmt.Sprintf("/v2/projects/%s/links", projectID)
		if err := c.do(ctx, http.MethodPost, path, payload, nil); err != nil {
			return fmt.Errorf("create link %s:%s ⇄ %s:%s: %w",
				link.NodeA, link.IfaceA, link.NodeB, link.IfaceB, err)
		}
	}
	return nil
}

// --- StartNodes / StopNodes ---

func (c *HTTPGNS3Client) StartNodes(ctx context.Context, projectID string) error {
	path := fmt.Sprintf("/v2/projects/%s/nodes/start", projectID)
	return c.do(ctx, http.MethodPost, path, nil, nil)
}

// doStatus is like do but returns the HTTP status code and does NOT treat a
// 4xx/5xx response as an error by itself — only transport-level failures
// (connection refused, timeout, DNS) return a non-nil error. This lets callers
// make idempotent decisions, e.g. treat 404 on DELETE as "already gone = ok".
// The response body is only decoded into out on a 2xx status.
func (c *HTTPGNS3Client) doStatus(ctx context.Context, method, path string, out any) (int, error) {
	req, err := http.NewRequestWithContext(ctx, method, c.baseURL+path, nil)
	if err != nil {
		return 0, err
	}
	req.Header.Set("Content-Type", "application/json")
	if c.username != "" {
		req.SetBasicAuth(c.username, c.password)
	}
	resp, err := c.http.Do(req)
	if err != nil {
		return 0, err
	}
	defer resp.Body.Close()
	body, _ := io.ReadAll(resp.Body)
	if resp.StatusCode < 400 && out != nil && len(body) > 0 {
		if err := json.Unmarshal(body, out); err != nil {
			return resp.StatusCode, fmt.Errorf("gns3 %s %s: decode: %w", method, path, err)
		}
	}
	return resp.StatusCode, nil
}

func (c *HTTPGNS3Client) StopNodes(ctx context.Context, projectID string) error {
	// Idempotent: stopping already-stopped nodes is a no-op in GNS3, and a 404
	// means the project is already gone — nothing to stop — which is success
	// for our "ensure nothing is running" intent, not an error.
	path := fmt.Sprintf("/v2/projects/%s/nodes/stop", projectID)
	status, err := c.doStatus(ctx, http.MethodPost, path, nil)
	if err != nil {
		return err
	}
	if status == http.StatusNotFound {
		return nil
	}
	if status >= 400 {
		return fmt.Errorf("gns3 stop nodes %s: status %d", projectID, status)
	}
	return nil
}

// ProjectExists reports whether the project still exists in GNS3's model.
// 404 → (false, nil); 2xx → (true, nil); any other status or transport error →
// (false, err) so callers fail closed (unknown is never treated as "gone").
func (c *HTTPGNS3Client) ProjectExists(ctx context.Context, projectID string) (bool, error) {
	path := fmt.Sprintf("/v2/projects/%s", projectID)
	status, err := c.doStatus(ctx, http.MethodGet, path, nil)
	if err != nil {
		return false, err
	}
	switch {
	case status == http.StatusNotFound:
		return false, nil
	case status >= 200 && status < 300:
		return true, nil
	default:
		return false, fmt.Errorf("gns3 get project %s: status %d", projectID, status)
	}
}

// NodesStopped reports whether every node in the project has reached a terminal
// (stopped) state, or the project/node list is gone. 404 → project no longer
// exists → nothing running → (true, nil). Any non-stopped node → (false, nil).
// Transport or unexpected status → (false, err) → fail closed.
func (c *HTTPGNS3Client) NodesStopped(ctx context.Context, projectID string) (bool, error) {
	path := fmt.Sprintf("/v2/projects/%s/nodes", projectID)
	var nodes []struct {
		Status string `json:"status"`
	}
	status, err := c.doStatus(ctx, http.MethodGet, path, &nodes)
	if err != nil {
		return false, err
	}
	if status == http.StatusNotFound {
		return true, nil
	}
	if status < 200 || status >= 300 {
		return false, fmt.Errorf("gns3 list nodes %s: status %d", projectID, status)
	}
	for _, n := range nodes {
		if n.Status != "stopped" {
			return false, nil
		}
	}
	return true, nil
}

// --- DeleteProject ---

func (c *HTTPGNS3Client) DeleteProject(ctx context.Context, projectID string) error {
	// Idempotent: a 404 means the project is already deleted, which is exactly
	// the post-condition we want — treat it as success so a reconciliation loop
	// can re-issue the delete without turning a benign repeat into a failure.
	path := fmt.Sprintf("/v2/projects/%s", projectID)
	status, err := c.doStatus(ctx, http.MethodDelete, path, nil)
	if err != nil {
		return err
	}
	if status == http.StatusNotFound {
		return nil
	}
	if status >= 400 {
		return fmt.Errorf("gns3 delete project %s: status %d", projectID, status)
	}
	return nil
}
