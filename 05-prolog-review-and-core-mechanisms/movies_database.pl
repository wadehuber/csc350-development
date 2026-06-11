/*  Course:  CSC350: Logic Programming for Artificial Intelligence
    Module:  5 - Prolog Review and Core Mechanisms
    Competencies: 3 (knowledge representation), 4 (develop Prolog solutions)
    Purpose: Logic-based database programming. A Prolog fact base IS a
             relational database: predicates are tables, facts are rows,
             conjunctive queries are joins, rules are views. Each query
             below has a numbered SQL twin in movies.sql -- read them
             side by side.
    Runs in: SWI-Prolog AND SICStus Prolog (portable, ISO-style).
*/

:- use_module(library(lists)).   % needed by SICStus; harmless in SWI

/* ----------------------- THE "TABLES" ------------------------------ */

% movie(Title, Year)
movie(alien,            1979).
movie(blade_runner,     1982).
movie(jurassic_park,    1993).
movie(schindlers_list,  1993).
movie(arrival,          2016).
movie(dune,             2021).

% directed(Director, Title)
directed(scott,      alien).
directed(scott,      blade_runner).
directed(spielberg,  jurassic_park).
directed(spielberg,  schindlers_list).
directed(villeneuve, arrival).
directed(villeneuve, dune).

% genre(Title, Genre)
genre(alien,           horror).
genre(alien,           scifi).
genre(blade_runner,    scifi).
genre(jurassic_park,   scifi).
genre(jurassic_park,   adventure).
genre(schindlers_list, drama).
genre(arrival,         scifi).
genre(dune,            scifi).

/* ----------------------- THE "QUERIES" ----------------------------- */
/* Q1. All movies released after 1990.   (SQL twin: Q1 in movies.sql)
      ?- movie(T, Y), Y > 1990.                                       */

/* Q2. JOIN: what has each director made, and when? The shared variable
      T joins the two relations.          (SQL twin: Q2)
      ?- directed(D, T), movie(T, Y).                                 */

/* Q3. Three-way join: directors of sci-fi movies.  (SQL twin: Q3)
      ?- directed(D, T), genre(T, scifi), movie(T, Y).                */

/* ----------------------- RULES AS VIEWS ---------------------------- */

% V1. scifi_director(D): D directed at least one sci-fi movie.
%     (SQL twin: view V1)
scifi_director(D) :-
    directed(D, T),
    genre(T, scifi).

% V2. two_genre_director(D): D has directed movies in two different
%     genres -- a self-join in SQL.       (SQL twin: V2)
two_genre_director(D) :-
    directed(D, T1),
    genre(T1, G1),
    directed(D, T2),
    genre(T2, G2),
    G1 @< G2.            % standard order comparison avoids duplicates

% V3. filmography(D, Titles): aggregate all of D's movies into a list.
%     findall/3 plays the role of SQL's GROUP BY + aggregation.
%     (SQL twin: V3 uses GROUP_CONCAT)
filmography(D, Titles) :-
    directed(D, _),                       % ensure D is a known director
    findall(T, directed(D, T), Ts),
    sort(Ts, Titles).                     % sort also removes duplicates

/* Where Prolog pulls ahead of SQL: RECURSIVE queries. Add
       sequel(alien, aliens).  sequel(aliens, alien3).
   and transitive closure is two natural clauses:
       follows(X, Y) :- sequel(Y, X).
       follows(X, Y) :- sequel(Z, X), follows(Z, Y).
   The SQL equivalent needs WITH RECURSIVE (see note at the bottom of
   movies.sql). Deductive databases (Datalog) are built on exactly this
   observation. */
