# Module 6: Advanced Prolog Programming Techniques

This module covers the parts of Prolog that go beyond pure logic: **negation as
failure** (`\+`) and the closed-world assumption behind it, the **cut** (`!`) and how
it prunes the search tree (with the crucial green-cut/red-cut distinction), and
**nondeterministic programming** — embracing multiple solutions as a feature, steering
backtracking, and collecting solution sets with `findall/3`, `bagof/3`, and `setof/3`.

These features are where Prolog's declarative reading and procedural reality part
ways, so each example pairs a "what it means logically" comment with a "what the
engine actually does" comment. For AI work this matters directly: negation as failure
*is* the closed-world reasoning used by databases and planners, and nondeterminism
*is* the search behavior that Modules 9–11 exploit.

## Competencies Addressed

- **4.** Develop solutions using a Prolog-based logic programming language.
- **6.** Develop logic programming-based solutions for computational problems and applications in artificial intelligence.

## Files

| File | Language | What it shows |
|---|---|---|
| `negation_as_failure.pl` | Prolog (portable: SWI + SICStus) | `\+` as "not provable"; the closed-world assumption; the classic unbound-variable trap (`\+ G` with `G` unground) and how goal order fixes it. |
| `cut_examples.pl` | Prolog (portable: SWI + SICStus) | The cut step by step: `max/3` with and without a cut (green cut), a red cut that silently changes meaning, and `once/1`-style commitment. |
| `nondeterminism.pl` | Prolog (portable: SWI + SICStus) | Multiple solutions as a programming tool: generators, generate-and-test, permutation sort (deliberately naive), and `findall` / `bagof` / `setof` compared on the same goal. |

## Running the Examples

```
swipl negation_as_failure.pl
swipl cut_examples.pl
swipl nondeterminism.pl
```

Each file opens with a numbered list of suggested queries; run them in order. Good
starting points:

```prolog
?- can_fly(tweety).            % negation_as_failure.pl
?- can_fly(pingu).
?- bachelor(X).                % the trap, and bachelor_fixed(X)
?- max_nocut(3, 7, M).         % cut_examples.pl: press ; after the answer
?- max_cut(3, 7, M).
?- slow_sort([3,1,2], S).      % nondeterminism.pl
```

All three files are portable between SWI-Prolog and SICStus Prolog. (`bagof/3`,
`setof/3`, `findall/3`, and `\+/1` are all ISO.) The only system difference you may
notice: SWI prints `false` where SICStus prints `no`.

## Expected Output / Experimentation Notes

- In `negation_as_failure.pl`, `?- bachelor(X).` fails even though bachelors exist in
  the knowledge base — work through the comment explaining why `\+ married(X)` with
  unbound `X` means "is there no married person at all?", then run `bachelor_fixed/1`.
- In `cut_examples.pl`, compare `;`-pressing after `max_nocut/3` vs `max_cut/3`: the
  cut removes the spurious choice point. Then study `first_red/2` — deleting its cut
  changes the *answers*, not just the efficiency. That's the red cut.
- In `nondeterminism.pl`, compare `findall` (always succeeds, one flat list) with
  `bagof` (fails if no solutions; groups by free variables) on `likes/2` — the
  difference surprises everyone once.

## Student Extension Ideas

1. Write `safe_delete(X, List, Rest)` that uses `\+` to fail gracefully when `X` is
   absent, and compare with plain `select/3` behavior.
2. Rewrite `max_cut/3` using if-then-else (`( C -> T ; E )`) and argue which version
   is clearer. (If-then-else is ISO and contains a hidden cut.)
3. Add a `coin/1` generator to `nondeterminism.pl` and use it to enumerate all 3-coin
   sequences; then constrain to sequences with exactly two heads.
4. Measure how slow `slow_sort/2` gets on lists of length 7, 8, 9 (use your system's
   timing: `time/1` in SWI, `statistics/2` in both) — a concrete cost-of-search lesson
   that Module 7's CLP example answers.
