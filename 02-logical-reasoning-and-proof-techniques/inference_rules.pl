/*  Course:  CSC350: Logic Programming for Artificial Intelligence
    Module:  2 - Logical Reasoning and Proof Techniques
    Competencies: 1 (appraise principles of logic),
                  2 (apply logical reasoning in problem-solving)
    Purpose: Implement valid inference patterns (modus ponens, modus tollens)
             over a small explicit knowledge base, and demonstrate why two
             classic fallacies (affirming the consequent, denying the
             antecedent) are NOT valid inferences.
    Runs in: SWI-Prolog AND SICStus Prolog (portable, ISO-style).

    Suggested queries:
      ?- derive(wet(grass), Why).
      ?- derive(X, Why).                 % everything derivable, with reasons
      ?- modus_tollens(game_on, C).      % lights are off => no game
      ?- affirming_consequent_example.
      ?- denying_antecedent_example.
*/

:- use_module(library(lists)).   % needed by SICStus; harmless in SWI

/* ---------------------------------------------------------------------
   We represent implications as explicit data (if/2 facts) rather than
   as Prolog rules. That lets us write inference rules that REASON ABOUT
   the implications -- the same move expert systems make in Module 12.
   --------------------------------------------------------------------- */

% if(P, Q): the knowledge base contains the implication P -> Q.
if(rained,           wet(grass)).
if(sprinkler_ran,    wet(grass)).
if(wet(grass),       slippery(grass)).
if(slippery(grass),  postpone(game)).
if(game_on,          stadium_lights_on).

% fact(P): P is known to be true outright.
fact(rained).

% known_false(P): P is known to be false outright.
known_false(stadium_lights_on).

/* ---------------------------------------------------------------------
   MODUS PONENS (valid):   from  P  and  P -> Q,  conclude  Q.
   derive/2 applies it transitively and reports WHY each conclusion
   holds, so you can inspect the chain of reasoning.
   --------------------------------------------------------------------- */

% derive(Q, Why): Q is derivable; Why explains how.
derive(P, given(P)) :-
    fact(P).
derive(Q, modus_ponens(P, Why)) :-
    if(P, Q),
    derive(P, Why).

/* ---------------------------------------------------------------------
   MODUS TOLLENS (valid):  from  ~Q  and  P -> Q,  conclude  ~P.
   "If the game were on, the stadium lights would be on; the lights
    are off; therefore the game is not on."
   --------------------------------------------------------------------- */

% modus_tollens(P, not(P)): conclude not(P) because some consequence
% of P is known to be false.
modus_tollens(P, not(P)) :-
    if(P, Q),
    refuted(Q).

% refuted(Q): Q is known false, directly or via modus tollens itself.
refuted(Q) :-
    known_false(Q).
refuted(Q) :-
    if(Q, R),
    refuted(R).

/* ---------------------------------------------------------------------
   THE FALLACIES. These predicates do not perform the bad inference --
   they explain it. Run them and read the output.
   --------------------------------------------------------------------- */

affirming_consequent_example :-
    write('FALLACY: affirming the consequent.'), nl,
    write('  Premise 1: if(rained, wet(grass))'), nl,
    write('  Premise 2: wet(grass)'), nl,
    write('  Tempting conclusion: rained  -- INVALID.'), nl,
    write('  Why: wet(grass) has another possible cause,'), nl,
    write('       if(sprinkler_ran, wet(grass)).'), nl,
    write('  The conclusion can be false while both premises are true.'), nl.

denying_antecedent_example :-
    write('FALLACY: denying the antecedent.'), nl,
    write('  Premise 1: if(rained, wet(grass))'), nl,
    write('  Premise 2: not(rained)'), nl,
    write('  Tempting conclusion: not(wet(grass))  -- INVALID.'), nl,
    write('  Why: the sprinkler could still have made the grass wet.'), nl.

/* Note the connection to Prolog itself: Prolog's execution mechanism
   (SLD resolution, Module 4) is essentially modus ponens run backwards
   from the goal. When you query ?- derive(postpone(game), Why). you are
   watching a proof being constructed. */
