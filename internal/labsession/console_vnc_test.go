package labsession

import "testing"

func TestUsesVNCConsole(t *testing.T) {
	cases := []struct {
		name string
		info NodeInfo
		want bool
	}{
		{"qemu with empty console_type (the race we fix)", NodeInfo{NodeType: "qemu"}, true},
		{"qemu explicitly vnc", NodeInfo{NodeType: "qemu", ConsoleType: "vnc"}, true},
		{"console_type vnc even if type unknown", NodeInfo{ConsoleType: "vnc"}, true},
		{"iou switch (telnet)", NodeInfo{NodeType: "iou", ConsoleType: "telnet"}, false},
		{"dynamips router (telnet)", NodeInfo{NodeType: "dynamips", ConsoleType: "telnet"}, false},
		{"vpcs host", NodeInfo{NodeType: "vpcs", ConsoleType: "telnet"}, false},
		{"iou with empty console_type still telnet", NodeInfo{NodeType: "iou"}, false},
	}
	for _, c := range cases {
		if got := usesVNCConsole(c.info); got != c.want {
			t.Errorf("%s: usesVNCConsole=%v want %v", c.name, got, c.want)
		}
	}
}
