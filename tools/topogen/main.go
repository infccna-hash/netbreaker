// Command topogen — Go→SVG topology generator for NetBreaker.
//
// Converts the Go topology structs (internal/labsession) into canonical
// Lab-15-style SVGs with data-port/data-node attributes baked in, so the
// frontend can attach hover tooltips via event delegation.
//
// Pipeline:
//  1. extract — parse existing baseline SVGs to salvage human-chosen node
//     positions (rect/circle + nearest text matched BY NAME against the Go
//     template — no name guessing).
//  2. render — generate canonical SVGs for all 46 labs (or a subset), using
//     extracted positions when available, deterministic layered-grid
//     auto-layout otherwise.
//  3. report — diff generated vs baseline to surface topology mismatches
//     (the audit).
//
// Usage:
//
//	go run ./tools/topogen extract [--out positions.json]
//	go run ./tools/topogen render [--positions positions.json] [--labs 34,35] [--out generated/]
//	go run ./tools/topogen report [--generated generated/] [--out report.md]
package main

import (
	"flag"
	"fmt"
	"os"
)

func main() {
	if len(os.Args) < 2 {
		usage()
		os.Exit(2)
	}
	switch os.Args[1] {
	case "extract":
		cmdExtract(os.Args[2:])
	case "render":
		cmdRender(os.Args[2:])
	case "report":
		cmdReport(os.Args[2:])
	default:
		usage()
		os.Exit(2)
	}
}

func usage() {
	fmt.Fprintln(os.Stderr, `topogen — NetBreaker Go→SVG topology generator

Commands:
  extract  — salvage node positions from baseline SVGs (by-name matching)
  render   — generate canonical SVGs from Go topology structs
  report   — diff generated vs baseline (audit)

Use -h on a subcommand for its flags.`)
}

var _ = flag.String // placeholder to keep flag import until subcommands land
