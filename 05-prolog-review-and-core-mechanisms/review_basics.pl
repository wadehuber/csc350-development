/*  Course:  CSC350: Logic Programming for Artificial Intelligence
    Module:  5 - Prolog Review and Core Mechanisms
    Competencies: 4 (develop solutions in Prolog)
    Purpose: A complete, compact review of facts, rules, queries, lists,
             and recursion. The list predicates are written from scratch
             (my_member, my_append, ...) so the recursion patterns are
             fully visible; in real code use the library versions.
    Runs in: SWI-Prolog AND SICStus Prolog (portable, ISO-style).

    Suggested queries:
      ?- likes(alice, X).
      ?- compatible(alice, Who).
      ?- my_member(b, [a, b, c]).
      ?- my_append(X, Y, [1, 2, 3]).      % press ; -- all splits of a list
      ?- my_length([a, b, c], N).
      ?- my_reverse([1, 2, 3], R).
*/

/* ------------------------- FACTS AND RULES ------------------------- */

likes(alice, prolog).
likes(alice, hiking).
likes(bob,   prolog).
likes(bob,   chess).
likes(carol, chess).
likes(carol, hiking).

% Two people are compatible if some interest is shared.
% The shared variable Thing is the "join" (compare movies_database.pl).
compatible(X, Y) :-
    likes(X, Thing),
    likes(Y, Thing),
    X \== Y.

/* ----------------------------- LISTS ------------------------------- */
/*  A list is either []  or  [Head|Tail] where Tail is a list.
    [a, b, c]  is sugar for  '[|]'(a, '[|]'(b, '[|]'(c, [])))  (SWI)
    -- the recursive structure is what makes recursive predicates fit
    lists so naturally.                                                */

% my_member(X, L): X occurs in list L.
my_member(X, [X|_]).             % X is the head, or...
my_member(X, [_|Tail]) :-        % ...X is in the tail.
    my_member(X, Tail).

% my_append(Front, Back, Whole): Whole is Front followed by Back.
my_append([], L, L).
my_append([H|T], L, [H|R]) :-
    my_append(T, L, R).

/*  my_append is RELATIONAL, not a function: it can build a list,
    take one apart, or enumerate every split, depending on which
    arguments are bound. Try all three:
      ?- my_append([1,2], [3], W).
      ?- my_append(F, [3], [1,2,3]).
      ?- my_append(F, B, [1,2,3]).                                     */

% my_length(L, N): list L has N elements.
my_length([], 0).
my_length([_|T], N) :-
    my_length(T, N1),
    N is N1 + 1.                 % arithmetic: `is` evaluates, `=` does not

% my_reverse(L, R) using an accumulator -- the standard technique for
% making list recursion efficient (linear instead of quadratic).
my_reverse(L, R) :-
    rev_acc(L, [], R).

rev_acc([], Acc, Acc).
rev_acc([H|T], Acc, R) :-
    rev_acc(T, [H|Acc], R).

% sum_list_p(L, Sum): sum of a numeric list (portable version; SWI has
% sum_list/2 built in, SICStus does not).
sum_list_p([], 0).
sum_list_p([X|Xs], Sum) :-
    sum_list_p(Xs, Rest),
    Sum is X + Rest.
