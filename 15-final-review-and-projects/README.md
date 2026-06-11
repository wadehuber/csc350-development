# Module 15: Final Exam Review, Project Presentations, and Exam

The course closes with a comprehensive review of all modules, capstone project
presentations, and the final exam. This directory provides two supports: the review
map below (every module, its competencies, and the one question you should be able to
answer about it) and `capstone_starter.pl`, a small but complete skeleton showing how
to organize a multi-part Prolog project — knowledge base, reasoning rules, search,
test queries, and a runnable demo — so presentations start from sound structure
rather than a blank file.

## Competencies Addressed

Cumulative: competencies **1–6**. The capstone project is the natural place to
demonstrate competency 6 (develop logic programming-based solutions for computational
problems and applications in AI) end to end.

## Files

| File | Language | What it contains |
|---|---|---|
| `capstone_starter.pl` | Prolog (portable: SWI + SICStus) | A project skeleton with the recommended five sections (facts / rules / search / demo / tests), a working miniature example in each section (campus-navigation theme), and `run_tests/0` + `demo/0` entry points to replace with your own. |

## Review Map (all modules)

| Module | Competencies | The one question to be able to answer |
|---|---|---|
| 1. Propositional & predicate logic | 1, 2, 3 | Given a formula, build its truth table; given English, write the quantified formula. |
| 2. Reasoning & proofs | 1, 2 | Which inference patterns are valid, which are fallacies, and which proof technique fits a given claim? |
| 3. Modeling & limitations | 1, 2, 5 | Model a constraint problem as predicates; explain why a logically correct program can loop. |
| 4. Foundations of LP | 1, 2, 5 | Walk through SLD resolution on a 3-clause program; state "Algorithm = Logic + Control". |
| 5. Prolog core | 3, 4 | Write a recursive list predicate cold; predict unification results; relate fact bases to relational databases. |
| 6. Advanced Prolog | 4, 6 | Use `\+` safely (ground goals!); tell a green cut from a red one; choose between findall/bagof/setof. |
| 7. Data structures, CLP, integration | 4, 5, 6 | Recurse over a tree term; explain constrain-then-search; sketch the logic-core/shell architecture. |
| 8. Midterm | 1–6 | (Review checkpoint.) |
| 9. KR & puzzles | 3, 4, 6 | Design a representation schema and defend it; solve a grid puzzle with member-based constraints. |
| 10. Search | 2, 4, 6 | Implement DFS/BFS with visited lists; explain when A* is optimal. |
| 11. Planning | 4, 6 | Define a STRIPS action (preconditions, add, delete); explain the Sussman anomaly. |
| 12. Expert systems | 3, 4, 5, 6 | Build askable rules with working memory; explain why explanation facilities matter. |
| 13. Neuro-symbolic & ILP | 5, 6 | Describe what ILP learns and what neural nets can't give you (and vice versa). |
| 14. Evaluation | 5 | Argue, with evidence, when logic programming is and is not the right tool. |

## Capstone Project Suggestions

Scoped for 2–3 weeks; each exercises at least three competencies:

1. **Course scheduler** (Modules 3, 7, 9): CLP(FD)-based timetabler for one
   department's offerings with room/time/instructor constraints.
2. **Campus route advisor** (Modules 10, 12): A* over real building coordinates, with
   an expert-system layer for accessibility preferences.
3. **Logic-puzzle workbench** (Modules 6, 9): a solver supporting three puzzle
   families with a shared representation and a "why" trace.
4. **Mini medical/it-support triage advisor** (Modules 12, 13): askable expert system
   with certainty factors plus a written evaluation against a learned classifier.
5. **Blocks-world+ planner** (Modules 10, 11): extend the STRIPS planner with action
   costs and compare iterative deepening vs. A* over plans.

## Student Extension Ideas

1. Restructure your own project to match the five sections of `capstone_starter.pl`
   and have a classmate run `run_tests/0` cold — fix whatever confuses them.
2. Add two failing tests to your project *first*, then implement until they pass.
3. Prepare the 90-second version of your presentation: the problem, the
   representation, one query, one limitation.
