package labsession

import (
	"context"
	"errors"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"
)

// fastVerifier builds a GNS3TeardownVerifier with negligible delays so tests
// don't pay the 2s production settle.
func fastVerifier(g GNS3Client) *GNS3TeardownVerifier {
	return &GNS3TeardownVerifier{gns3: g, settleDelay: time.Millisecond, pollInterval: time.Millisecond}
}

func TestVerifier_HappyPath(t *testing.T) {
	g := &fakeGNS3{stopped: true, exists: true}
	v := fastVerifier(g)
	if err := v.WaitTeardownComplete(context.Background(), "p"); err != nil {
		t.Fatalf("happy path: unexpected error %v", err)
	}
	if g.deletes != 1 {
		t.Fatalf("expected exactly one delete, got %d", g.deletes)
	}
	if g.exists {
		t.Fatalf("project should be gone after teardown")
	}
}

func TestVerifier_FailClosed_OnNodeProbeError(t *testing.T) {
	g := &fakeGNS3{nodesErr: errors.New("gns3 unreachable")}
	v := fastVerifier(g)
	if err := v.WaitTeardownComplete(context.Background(), "p"); err == nil {
		t.Fatal("expected error when node probe fails")
	}
	if g.deletes != 0 {
		t.Fatalf("must not delete before nodes confirmed stopped; deletes=%d", g.deletes)
	}
}

func TestVerifier_FailClosed_OnExistsProbeError(t *testing.T) {
	// Nodes stopped, delete succeeds, but the existence probe errors → unknown
	// → must NOT report complete even though exists happens to read false.
	g := &fakeGNS3{stopped: true, exists: true, existsErr: errors.New("gns3 500")}
	v := fastVerifier(g)
	if err := v.WaitTeardownComplete(context.Background(), "p"); err == nil {
		t.Fatal("expected error when existence probe fails (fail closed)")
	}
}

func TestVerifier_FailClosed_OnStuckNodes_TimesOut(t *testing.T) {
	// Nodes never reach stopped → verifier must time out under the ctx deadline
	// and never proceed to delete.
	g := &fakeGNS3{stopped: false}
	v := fastVerifier(g)
	ctx, cancel := context.WithTimeout(context.Background(), 20*time.Millisecond)
	defer cancel()
	err := v.WaitTeardownComplete(ctx, "p")
	if err == nil {
		t.Fatal("expected timeout error for stuck nodes")
	}
	if g.deletes != 0 {
		t.Fatalf("must not delete while nodes not stopped; deletes=%d", g.deletes)
	}
}

func TestVerifier_FailClosed_OnDeleteError(t *testing.T) {
	g := &fakeGNS3{stopped: true, exists: true, deleteErr: errors.New("delete timeout")}
	v := fastVerifier(g)
	if err := v.WaitTeardownComplete(context.Background(), "p"); err == nil {
		t.Fatal("expected error when delete fails")
	}
}

// --- Client idempotency (real HTTP semantics via httptest) ---

func TestDeleteProject_Idempotent404(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.Method == http.MethodDelete {
			w.WriteHeader(http.StatusNotFound) // already gone
		}
	}))
	defer srv.Close()
	c := NewHTTPGNS3Client(srv.URL, "", "")
	if err := c.DeleteProject(context.Background(), "p"); err != nil {
		t.Fatalf("404 on delete must be success (idempotent), got %v", err)
	}
}

func TestDeleteProject_ErrorOn500(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusInternalServerError)
	}))
	defer srv.Close()
	c := NewHTTPGNS3Client(srv.URL, "", "")
	if err := c.DeleteProject(context.Background(), "p"); err == nil {
		t.Fatal("500 on delete must return an error (fail closed)")
	}
}

func TestProjectExists_404False_200True(t *testing.T) {
	var code int
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(code)
	}))
	defer srv.Close()
	c := NewHTTPGNS3Client(srv.URL, "", "")

	code = http.StatusNotFound
	if ok, err := c.ProjectExists(context.Background(), "p"); err != nil || ok {
		t.Fatalf("404 → (false,nil); got (%v,%v)", ok, err)
	}
	code = http.StatusOK
	if ok, err := c.ProjectExists(context.Background(), "p"); err != nil || !ok {
		t.Fatalf("200 → (true,nil); got (%v,%v)", ok, err)
	}
	code = http.StatusInternalServerError
	if _, err := c.ProjectExists(context.Background(), "p"); err == nil {
		t.Fatal("500 → error (fail closed)")
	}
}
