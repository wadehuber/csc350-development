/*  Course:  CSC350: Logic Programming for Artificial Intelligence
    Module:  12 - Expert Systems and Rule-Based AI Applications
    Competencies: 3 (KR as rule bases), 4 (Prolog solutions),
                  5 (evaluate rule-based AI), 6 (AI applications)
    Purpose: A decision-support system with an EXPLANATION FACILITY:
             loan eligibility rules stored as data, an inference engine
             that returns the proof tree, and explain/1 to print the
             "because ..." chain. The auditable-by-design quality shown
             here is rule-based AI's enduring selling point.
    Runs in: SWI-Prolog AND SICStus Prolog (portable, ISO-style).

    Suggested queries:
      ?- advise(alice, Decision, Proof).
      ?- explain(alice).
      ?- explain(bob).
      ?- explain(carol).
      ?- forall_applicants.
*/

:- use_module(library(lists)).

/* ------------------- APPLICANT DATA (case facts) ------------------- */

% applicant(Name, MonthlyIncome, MonthlyDebt, YearsEmployed, CreditScore)
applicant(alice, 6500,  900, 6, 740).
applicant(bob,   3800, 1900, 1, 705).
applicant(carol, 5200,  600, 4, 580).
applicant(dan,   2900,  300, 9, 700).

/* ------------------- THE RULE BASE (as data) ------------------------ */
/*  rule(Conclusion, Conditions): stored as data, not as Prolog clauses,
    so the inference engine can capture WHICH rules fired -- the
    Module 4 meta-interpreter idea applied to a real architecture.
    Conditions are either nested conclusions or cond(Test) leaves.      */

rule(approve(P),
     [ good_credit(P), affordable(P), stable_employment(P) ]).

rule(good_credit(P),
     [ cond(credit_score(P, S), S >= 680) ]).

rule(affordable(P),                       % debt-to-income below 40%
     [ cond(debt_ratio(P, R), R < 40) ]).

rule(stable_employment(P),
     [ cond(years_employed(P, Y), Y >= 2) ]).

/*  Each cond(Fact, Test) must be SELF-CONTAINED: Fact binds every
    variable that Test inspects. That keeps the engine simple and lets
    the explanation facility report any single failing condition.      */

% Accessors over the applicant table.
income(P, I)         :- applicant(P, I, _, _, _).
debt(P, D)           :- applicant(P, _, D, _, _).
years_employed(P, Y) :- applicant(P, _, _, Y, _).
credit_score(P, S)   :- applicant(P, _, _, _, S).

% debt_ratio(P, R): monthly debt as a percentage of monthly income.
debt_ratio(P, R) :-
    income(P, I),
    debt(P, D),
    R is D * 100 / I.

/* ------------------- INFERENCE ENGINE WITH PROOFS ------------------- */

% prove(+Goal, -Proof): backward chaining over rule/2, recording the tree.
prove(cond(Fact, Test), because(Fact)) :-
    call(Fact),
    call(Test).
prove(Goal, proof(Goal, SubProofs)) :-
    rule(Goal, Conditions),
    prove_all(Conditions, SubProofs).

prove_all([], []).
prove_all([C|Cs], [P|Ps]) :-
    prove(C, P),
    prove_all(Cs, Ps).

% advise(+Person, -Decision, -Proof)
advise(P, approved, Proof) :-
    prove(approve(P), Proof), !.
advise(P, denied(FailedCondition), none) :-
    applicant(P, _, _, _, _),
    once(first_failure(approve(P), FailedCondition)).  % report ONE failure

% first_failure(+Goal, -Leaf): find a leaf condition that fails --
% the basis of a useful denial message. We call Fact anyway (it looks
% up the applicant's actual number) so the report shows the value that
% failed the Test, not an unbound variable.
first_failure(cond(Fact, Test), Fact-Test) :-
    \+ ( call(Fact), call(Test) ),
    ( call(Fact) -> true ; true ).
first_failure(Goal, Failed) :-
    rule(Goal, Conditions),
    member(C, Conditions),
    \+ prove(C, _),
    first_failure(C, Failed).

/* ------------------- THE EXPLANATION FACILITY ----------------------- */

explain(P) :-
    advise(P, approved, Proof), !,
    write(P), write(': APPROVED'), nl,
    print_proof(Proof, 1).
explain(P) :-
    advise(P, denied(Fact-Test), _), !,
    write(P), write(': DENIED'), nl,
    write('  failing condition: '), write(Fact),
    write('   required: '), write(Test), nl.
explain(P) :-
    write(P), write(': not a known applicant'), nl.

print_proof(because(Fact), Depth) :-
    indent(Depth), write('because '), write(Fact), nl.
print_proof(proof(Goal, Subs), Depth) :-
    indent(Depth), write(Goal), write(' holds:'), nl,
    D1 is Depth + 1,
    print_proofs(Subs, D1).

print_proofs([], _).
print_proofs([P|Ps], D) :- print_proof(P, D), print_proofs(Ps, D).

indent(0) :- !.
indent(N) :- write('  '), N1 is N - 1, indent(N1).

% forall_applicants: one-line report per applicant.
forall_applicants :-
    applicant(P, _, _, _, _),
    advise(P, Decision, _),
    write(P), write(' -> '), write(Decision), nl,
    fail.
forall_applicants.

/*  Evaluation discussion (competency 5):
    + The lending policy is READABLE: a regulator audits rule/2 facts.
    + Every decision carries its justification (the proof tree).
    + Changing policy = editing one rule; no retraining.
    - The rules only know what someone wrote down; nothing is learned
      from data, thresholds are brittle, and edge cases multiply.
    Module 13 looks at systems that try to get both halves.            */
