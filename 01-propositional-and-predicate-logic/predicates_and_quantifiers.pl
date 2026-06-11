/*  Course:  CSC350: Logic Programming for Artificial Intelligence
    Module:  1 - Propositional and Predicate Logic
    Competencies: 1 (appraise concepts of logic in a CS context),
                  3 (construct a knowledge-representation schema)
    Purpose: A first look at predicate logic in executable form: constants,
             predicates, variables, and how Prolog queries correspond to
             existential quantification while rules capture universally
             quantified statements.
    Runs in: SWI-Prolog AND SICStus Prolog (portable, ISO-style).

    Suggested queries:
      ?- enrolled(ava, csc350).          % a ground query: is this fact true?
      ?- enrolled(ava, Course).          % "does there EXIST a Course...?"
      ?- enrolled(Who, csc350).          % press ; for more answers
      ?- classmates(ava, Who).
      ?- overloaded(Who).
*/

:- use_module(library(lists)).   % needed by SICStus; harmless in SWI

/* ---------------------------------------------------------------------
   CONSTANTS name individuals in our domain: students (ava, ben, ...)
   and courses (csc350, mat227, ...). Lowercase = constant.

   PREDICATES state relations over those individuals.
   In logic:   Enrolled(ava, csc350)
   In Prolog:  enrolled(ava, csc350).
   --------------------------------------------------------------------- */

% student(S): S is a student.
student(ava).
student(ben).
student(carla).
student(diego).

% course(C, Credits): C is a course worth Credits credit hours.
course(csc350, 3).
course(mat227, 4).
course(csc240, 3).
course(eng102, 3).

% enrolled(Student, Course)
enrolled(ava,   csc350).
enrolled(ava,   mat227).
enrolled(ava,   eng102).
enrolled(ben,   csc350).
enrolled(ben,   csc240).
enrolled(carla, mat227).
enrolled(diego, csc350).
enrolled(diego, mat227).
enrolled(diego, csc240).
enrolled(diego, eng102).

/* ---------------------------------------------------------------------
   QUANTIFIERS.

   Existential (∃): a Prolog query with a variable asks "is there some
   binding that makes this true?"
       ?- enrolled(ava, C).        means   ∃C Enrolled(ava, C)

   Universal (∀): expressed with rules. The rule below reads:
       ∀S ∀X (Student(S) ∧ Enrolled(S, csc350) ∧ Enrolled(X, csc350)
              ∧ S ≠ X  →  Classmates(S, X))
   Variables in the head of a rule are implicitly universally quantified.
   --------------------------------------------------------------------- */

% classmates(S, X): S and X take csc350 together (and are different people).
classmates(S, X) :-
    enrolled(S, csc350),
    enrolled(X, csc350),
    S \== X.                     % syntactic inequality (ISO)

/* A "for all" CONDITION inside a definition uses negation:
   "S is overloaded if S is enrolled in at least 4 courses."
   We count by collecting solutions -- findall/3 is ISO and works in both
   SWI-Prolog and SICStus. */

% overloaded(S): student S is enrolled in 4 or more courses.
overloaded(S) :-
    student(S),
    findall(C, enrolled(S, C), Courses),
    length(Courses, N),
    N >= 4.

% total_credits(S, Total): sum of credit hours S is enrolled in.
total_credits(S, Total) :-
    student(S),
    findall(Cr, ( enrolled(S, C), course(C, Cr) ), Credits),
    sum_list_portable(Credits, Total).

% sum_list_portable/2: defined locally so the file runs unchanged in
% SICStus (SWI has sumlist/sum_list built in, SICStus does not).
sum_list_portable([], 0).
sum_list_portable([X|Xs], Sum) :-
    sum_list_portable(Xs, Rest),
    Sum is X + Rest.
