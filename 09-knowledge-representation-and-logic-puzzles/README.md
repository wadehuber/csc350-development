# Module 9: Knowledge Representation and Solving Logic Puzzles

The applications half of the course opens with the central question of symbolic AI:
*how do we encode what we know so that a machine can reason with it?* This module
practices constructing knowledge-representation (KR) schemas — choosing individuals,
relations, hierarchies, and defaults — and then exercises those skills on logic
puzzles, where a good representation does most of the solving.

Two KR styles are demonstrated: a **semantic network** (an `isa` hierarchy with
property inheritance and exceptions — the classic frame-style representation) and the
**constraint-style representation** used for grid logic puzzles, culminating in the
famous Zebra Puzzle.

## Competencies Addressed

- **3.** Construct knowledge-representation schema for problems in artificial intelligence.
- **4.** Develop solutions using a Prolog-based logic programming language.
- **6.** Develop logic programming-based solutions for computational problems and applications in artificial intelligence.

## Files

| File | Language | What it shows |
|---|---|---|
| `semantic_network.pl` | Prolog (portable: SWI + SICStus) | An `isa/2` taxonomy of animals with property inheritance (`has_property/2` walks the hierarchy) and *exceptions* (penguins don't fly) — default reasoning via negation as failure. |
| `mini_puzzle.pl` | Prolog (portable: SWI + SICStus) | A small 3-house logic puzzle solved with the representation pattern used for all grid puzzles: a list of house terms + `member/2` constraints. Read this **before** the zebra puzzle. |
| `zebra_puzzle.pl` | Prolog (portable: SWI + SICStus) | The classic 5-house Zebra Puzzle ("Who owns the zebra?") in pure Prolog. Same pattern as `mini_puzzle.pl`, scaled up. |

## Running the Examples

```
swipl semantic_network.pl
```

```prolog
?- has_property(tweety, can_fly).
?- has_property(pingu, can_fly).      % false: exception wins
?- has_property(pingu, P).            % everything inherited by pingu
?- isa_chain(pingu, Chain).
```

```
swipl mini_puzzle.pl
```

```prolog
?- solve(Houses), report(Houses).
```

```
swipl zebra_puzzle.pl
```

```prolog
?- zebra(Owner, Houses).              % takes well under a second
```

All three files are portable between SWI-Prolog and SICStus Prolog
(`library(lists)` is loaded for `member/2`, `select/3`, etc.).

## The Representation Lesson

The zebra puzzle looks hard, but notice what the Prolog program contains: **no
algorithm at all** — only (1) a schema, `house(Color, Nation, Pet, Drink, Smoke)`,
(2) one `member/2` or `next_to/3` goal per clue, and (3) Prolog's built-in search.
Choosing the *house list* as the central data structure is the act of knowledge
representation; once it's chosen, the fifteen clues transcribe almost word for word.
A poor schema (say, separate facts per attribute) makes the same puzzle miserable.
That contrast is the module's main point — bring it up in class discussion.

## Expected Output / Experimentation Notes

- `zebra/2` should produce a unique solution (the Japanese owns the zebra) — if you
  get multiple solutions on `;`, a clue is missing or mistranscribed.
- In `semantic_network.pl`, query `?- has_property(X, can_swim).` to see inheritance
  run "downhill" to every individual under `fish` and `penguin`.

## Student Extension Ideas

1. Add a `bat` to the semantic network (mammal, but flies) and verify the exception
   machinery handles a *positive* exception, not just a negative one.
2. Extend `mini_puzzle.pl` with a fourth house and a new clue of your own design;
   check the solution is still unique.
3. Instrument `zebra_puzzle.pl`: reorder two clue goals and measure the runtime
   difference (`time/1` in SWI) — goal order is search-strategy choice in disguise.
4. Write down (in English) a knowledge-representation schema for your campus's
   buildings, departments, and offices, then implement five facts and two inheritance
   rules in the style of `semantic_network.pl`.
