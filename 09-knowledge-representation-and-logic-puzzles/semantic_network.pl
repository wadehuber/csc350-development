/*  Course:  CSC350: Logic Programming for Artificial Intelligence
    Module:  9 - Knowledge Representation and Solving Logic Puzzles
    Competencies: 3 (construct KR schemas), 4 (develop Prolog solutions)
    Purpose: A semantic network -- an isa/2 taxonomy with property
             inheritance and exceptions. Demonstrates default reasoning:
             "birds fly" is inherited by every bird EXCEPT those with an
             explicit exception (penguins).
    Runs in: SWI-Prolog AND SICStus Prolog (portable, ISO-style).

    Suggested queries:
      ?- has_property(tweety, can_fly).
      ?- has_property(pingu, can_fly).        % exception blocks inheritance
      ?- has_property(pingu, P).              % press ; for all properties
      ?- isa_chain(pingu, Chain).
      ?- has_property(X, can_swim).
*/

:- use_module(library(lists)).

/* ------------------ THE NETWORK (the KR schema) --------------------
   Two relations carry the whole representation:
     isa(Child, Parent)            class/instance hierarchy ("is-a" links)
     prop(NodeOrClass, Property)   properties attached at any level
   plus one for exceptions:
     exception(Node, Property)     blocks inheritance of Property at Node
   ------------------------------------------------------------------- */

isa(animal,  thing).
isa(bird,    animal).
isa(fish,    animal).
isa(mammal,  animal).
isa(penguin, bird).
isa(canary,  bird).
isa(salmon,  fish).
isa(dog,     mammal).

% Individuals sit at the bottom of the same hierarchy.
isa(tweety, canary).
isa(pingu,  penguin).
isa(rex,    dog).
isa(sally,  salmon).

% Properties, attached at the most general level that is true.
prop(animal,  can_breathe).
prop(bird,    can_fly).
prop(bird,    has_feathers).
prop(fish,    can_swim).
prop(mammal,  has_fur).
prop(penguin, can_swim).      % penguins ADD a property birds lack...
prop(canary,  can_sing).
prop(dog,     can_bark).

% ...and BLOCK one birds have:
exception(penguin, can_fly).

/* ------------------ INFERENCE OVER THE NETWORK --------------------- */

% ancestor_class(Node, Class): Class is Node or any class above it.
ancestor_class(Node, Node).
ancestor_class(Node, Class) :-
    isa(Node, Parent),
    ancestor_class(Parent, Class).

% has_property(Node, P): Node inherits P from some class on its isa
% chain, unless an exception intervenes ANYWHERE along the chain
% between Node and where P is attached.
has_property(Node, P) :-
    ancestor_class(Node, Class),
    prop(Class, P),
    \+ blocked(Node, Class, P).

% blocked(Node, Class, P): some class between Node and Class (inclusive
% of Node's side) declares an exception for P.
blocked(Node, Class, P) :-
    ancestor_class(Node, Mid),
    ancestor_class(Mid, Class),
    exception(Mid, P).

% isa_chain(Node, Chain): the full path to the top, for inspection.
isa_chain(Node, [Node|Rest]) :-
    ( isa(Node, Parent) ->
        isa_chain(Parent, Rest)
    ;   Rest = []
    ).

/*  KR observations to discuss:

    1. INHERITANCE saves facts: can_breathe is stated once, yet holds
       for every individual. Economy of representation is the point.
    2. EXCEPTIONS make this NON-MONOTONIC: adding the penguin exception
       REMOVED a conclusion (pingu flies). Classical logic never does
       that; default reasoning is an AI extension, implemented here
       with negation as failure (Module 6).
    3. The same two-relation schema (isa + prop) underlies frames,
       description logics, and modern knowledge graphs.                */
