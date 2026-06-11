/*  Course:  CSC350: Logic Programming for Artificial Intelligence
    Module:  12 - Expert Systems and Rule-Based AI Applications
    Competencies: 3 (KR as rule bases), 4 (Prolog solutions),
                  6 (AI applications)
    Purpose: A classic interactive identification expert system. Rules
             classify an animal from yes/no attributes; the system asks
             the user only for attributes it needs, and remembers the
             answers (working memory via assertz/retractall).
    Runs in: SWI-Prolog AND SICStus Prolog. Uses ISO read/1 for input:
             ANSWER WITH  yes.  OR  no.  (the period matters!).

    Usage:
      ?- identify(Animal).
      ?- restart.                % forget all answers, start over
*/

% Working memory: answers the user has already given.
% (ISO directive `dynamic`; identical in SWI and SICStus.)
:- dynamic(known/2).

/* ------------------- THE RULE BASE --------------------------------- */
/*  Identification rules, most specific knowledge first. Each goal
    like has(stripes) either uses a remembered answer or asks.
    This rule format -- IF attributes THEN class -- is the canonical
    expert-system knowledge representation.                             */

animal(cheetah)   :- mammal, carnivore, has(tawny_color), has(dark_spots).
animal(tiger)     :- mammal, carnivore, has(tawny_color), has(black_stripes).
animal(giraffe)   :- mammal, ungulate, has(long_neck), has(dark_spots).
animal(zebra)     :- mammal, ungulate, has(black_stripes).
animal(ostrich)   :- bird, \+ can(fly), has(long_neck).
animal(penguin)   :- bird, \+ can(fly), can(swim).
animal(albatross) :- bird, can(fly), has(long_wings).

% Intermediate concepts -- rules can build on rules.
mammal    :- has(hair).
mammal    :- gives(milk).
bird      :- has(feathers).
bird      :- can(fly), lays(eggs).
carnivore :- eats(meat).
carnivore :- has(pointed_teeth), has(claws).
ungulate  :- mammal, has(hooves).

/* ------------------- ASKABLE ATTRIBUTES ---------------------------- */
/*  Every primitive attribute funnels through ask/2, which consults
    working memory first. The cut-free style: known/2 facts decide;
    only a genuinely unknown attribute reaches the user.               */

has(X)   :- ask(has, X).
can(X)   :- ask(can, X).
eats(X)  :- ask(eats, X).
gives(X) :- ask(gives, X).
lays(X)  :- ask(lays, X).

% ask(+Verb, +Attr): true iff the user affirms Verb(Attr).
ask(Verb, Attr) :-
    known(Verb-Attr, Answer), !,       % already answered: don't re-ask
    Answer == yes.
ask(Verb, Attr) :-
    write('Does/can the animal '), write(Verb), write(' '),
    write(Attr), write('? (yes./no.) '),
    read(Answer),
    assertz(known(Verb-Attr, Answer)), % remember for the whole session
    Answer == yes.

/* ------------------- THE CONSULTATION ------------------------------ */

identify(Animal) :-
    animal(Animal), !,
    write('I think it is a '), write(Animal), write('.'), nl.
identify(unknown) :-
    write('I cannot identify this animal with my current rules.'), nl.

restart :-
    retractall(known(_, _)),
    write('All answers forgotten.'), nl.

/*  Architecture notes (the part that generalizes):

    - RULE BASE (animal/1 and friends): the knowledge. Domain experts
      edit only this part.
    - WORKING MEMORY (known/2): facts gathered during one consultation.
    - INFERENCE ENGINE: Prolog itself, running backward chaining --
      start from the hypothesis, work back to askable evidence. MYCIN
      worked exactly this way.
    - Rule ORDER tunes the dialogue (cheapest distinguishing questions
      first), not the logic. Try reordering and re-consulting.

    assertz/retractall are ISO and behave the same in SWI and SICStus. */
