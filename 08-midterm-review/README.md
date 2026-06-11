# Module 8: Midterm Review and Exam

This module is the comprehensive review of Modules 1–7 followed by the in-class
midterm. There is no new material; this directory provides a self-test file of small
practice predicates spanning the core topics, plus the checklist below for organizing
your review. Solutions are *not* included — the point is to attempt each one cold,
then check your work at the Prolog prompt (every practice predicate comes with test
queries and their expected results).

## Competencies Addressed

Cumulative review of competencies **1–6** as covered through the core material
(Modules 1–7), with the programming emphasis on competencies 2 and 4.

## Files

| File | Language | What it contains |
|---|---|---|
| `practice_problems.pl` | Prolog (portable: SWI + SICStus) | Ten small practice problems with `TODO` bodies and expected-result test queries: logic translation, family rules, list recursion, unification prediction, negation, cut behavior, and one generate-and-test puzzle. |

## How to Use This for Review

1. Copy `practice_problems.pl` to `my_practice.pl` (keep the original clean).
2. Work the problems in order — they are sequenced from Module 1 ideas to Module 7.
3. After each one, load the file and run the test queries given in the comments. The
   expected answers are listed; mismatches tell you exactly what to revisit.
4. The file loads even with unfinished problems (`TODO` bodies are written as
   failing stubs, and the directive warnings are harmless) — finish at your own pace.

## Review Checklist (Modules 1–7)

- **M1** Truth tables; tautology vs. contingency; predicates, constants, variables; ∃ via queries, ∀ via rules.
- **M2** Equivalence laws (De Morgan, contrapositive); modus ponens/tollens; the two classic fallacies; the four proof techniques.
- **M3** Modeling: choosing predicates and constraints; limits — undecidability, and Prolog's incomplete depth-first search (left recursion!).
- **M4** Horn clauses; SLD resolution; clause order vs. goal order; reading a trace; "Algorithm = Logic + Control".
- **M5** Facts/rules/queries; list recursion patterns (member/append/accumulators); unification vs. `==` vs. `=:=`; fact bases as databases, conjunctions as joins.
- **M6** `\+` and the closed-world assumption (ground goals only!); green vs. red cuts; `findall`/`bagof`/`setof` differences.
- **M7** Trees as terms; structural recursion; CLP(FD): constrain-then-search; why and how to integrate Prolog with other languages.

## Student Extension Ideas

1. Write three additional practice problems of your own, one per proof technique from
   Module 2, and trade with a classmate.
2. Time yourself: each practice problem should take under ten minutes; flag the ones
   that don't and re-read that module's samples.
3. For any problem you solved with a cut, write a cut-free version using
   if-then-else or `\+`, and decide which you'd defend in a code review.
