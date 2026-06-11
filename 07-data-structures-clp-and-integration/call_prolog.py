"""
Course:  CSC350: Logic Programming for Artificial Intelligence
Module:  7 - Advanced Data Structures, CLP, and Language Integration
Competencies: 4 (develop Prolog solutions), 5 (evaluate integration
              architectures), 6 (solutions for AI applications)
Purpose: Call Prolog from Python. Python plays the "application shell"
         (argument handling, formatting, post-processing); Prolog plays
         the "reasoning core" (recursive route search in kb_for_python.pl).
         This logic-core + conventional-shell split is how most deployed
         logic-programming systems are architected.
Runs in: Python 3 (standard library only), and is **SWI-Prolog-specific**:
         it invokes the `swipl` executable with SWI's command-line flags.
         SICStus has a different CLI (and richer options: library(prologbeans),
         PySwip-style embeddings, etc.) -- porting this script is a module
         extension exercise.

Usage:   python call_prolog.py        (run from this directory;
                                       requires `swipl` on your PATH)
"""

from __future__ import annotations

import shutil
import subprocess
import sys
from pathlib import Path

KB_FILE = Path(__file__).with_name("kb_for_python.pl")


def query_routes(origin: str, destination: str) -> list[list[str]]:
    """Ask the Prolog KB for every route origin -> destination.

    We run:  swipl -q -g "print_routes(origin, dest)" -t halt kb_for_python.pl
      -q          quiet (no banner)
      -g Goal     run Goal after loading            (SWI-specific flag)
      -t halt     then terminate instead of opening a prompt

    Prolog prints one route per line, e.g. [phoenix,denver,chicago,boston];
    Python parses those lines back into lists.
    """
    goal = f"print_routes({origin}, {destination})"
    result = subprocess.run(
        ["swipl", "-q", "-g", goal, "-t", "halt", str(KB_FILE)],
        capture_output=True, text=True, timeout=30,
    )
    if result.returncode != 0:
        raise RuntimeError(f"swipl failed: {result.stderr.strip()}")

    routes = []
    for line in result.stdout.splitlines():
        line = line.strip()
        if line.startswith("[") and line.endswith("]"):
            routes.append([city.strip() for city in line[1:-1].split(",")])
    return routes


def main() -> None:
    if shutil.which("swipl") is None:
        sys.exit("swipl not found on PATH -- install SWI-Prolog first (see SETUP.md).")

    origin, destination = "phoenix", "boston"
    routes = query_routes(origin, destination)

    # Python-side post-processing: sorting and presentation -- the kind of
    # work you would NOT want to write in Prolog.
    routes.sort(key=len)
    print(f"Routes {origin} -> {destination} (found by Prolog, formatted by Python)")
    print(f"{'stops':>5}  route")
    for route in routes:
        print(f"{len(route) - 2:>5}  {' -> '.join(route)}")
    if routes:
        print(f"\nBest route has {len(routes[0]) - 2} intermediate stop(s).")
    else:
        print("No routes found.")


if __name__ == "__main__":
    main()
