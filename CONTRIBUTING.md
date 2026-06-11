# Contributing to the CSC350 Course Repository

This repository holds instructional sample code for CSC350: Logic Programming for
Artificial Intelligence. Students are encouraged to experiment with the examples —
that's what they're for — but please follow these guidelines when suggesting changes.

## Reporting Problems

If an example does not load or behaves differently than its README describes:

1. Note which Prolog system and version you used (`swipl --version` or the SICStus
   startup banner) — many issues are SWI vs. SICStus portability differences.
2. Include the exact query you typed and the output or error message you got.
3. Open a GitHub issue (or email the instructor) with that information.

## Suggesting Improvements

- Keep examples **small and focused**. One concept per file beats one file that does
  everything.
- Match the existing style: a header comment block identifying the course, module,
  competencies, purpose, and target Prolog system(s); short clauses; comments that
  explain *why*, not just *what*.
- Prefer **portable ISO-style Prolog**. If a change requires an SWI- or
  SICStus-specific feature, say so in the file header and the module README, and
  prefer an isolated, clearly named file (e.g., `swi_example.pl`).
- Test in SWI-Prolog before submitting. If you can also test in SICStus, even better —
  say which systems you tested in your pull request description.

## What Not to Submit

- Solutions to course assignments or exams.
- Large frameworks or multi-file projects — this repo is for small teaching examples.
- Code that depends on third-party packages (Python examples must run on the standard
  library alone).
