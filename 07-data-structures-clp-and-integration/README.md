# Module 7: Advanced Data Structures, CLP, and Language Integration

Three topics close out the core-Prolog half of the course. First, **advanced data
structures**: representing and processing binary trees with recursive terms — the
pattern that scales to parse trees, decision trees, and game trees in AI. Second,
**Constraint Logic Programming (CLP)**: replacing generate-and-test with *constrain,
then search*, using `library(clpfd)` to solve the classic SEND+MORE=MONEY puzzle in
milliseconds. Third, **integration with other languages**: calling SWI-Prolog from
Python, the pragmatic architecture of most deployed logic-programming systems
(logic core + conventional-language shell).

## Competencies Addressed

- **4.** Develop solutions using a Prolog-based logic programming language.
- **5.** Evaluate the use of logic programming for its applications in artificial intelligence and other domains (efficiency trade-offs; when to integrate).
- **6.** Develop logic programming-based solutions for computational problems and applications in artificial intelligence.

## Files

| File | Language | Portability | What it shows |
|---|---|---|---|
| `binary_trees.pl` | Prolog | **Portable: SWI + SICStus** | Binary search trees as terms `t(Left, Value, Right)`: insertion, membership, in-order traversal, height, counting. |
| `clpfd_sendmore.pl` | Prolog | **SWI and SICStus, with a labeled difference** | SEND+MORE=MONEY with `library(clpfd)`. Both systems ship clpfd, but domain declarations differ: SWI's `Vars ins 0..9` vs. SICStus's `domain(Vars, 0, 9)`. The file uses SWI syntax and shows the SICStus line in a clearly marked comment. |
| `call_prolog.py` | Python 3 | **SWI-specific** (invokes the `swipl` executable) | Calls Prolog from Python via subprocess: Python sends a goal, Prolog answers, Python post-processes. Demonstrates the standard hybrid architecture without third-party packages. |
| `kb_for_python.pl` | Prolog | Portable source, run via SWI from the Python demo | The small route-finding knowledge base that `call_prolog.py` queries. |

## Running the Examples

```
swipl binary_trees.pl
```

```prolog
?- list_to_bst([5,3,8,1,4], T).
?- list_to_bst([5,3,8,1,4], T), inorder(T, Sorted).   % tree sort!
?- list_to_bst([5,3,8,1,4], T), bst_member(4, T).
```

```
swipl clpfd_sendmore.pl
```

```prolog
?- send_more_money(Digits).
?- time(send_more_money(D)).      % SWI: see how few inferences CLP needs
```

Python-integration demo (requires `swipl` on your PATH):

```
python call_prolog.py
```

## System-Specific Notes (read before running on SICStus)

- `clpfd_sendmore.pl` — **runs in both systems** after one substitution: replace the
  `Vars ins 0..9` line with `domain(Vars, 0, 9)` as shown in the adjacent comment.
  Everything else (`#=`, `all_different/1`, `labeling/2`) is the same in both.
- `call_prolog.py` — **SWI-only**: it shells out to `swipl -g ... -t halt`, SWI's
  command-line flags. SICStus's equivalent CLI differs (`sicstus --goal ...`); porting
  it is one of the extension ideas below.
- `binary_trees.pl` — fully portable ISO Prolog.

## Expected Output / Experimentation Notes

- The unique solution to SEND+MORE=MONEY is 9567 + 1085 = 10652; the program should
  print it essentially instantly. Compare with how long Module 6's `slow_sort/2`
  takes on 8 elements — same search problem class, radically different strategy.
- `call_prolog.py` prints routes found by the Prolog KB and then a Python-side
  summary table, showing each language doing what it is best at.

## Student Extension Ideas

1. Add `bst_delete/3` to `binary_trees.pl` (the two-children case is the interesting
   one) and verify with `inorder/2` that the BST property survives.
2. In `clpfd_sendmore.pl`, solve a different cryptarithm (e.g., TWO+TWO=FOUR) by
   editing only the constraint section.
3. Change `labeling([], Vars)` to `labeling([ffc], Vars)` (both systems support it)
   and read your system's documentation to find out what first-fail ordering does.
4. Port `call_prolog.py` to SICStus by adjusting the command-line invocation — then
   add a comment block documenting the CLI differences you had to handle.
