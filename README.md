# CSC350: Logic Programming for Artificial Intelligence

Starter code repository for **CSC350: Logic Programming for Artificial Intelligence**.

## Course Description

Introduction to the fundamentals of logic and logic programming, a paradigm that uses
formal logic to express computational algorithms. The course focuses on propositional
and predicate logic, basics of proof techniques, principles of computational logic, and
logic programming concepts using Prolog-based logic programming languages, with an
emphasis on application to artificial intelligence.

**Prerequisites:** A grade of C or better in (CSC240++ and MAT227) or permission of
Program Director.

## Course Competencies (MCCCD)

1. Appraise the basic concepts and principles of logic as applied in a computer science context.
2. Apply logical reasoning in algorithm development and problem-solving.
3. Construct knowledge-representation schema for problems in artificial intelligence.
4. Develop solutions using a Prolog-based logic programming language.
5. Evaluate the use of logic programming for its applications in artificial intelligence and other domains.
6. Develop logic programming-based solutions for computational problems and applications in artificial intelligence.

## Repository Organization

The repository contains one directory per course module, numbered in course order:

```
01-propositional-and-predicate-logic/     Module 1  (Competencies 1, 2, 3)
02-logical-reasoning-and-proof-techniques/ Module 2  (Competencies 1, 2)
03-modeling-problems-and-limitations/     Module 3  (Competencies 1, 2, 5)
04-foundations-of-logic-programming/      Module 4  (Competencies 1, 2, 5)
05-prolog-review-and-core-mechanisms/     Module 5  (Competencies 3, 4)
06-advanced-prolog-techniques/            Module 6  (Competencies 4, 6)
07-data-structures-clp-and-integration/   Module 7  (Competencies 4, 5, 6)
08-midterm-review/                        Module 8  (Competencies 1-6, review)
09-knowledge-representation-and-logic-puzzles/ Module 9 (Competencies 3, 4, 6)
10-search-and-graph-algorithms/           Module 10 (Competencies 2, 4, 6)
11-planning-techniques/                   Module 11 (Competencies 4, 6)
12-expert-systems-and-rule-based-ai/      Module 12 (Competencies 3, 4, 5, 6)
13-neuro-symbolic-ai-and-ilp/             Module 13 (Competencies 5, 6)
14-evaluating-logic-programming/          Module 14 (Competency 5)
15-final-review-and-projects/             Module 15 (Competencies 1-6, review)
```

Each module directory contains a `README.md` describing the module, the competencies it
addresses, the sample files, how to run them, and a few **Student Extension Ideas**.

> **Note:** The examples in this repository are *instructional samples* — small,
> focused demonstrations intended for in-class demos, reading, and experimentation.
> They are **not** full assignments. Your instructor will distribute assignments
> separately.

## Required Tools

| Tool | Used for | Where to get it |
|---|---|---|
| **SWI-Prolog** (9.x recommended) | All Prolog examples | https://www.swi-prolog.org/Download.html |
| **SICStus Prolog** (4.x, optional) | Alternative Prolog system used in the course | https://sicstus.sics.se/ (commercial; campus license may apply) |
| **Python 3** (3.10+) | Python examples (no third-party packages required) | https://www.python.org/downloads/ |
| **SQLite 3** | SQL examples | https://www.sqlite.org/download.html (or `winget install SQLite.SQLite`) |

No third-party Python packages are required; all Python examples use only the standard library.

## How to Run the Prolog Examples

From a terminal, start SWI-Prolog with a file loaded:

```
swipl 05-prolog-review-and-core-mechanisms/review_basics.pl
```

or start `swipl` and consult a file from the Prolog prompt:

```prolog
?- [review_basics].          % loads review_basics.pl from the current directory
?- consult('review_basics.pl').  % equivalent, more explicit
```

Then type queries at the `?-` prompt. Press `;` (or spacebar) to ask for more
solutions, `Enter` to stop. Exit with `halt.`

In **SICStus Prolog**, start `sicstus` and use the same `consult/1` or `[file]`
syntax. Files that need SICStus-specific adjustments say so in their header comment
and in the module README.

Each module README lists example queries to try, and most files include a comment
block of suggested queries near the top.

## How to Run the Python Examples

```
python 01-propositional-and-predicate-logic/truth_tables.py
```

All Python examples are plain Python 3 scripts that print their results to the console.

## How to Run the SQL Examples

The SQL examples are written for SQLite:

```
sqlite3 < 05-prolog-review-and-core-mechanisms/movies.sql
```

or interactively:

```
sqlite3
sqlite> .read 05-prolog-review-and-core-mechanisms/movies.sql
```

## Prolog Compatibility Notes

The course may use both **SWI-Prolog** and **SICStus Prolog**. Keep the following in
mind when working with the examples:

- **Most examples are written in portable, ISO-style Prolog** wherever possible, and
  are expected to run in both SWI-Prolog and SICStus Prolog. Each file's header
  comment states which system(s) it targets.
- **Examples are tested primarily in SWI-Prolog**, the recommended implementation for
  the course. If you find a portability problem, see `CONTRIBUTING.md`.
- **SICStus Prolog may also be used in the course.** Where an example depends on a
  feature that differs between systems, the difference is called out in the file
  header and in the module README.
- **System-specific examples are clearly labeled** in both the code comments and the
  relevant module `README.md` (for example, the Python-integration demo in Module 7
  invokes the SWI-Prolog command-line tool `swipl` and is marked SWI-specific).
- **The two systems differ** in some libraries, built-in predicates, command-line
  usage, and development tooling. Differences you will most likely encounter in this
  course:
  - *List predicates:* `member/2`, `append/3`, `select/3`, etc. are built in (autoloaded)
    in SWI-Prolog but live in `library(lists)` in SICStus. The examples include
    `:- use_module(library(lists)).` where needed — this is harmless in SWI and
    required in SICStus.
  - *CLP(FD):* both systems provide `library(clpfd)`, but the domain-declaration
    syntax differs: SWI uses `Vars ins 1..9` while SICStus uses `domain(Vars, 1, 9)`.
    The CLP example in Module 7 shows both.
  - *`between/3`, `succ/2`, `forall/2`* and several other convenience predicates are
    built into SWI but not SICStus; portable examples avoid them or define local
    equivalents.
  - *Command line:* SWI-Prolog's executable is `swipl`; SICStus's is `sicstus`. Flags
    and top-level behavior differ (e.g., SWI's `swipl script.pl` vs. SICStus's
    `sicstus -l script.pl`).
  - *Tooling:* SWI-Prolog ships a graphical debugger, profiler, and unit-test framework
    (`plunit`); SICStus has its own IDE (SPIDER) and debugger. Course examples avoid
    depending on either toolchain.

## Other Root Files

- [`SETUP.md`](SETUP.md) — step-by-step installation instructions for Windows, macOS, and Linux.
- [`CONTRIBUTING.md`](CONTRIBUTING.md) — how students can report problems or suggest improvements.
- [`LICENSE`](LICENSE) — license placeholder (instructor: confirm the license your institution requires).

## Recommended Textbooks

- **Primary:** Bratko, *Prolog Programming for Artificial Intelligence*, 4th ed. (Addison-Wesley, 2011).
- Clocksin & Mellish, *Programming in Prolog: Using the ISO Standard*, 5th ed. (Springer, 2003).
- Bramer, *Logic Programming with Prolog*, 2nd ed. (Springer, 2013).
- Free online: SWI-Prolog documentation and tutorials; *Simply Logical — Intelligent Reasoning by Example*.
