# Module 14: Evaluation of Logic Programming in AI and Other Domains

The capstone discussion module: where does logic programming genuinely win, where
does it struggle, and how do you argue either case with evidence? The sample code is
one experiment repeated three ways: **the same problem — kinship queries over a family
tree — implemented in Prolog, Python, and SQL.** Reading the three files side by side
turns paradigm comparison from opinion into observation: count the lines, find where
each version hides its search, and notice which changes are cheap in one paradigm and
expensive in another.

## Competencies Addressed

- **5.** Evaluate the use of logic programming for its applications in artificial intelligence and other domains.

## Files

| File | Language | What it shows |
|---|---|---|
| `family_relations.pl` | Prolog (portable: SWI + SICStus) | The reference implementation: kinship rules in ~15 lines of logic; queries run in every direction; recursion (`ancestor/2`) is two clauses. |
| `family_relations.py` | Python 3 | The same relations procedurally: explicit loops, explicit recursion-with-visited-set, and a separate function per query *direction* — the cost of losing relationality. |
| `family_relations.sql` | SQL (SQLite) | The same relations relationally: joins for the flat queries (close to Prolog) and `WITH RECURSIVE` for ancestors (noticeably heavier). |

All three produce the same answers to the same five queries (Q1–Q5, numbered
identically in each file's comments).

## Running the Examples

```
swipl family_relations.pl
python family_relations.py
sqlite3 < family_relations.sql
```

In Prolog, also try the directions the other two can't do without new code:

```prolog
?- grandparent(tom, X).        % forward
?- grandparent(X, jim).        % backward -- same rule!
?- grandparent(X, Y).          % all pairs -- same rule!
```

## The Evaluation Framework (use this in discussion and assignments)

**Where logic programming excelled here:**
- *Brevity at the reasoning core* — compare `ancestor/2` (2 clauses) with the Python
  visited-set recursion and the SQL recursive CTE.
- *Multi-directional queries for free* — one `grandparent/2` rule answers forward,
  backward, and all-pairs queries; Python needed a function per direction.
- *Proximity to the specification* — the Prolog is nearly a transcription of the
  English definitions; great for KR-heavy AI (Modules 9–12) and for auditability
  (Module 12's explanation facility).

**Where the others excelled:**
- *Ecosystem and integration* — Python's libraries, tooling, and workforce dwarf
  Prolog's; this is the dominant real-world consideration (hence Module 7's
  integration pattern: logic core, conventional shell).
- *Set-at-a-time efficiency at scale* — SQL engines optimize joins over millions of
  rows; Prolog backtracks tuple-at-a-time. For pure data retrieval, the database wins.
- *Predictable performance* — Prolog's runtime depends on clause/goal order in ways
  that surprise newcomers (Modules 3, 9); procedural code's costs are more visible.

**Honest failure modes of logic programming** (each demonstrated earlier in the course):
non-termination under the standard strategy (Module 3), the cut's damage to
declarativeness (Module 6), negation's closed-world surprises (Module 6), and
weak numerical/statistical learning support (Module 13's motivation).

**Real-world deployments to cite:** IBM Watson's Prolog NLP rules; SICStus-based
airline crew scheduling (CLP); Datalog in program analysis (Soufflé) and networking;
ASP in industrial configuration; Prolog-derived business-rule engines.

## Student Extension Ideas

1. Add a `cousin/2` query to all three implementations; record how long each took
   you and which felt most natural.
2. Time `ancestor` on a 1,000-person synthetic family in Prolog and SQLite (script
   the data generation); which scales better, and why?
3. Write the one-paragraph "engineering memo": your team must add kinship reasoning
   to an existing Python product — argue for embedding Prolog (Module 7 style) or
   reimplementing in Python, using evidence from these files.
