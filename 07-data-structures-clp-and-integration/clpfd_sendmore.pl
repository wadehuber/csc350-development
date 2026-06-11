/*  Course:  CSC350: Logic Programming for Artificial Intelligence
    Module:  7 - Advanced Data Structures, CLP, and Language Integration
    Competencies: 4 (develop Prolog solutions), 5 (evaluate efficiency
                  trade-offs), 6 (solutions for AI problems)
    Purpose: Constraint Logic Programming over finite domains, CLP(FD).
             Solves SEND + MORE = MONEY by CONSTRAINING first and
             SEARCHING second -- constraint propagation prunes the
             space before labeling enumerates what little remains.
    Runs in: SWI-Prolog as written. SICStus Prolog after ONE substitution
             marked *** SICStUS *** below (domain syntax differs).
             Both systems provide library(clpfd); #=, all_different/1,
             and labeling/2 are the same in both.

    Suggested queries:
      ?- send_more_money(Digits).
      ?- time(send_more_money(D)).      % SWI only: inference count
*/

:- use_module(library(clpfd)).

/*      S E N D
      + M O R E
      ---------
    M O N E Y       Each letter is a different digit; S and M nonzero. */

send_more_money([S,E,N,D,M,O,R,Y]) :-
    Vars = [S,E,N,D,M,O,R,Y],

    % --- domains -----------------------------------------------------
    Vars ins 0..9,                 % SWI-Prolog syntax
    % *** SICSTUS: replace the line above with:
    %     domain(Vars, 0, 9),

    % --- constraints (no search happens here!) ------------------------
    all_different(Vars),
    S #\= 0,
    M #\= 0,
                 1000*S + 100*E + 10*N + D
               + 1000*M + 100*O + 10*R + E
    #= 10000*M + 1000*O + 100*N + 10*E + Y,

    % --- search ---------------------------------------------------------
    % Only now do we enumerate -- and propagation has already shrunk
    % the domains drastically (M can only be 1, for instance).
    labeling([], Vars),

    % --- report ----------------------------------------------------------
    write('  SEND = '),  write([S,E,N,D]),  nl,
    write('  MORE = '),  write([M,O,R,E]),  nl,
    write(' MONEY = '),  write([M,O,N,E,Y]), nl.

/*  Why this matters (competency 5):

    Plain generate-and-test would try up to 10^8 digit assignments.
    Module 6's slow_sort/2 showed that style collapsing at n=8.

    CLP inverts the order: #= and all_different are posted BEFORE any
    enumeration, and each constraint actively REMOVES impossible values
    from the variables' domains (constraint propagation). labeling/2
    then searches the residual space, which here is tiny.

    "Constrain first, search second" is the engine inside industrial
    scheduling, rostering, and configuration systems -- among the most
    commercially successful applications of logic programming.        */
