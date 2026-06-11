# Module 5: Prolog Review and Core Mechanisms

A consolidation module: a quick, complete review of facts, rules, queries, lists, and
recursion, followed by the two mechanisms that make Prolog tick — **unification**
(how arguments are passed and data is both built and taken apart) and **logic-based
database programming** (a Prolog fact base is a relational database you query with
logic). The database example is paired with an equivalent SQLite script so you can see
the same relations, joins, and queries in both paradigms side by side.

## Competencies Addressed

- **3.** Construct knowledge-representation schema for problems in artificial intelligence.
- **4.** Develop solutions using a Prolog-based logic programming language.

## Files

| File | Language | What it shows |
|---|---|---|
| `review_basics.pl` | Prolog (portable: SWI + SICStus) | Facts, rules, queries; list basics; recursion over lists (`my_member/2`, `my_append/3`, `my_length/2`, `my_reverse/2`) written out so the recursion pattern is explicit. |
| `unification_examples.pl` | Prolog (portable: SWI + SICStus) | Unification with `=/2`: variables, structures, partial instantiation, building/decomposing terms, why `=/2` differs from `==/2` and `=:=/2`, and a note on the occurs check. |
| `movies_database.pl` | Prolog (portable: SWI + SICStus) | A small movie database as a fact base; rules play the role of views; conjunctive queries play the role of joins. |
| `movies.sql` | SQL (SQLite) | The same movie database as tables, with the equivalent SQL `SELECT`/`JOIN` for each Prolog query — read the two files side by side. |

## Running the Examples

```
swipl review_basics.pl
swipl unification_examples.pl
swipl movies_database.pl
```

```prolog
?- my_append(X, Y, [1,2,3]).            % all ways to split a list!
?- directed(spielberg, M), released(M, Y), Y > 1990.
?- two_genre_director(D).
```

SQL (the script creates tables, inserts data, runs the comparison queries, and prints
results):

```
sqlite3 < movies.sql
```

## Unification vs. Assignment (the module's key idea)

`X = f(Y, 3)` is not assignment — it is a *constraint* that two terms be made
identical, solved by binding variables on **either side**. That single mechanism gives
Prolog parameter passing, data construction, data destructuring, and pattern matching.
`unification_examples.pl` walks through each role with small queries.

**Occurs check note:** ISO `=/2` omits the occurs check for speed, so
`?- X = f(X).` creates a cyclic term in both SWI and SICStus rather than failing. The
ISO-standard `unify_with_occurs_check/2` (available in both systems) does it properly —
the file demonstrates both.

## Prolog vs. SQL (logic-based database programming)

| Concept | Prolog | SQL |
|---|---|---|
| Relation | predicate (`movie/2`) | table |
| Tuple | fact | row |
| Query | goal with variables | `SELECT` |
| Join | shared variable in a conjunction | `JOIN ... ON` |
| View | rule | `CREATE VIEW` |
| Recursion | natural (recursive rules) | `WITH RECURSIVE` (verbose) |

Read `movies_database.pl` and `movies.sql` together — each Prolog query has its SQL
twin, labeled with the same number.

## Student Extension Ideas

1. Add `my_last/2` and `my_nth/3` to `review_basics.pl` using the same recursion
   patterns as the existing predicates.
2. In `movies_database.pl`, add an `actor(Movie, Actor)` relation and write the
   "co-star" query (two actors who appear in the same movie) — then write its SQL twin
   in `movies.sql`.
3. Use `unification_examples.pl` as a quiz: for each suggested query, predict the
   bindings *before* running it. Keep score.
4. Write the `sequel_of/2` transitive closure (a movie's sequel's sequel…) in Prolog,
   then attempt it in SQLite with `WITH RECURSIVE` and compare effort.
