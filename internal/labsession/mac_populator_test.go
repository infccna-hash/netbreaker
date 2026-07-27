package labsession

import (
	"context"
	"strings"
	"testing"
)

func TestResolveMAC_DockerFromAPI(t *testing.T) {
	node := gns3NodeProperties{
		NodeType:   "docker",
		MACAddress: "02:42:ac:11:00:02",
	}

	mac, err := ResolveMAC(context.Background(), node)
	if err != nil {
		t.Fatalf("ResolveMAC(docker): %v", err)
	}
	if mac != "02:42:ac:11:00:02" {
		t.Errorf("expected 02:42:ac:11:00:02, got %q", mac)
	}
}

func TestResolveMAC_DockerMissingMAC(t *testing.T) {
	node := gns3NodeProperties{
		NodeType:   "docker",
		MACAddress: "", // GNS3 API didn't include it
	}

	_, err := ResolveMAC(context.Background(), node)
	if err == nil {
		t.Fatal("expected error for docker without mac_address")
	}
}

func TestResolveMAC_QemuFromAPI(t *testing.T) {
	node := gns3NodeProperties{
		NodeType:   "qemu",
		MACAddress: "0c:f1:e0:e6:00:00",
	}

	mac, err := ResolveMAC(context.Background(), node)
	if err != nil {
		t.Fatalf("ResolveMAC(qemu): %v", err)
	}
	if mac != "0c:f1:e0:e6:00:00" {
		t.Errorf("expected 0c:f1:e0:e6:00:00, got %q", mac)
	}
}

func TestResolveMAC_IouNoMAC(t *testing.T) {
	mac, err := ResolveMAC(context.Background(), gns3NodeProperties{NodeType: "iou"})
	if err != nil {
		t.Fatalf("ResolveMAC(iou): unexpected error: %v", err)
	}
	if mac != "" {
		t.Errorf("iou should return empty MAC, got %q", mac)
	}
}

func TestResolveMAC_DynamipsNoMAC(t *testing.T) {
	// dynamips nodes have mac_addr (router's own), but we treat them
	// as "no MAC needed" — they're not hosts.
	mac, err := ResolveMAC(context.Background(), gns3NodeProperties{
		NodeType: "dynamips",
		MACAddr:  "c201.7cb4.0000",
	})
	if err != nil {
		t.Fatalf("ResolveMAC(dynamips): unexpected error: %v", err)
	}
	if mac != "" {
		t.Errorf("dynamips should return empty MAC (router, not host), got %q", mac)
	}
}

func TestResolveMAC_VPCSNoConsole(t *testing.T) {
	// VPCS with no console allocated fails early — no TCP dial attempted.
	_, err := ResolveMAC(context.Background(), gns3NodeProperties{NodeType: "vpcs", Console: 0})
	if err == nil {
		t.Fatal("expected error for VPCS with no console port")
	}
	if !strings.Contains(err.Error(), "no console port") {
		t.Errorf("error should mention missing console port: %v", err)
	}
}

func TestResolveMAC_VPCSNoConsoleHost(t *testing.T) {
	_, err := ResolveMAC(context.Background(), gns3NodeProperties{
		NodeType:    "vpcs",
		Console:     5000,
		ConsoleHost: "",
	})
	if err == nil {
		t.Fatal("expected error for VPCS with empty console host")
	}
	if !strings.Contains(err.Error(), "no console host") {
		t.Errorf("error should mention missing console host: %v", err)
	}
}

func TestResolveMAC_UnknownType(t *testing.T) {
	_, err := ResolveMAC(context.Background(), gns3NodeProperties{NodeType: "frame_relay_switch"})
	if err == nil {
		t.Fatal("expected error for unknown node type")
	}
	if _, ok := err.(ErrMACNotSupported); !ok {
		t.Errorf("expected ErrMACNotSupported, got %T: %v", err, err)
	}
}

func TestResolveMAC_EthernetHubNoMAC(t *testing.T) {
	mac, err := ResolveMAC(context.Background(), gns3NodeProperties{NodeType: "ethernet_hub"})
	if err != nil {
		t.Fatalf("ResolveMAC(ethernet_hub): unexpected error: %v", err)
	}
	if mac != "" {
		t.Errorf("ethernet_hub should return empty MAC, got %q", mac)
	}
}

func TestVpcsMACRegex(t *testing.T) {
	tests := []struct {
		line    string
		wantMAC string
	}{
		{"MAC: 00:50:79:66:68:00", "00:50:79:66:68:00"},
		{"  MAC  :  00:50:79:66:68:01  ", "00:50:79:66:68:01"},
		{"some text MAC: aa:bb:cc:dd:ee:ff more", "aa:bb:cc:dd:ee:ff"},
		{"no mac here", ""},
	}

	for _, tt := range tests {
		matches := vpcsMACVerboseRe.FindStringSubmatch(tt.line)
		var got string
		if len(matches) > 1 {
			got = matches[1]
		}
		if got != tt.wantMAC {
			t.Errorf("line=%q: expected MAC %q, got %q", tt.line, tt.wantMAC, got)
		}
	}
}
