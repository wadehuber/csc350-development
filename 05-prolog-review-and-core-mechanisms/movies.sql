-- Course:  CSC350: Logic Programming for Artificial Intelligence
-- Module:  5 - Prolog Review and Core Mechanisms
-- Competencies: 3 (knowledge representation), 4 (compare with Prolog solutions)
-- Purpose: The SQL twin of movies_database.pl. Same data, same queries,
--          numbered to match (Q1-Q3, V1-V3). Read the two files side by side
--          to compare logic-based and relational database programming.
-- Runs in: SQLite 3.   Usage:  sqlite3 < movies.sql

.mode column
.headers on

-- The "fact base" as tables ------------------------------------------------

CREATE TABLE movie (
    title TEXT PRIMARY KEY,
    year  INTEGER NOT NULL
);

CREATE TABLE directed (
    director TEXT NOT NULL,
    title    TEXT NOT NULL REFERENCES movie(title)
);

CREATE TABLE genre (
    title TEXT NOT NULL REFERENCES movie(title),
    genre TEXT NOT NULL
);

INSERT INTO movie VALUES
    ('alien', 1979), ('blade_runner', 1982), ('jurassic_park', 1993),
    ('schindlers_list', 1993), ('arrival', 2016), ('dune', 2021);

INSERT INTO directed VALUES
    ('scott', 'alien'), ('scott', 'blade_runner'),
    ('spielberg', 'jurassic_park'), ('spielberg', 'schindlers_list'),
    ('villeneuve', 'arrival'), ('villeneuve', 'dune');

INSERT INTO genre VALUES
    ('alien', 'horror'), ('alien', 'scifi'), ('blade_runner', 'scifi'),
    ('jurassic_park', 'scifi'), ('jurassic_park', 'adventure'),
    ('schindlers_list', 'drama'), ('arrival', 'scifi'), ('dune', 'scifi');

-- Q1. Movies after 1990.            Prolog: ?- movie(T, Y), Y > 1990.
SELECT 'Q1' AS query;
SELECT title, year FROM movie WHERE year > 1990;

-- Q2. Join: director, title, year.  Prolog: ?- directed(D, T), movie(T, Y).
--     The shared Prolog variable T becomes an explicit ON condition.
SELECT 'Q2' AS query;
SELECT d.director, d.title, m.year
FROM directed d JOIN movie m ON m.title = d.title;

-- Q3. Directors of sci-fi movies.
--     Prolog: ?- directed(D, T), genre(T, scifi), movie(T, Y).
SELECT 'Q3' AS query;
SELECT DISTINCT d.director, d.title, m.year
FROM directed d
JOIN genre g ON g.title = d.title
JOIN movie m ON m.title = d.title
WHERE g.genre = 'scifi';

-- V1. View: sci-fi directors.       Prolog rule: scifi_director/1
CREATE VIEW scifi_director AS
SELECT DISTINCT d.director
FROM directed d JOIN genre g ON g.title = d.title
WHERE g.genre = 'scifi';

SELECT 'V1' AS query;
SELECT * FROM scifi_director;

-- V2. Directors spanning two genres (a self-join).
--     Prolog rule: two_genre_director/1
SELECT 'V2' AS query;
SELECT DISTINCT d1.director
FROM directed d1
JOIN genre g1    ON g1.title = d1.title
JOIN directed d2 ON d2.director = d1.director
JOIN genre g2    ON g2.title = d2.title
WHERE g1.genre < g2.genre;

-- V3. Filmography per director.     Prolog rule: filmography/2 (findall)
SELECT 'V3' AS query;
SELECT director, GROUP_CONCAT(title, ', ') AS filmography
FROM directed GROUP BY director;

-- Recursion note: transitive closure (e.g., chains of sequels) needs
-- WITH RECURSIVE in SQL, e.g.:
--   WITH RECURSIVE follows(a, b) AS (
--       SELECT prequel, sequel FROM sequel
--       UNION
--       SELECT f.a, s.sequel FROM follows f JOIN sequel s ON s.prequel = f.b)
--   SELECT * FROM follows;
-- In Prolog the same idea is two short clauses -- see the closing comment
-- in movies_database.pl. This asymmetry is why deductive databases
-- (Datalog) borrow Prolog's rule syntax.
