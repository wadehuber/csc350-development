# CSC350 Setup Instructions

You need three tools for this course's examples: **SWI-Prolog** (required),
**Python 3** (for a handful of examples), and **SQLite 3** (for two SQL examples).
SICStus Prolog is optional — your instructor will tell you if your section uses it.

## SWI-Prolog

### Windows
1. Download the 64-bit installer from https://www.swi-prolog.org/Download.html
2. Run the installer; accept the option to add SWI-Prolog to your `PATH`.
3. Verify in a new terminal: `swipl --version`

### macOS
```
brew install swi-prolog
swipl --version
```

### Linux (Debian/Ubuntu)
```
sudo apt install swi-prolog
swipl --version
```

### First steps
```
swipl
?- write(hello), nl.
hello
true.
?- halt.
```

To load an example file: `swipl path/to/file.pl`, or from inside Prolog:
`?- consult('path/to/file.pl').`

## SICStus Prolog (optional)

SICStus is commercial software; use your campus license if the course provides one.
Download and installation instructions: https://sicstus.sics.se/

- Start it with `sicstus`; load a file with `?- consult('file.pl').` or
  `sicstus -l file.pl`.
- Files in this repo that need SICStus-specific adjustments say so in their header
  comments.

## Python 3

Any Python 3.10+ works. The examples use only the standard library.

- Windows: `winget install Python.Python.3.12` or https://www.python.org/downloads/
- macOS: `brew install python`
- Linux: usually preinstalled; otherwise `sudo apt install python3`

Verify: `python --version` (or `python3 --version`).

## SQLite 3

- Windows: `winget install SQLite.SQLite`, or download the "command-line tools" zip
  from https://www.sqlite.org/download.html and put `sqlite3.exe` on your `PATH`.
- macOS: preinstalled (`sqlite3 --version`).
- Linux: `sudo apt install sqlite3`

Run a SQL example: `sqlite3 < 05-prolog-review-and-core-mechanisms/movies.sql`

## Editor Suggestions

- **VS Code** with the "VSC-Prolog" extension gives syntax highlighting for `.pl` files.
  (You may need to associate `.pl` with Prolog instead of Perl: bottom-right language
  selector → "Prolog".)
- SWI-Prolog also ships its own editor: from the Prolog prompt, `?- emacs.` on
  platforms where it is available, or use any plain-text editor.
