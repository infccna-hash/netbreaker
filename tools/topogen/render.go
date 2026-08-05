package main

// render + report are implemented in later steps; these stubs let the
// extract command compile and run independently (the gate comes first).

import (
	"flag"
	"fmt"
	"os"
)

func cmdRender(args []string) {
	fs := flag.NewFlagSet("render", flag.ExitOnError)
	fs.Parse(args)
	fmt.Fprintln(os.Stderr, "render: not implemented yet")
	os.Exit(1)
}

func cmdReport(args []string) {
	fs := flag.NewFlagSet("report", flag.ExitOnError)
	fs.Parse(args)
	fmt.Fprintln(os.Stderr, "report: not implemented yet")
	os.Exit(1)
}
