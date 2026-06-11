/*  Course:  CSC350: Logic Programming for Artificial Intelligence
    Module:  13 - Neuro-Symbolic AI and Inductive Logic Programming
    Competencies: 5 (evaluate logic programming in AI), 6 (logic
                  programming solutions for AI)
    Purpose: A miniature Inductive Logic Programming (ILP) system.
             Given positive and negative EXAMPLES of daughter/2 and
             BACKGROUND knowledge (parent/2, female/1, male/1), it
             searches candidate rule bodies and returns one that covers
             every positive example and no negative example --
             learning a logical rule from data.
    Runs in: SWI-Prolog AND SICStus Prolog (portable, ISO-style).

    Suggested queries:
      ?- learn(daughter, RuleText).
      ?- show_search.
*/

:- use_module(library(lists)).

/* ------------------- BACKGROUND KNOWLEDGE -------------------------- */

parent(ann, mary).      % ann is mary's parent
parent(ann, tom).
parent(tom, eve).
parent(tom, ian).
female(ann). female(mary). female(eve).
male(tom).   male(ian).

/* ------------------- TRAINING EXAMPLES ----------------------------- */
/*  The target concept daughter(Child, Parent) is NOT defined anywhere
    in this file -- the learner must induce it.                         */

pos(daughter, mary, ann).        % mary IS a daughter of ann
pos(daughter, eve,  tom).
neg(daughter, tom,  ann).        % tom is NOT a daughter (male)
neg(daughter, eve,  ann).        % eve is NOT a daughter OF ANN
neg(daughter, ian,  tom).

/* ------------------- THE HYPOTHESIS SPACE -------------------------- */
/*  candidate_body(A, B, Goals, Text): Goals is a candidate body for
        target(A, B) :- Goals.
    A and B are the head variables, shared with the goals. Candidates
    are ordered general -> specific. A real ILP system GENERATES this
    lattice with refinement operators over the background predicates;
    we enumerate it explicitly so the search is fully inspectable.      */

candidate_body(A, _B, [female(A)],               'female(A)').
candidate_body(A, B,  [parent(B, A)],            'parent(B,A)').
candidate_body(A, B,  [parent(A, B)],            'parent(A,B)').
candidate_body(A, B,  [female(A), parent(A, B)], 'female(A), parent(A,B)').
candidate_body(A, B,  [female(A), parent(B, A)], 'female(A), parent(B,A)').
candidate_body(A, B,  [male(A),   parent(B, A)], 'male(A), parent(B,A)').

/* ------------------- COVERAGE TESTING ------------------------------ */

% covers(+CandidateText, +X, +Y): a FRESH copy of the candidate body,
% with head variables bound to X and Y, succeeds against the background
% knowledge. copy_term/2 (ISO) renames variables so one test never
% pollutes the next -- the same care a real ILP engine must take.
covers(Text, X, Y) :-
    candidate_body(A, B, Goals, Text),
    copy_term(t(A, B, Goals), t(X, Y, FreshGoals)),
    call_all(FreshGoals).

call_all([]).
call_all([G|Gs]) :- call(G), call_all(Gs).

/* ------------------- THE LEARNER ----------------------------------- */
/*  A hypothesis is CONSISTENT when it covers ALL positive examples
    and NO negative example. This is the core ILP loop; real systems
    add clause refinement, search heuristics, noise tolerance, and
    predicate invention.                                                */

consistent(Target, Text) :-
    \+ ( pos(Target, X, Y), \+ covers(Text, X, Y) ),    % all positives
    \+ ( neg(Target, X, Y),    covers(Text, X, Y) ).    % no negatives

% learn(+Target, -Text): first consistent hypothesis, general-first.
learn(Target, Text) :-
    candidate_body(_, _, _, Text),
    consistent(Target, Text),
    !,
    write('Learned:  '), write(Target), write('(A,B) :- '),
    write(Text), nl.

% show_search: every candidate with its verdict -- watch the negative
% examples reject the over-general hypotheses. Negative examples are
% what force SPECIALIZATION; delete them and re-run to see the learner
% over-generalize.
show_search :-
    candidate_body(_, _, _, Text),
    ( consistent(daughter, Text)        -> Verdict = 'CONSISTENT  <-- learnable'
    ; \+ all_pos_covered(daughter, Text) -> Verdict = 'rejected: misses a positive'
    ;                                       Verdict = 'rejected: covers a negative'
    ),
    write(Text), write('  =>  '), write(Verdict), nl,
    fail.
show_search.

all_pos_covered(Target, Text) :-
    \+ ( pos(Target, X, Y), \+ covers(Text, X, Y) ).

/*  Expected:  learn(daughter, T)  induces
        daughter(A,B) :- female(A), parent(B,A).

    Why ILP matters in the neuro-symbolic story: the OUTPUT is a
    Prolog rule -- readable, auditable, and immediately usable by every
    technique in this course (it plugs straight into Module 12's rule
    bases). Compare the perceptron in neuro_symbolic_demo.py, whose
    "knowledge" is a weight vector no one can read. Modern systems
    (Progol, Aleph, Popper) learn recursive multi-clause programs from
    hundreds of examples by searching exactly this kind of hypothesis
    space, just far more cleverly.                                      */
