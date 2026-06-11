-- Course:  CSC350: Logic Programming for Artificial Intelligence
-- Module:  14 - Evaluation of Logic Programming in AI and Other Domains
-- Competencies: 5 (evaluate logic programming vs other paradigms)
-- Purpose: The relational contestant in the three-paradigm comparison.
--          Same data and queries (Q1-Q5) as family_relations.pl and
--          family_relations.py. Joins track the Prolog closely; recursion
--          (Q4/Q5) is where the paradigms visibly diverge.
-- Runs in: SQLite 3.   Usage:  sqlite3 < family_relations.sql

.mode column
.headers on

-- ---- Data: identical to the Prolog facts and the Python list -------------

CREATE TABLE parent (
    p TEXT NOT NULL,    -- the parent
    c TEXT NOT NULL     -- the child
);

INSERT INTO parent VALUES
    ('pam', 'bob'), ('tom', 'bob'), ('tom', 'liz'),
    ('bob', 'ann'), ('bob', 'pat'), ('pat', 'jim');

-- Q1. Grandchildren of tom.
--     Prolog: grandparent(tom, X). One self-join: close to the rule.
SELECT 'Q1' AS query;
SELECT g2.c AS grandchild
FROM parent g1 JOIN parent g2 ON g2.p = g1.c
WHERE g1.p = 'tom';

-- Q2. Grandparents of jim. Same join SHAPE, different WHERE -- SQL,
--     like Prolog and unlike Python, gets the reverse direction cheaply.
SELECT 'Q2' AS query;
SELECT g1.p AS grandparent
FROM parent g1 JOIN parent g2 ON g2.p = g1.c
WHERE g2.c = 'jim';

-- Q3. Siblings of ann.
SELECT 'Q3' AS query;
SELECT DISTINCT s2.c AS sibling
FROM parent s1 JOIN parent s2 ON s1.p = s2.p
WHERE s1.c = 'ann' AND s2.c <> 'ann';

-- Q4. Descendants of tom: transitive closure needs WITH RECURSIVE.
--     Compare ancestor/2 in family_relations.pl: two clauses.
SELECT 'Q4' AS query;
WITH RECURSIVE descendant(person) AS (
    SELECT c FROM parent WHERE p = 'tom'
    UNION
    SELECT parent.c FROM parent JOIN descendant ON parent.p = descendant.person
)
SELECT person AS descendant_of_tom FROM descendant;

-- Q5. Ancestors of jim: the same CTE pattern, reversed.
SELECT 'Q5' AS query;
WITH RECURSIVE ancestor(person) AS (
    SELECT p FROM parent WHERE c = 'jim'
    UNION
    SELECT parent.p FROM parent JOIN ancestor ON parent.c = ancestor.person
)
SELECT person AS ancestor_of_jim FROM ancestor;

-- Scorecard notes:
--   - Q1-Q3: SQL ~= Prolog in spirit (declarative, direction-flexible),
--     just wordier. Both beat the procedural version on flexibility.
--   - Q4/Q5: WITH RECURSIVE works but reads like machinery; Prolog's
--     two-clause ancestor/2 reads like the definition.
--   - On a MILLION-row parent table, SQLite's optimizer and indexes
--     would crush tuple-at-a-time backtracking. Scale flips winners --
--     which is why deductive databases (Datalog) chase both at once.
