/*  Course:  CSC350: Logic Programming for Artificial Intelligence
    Module:  7 - Advanced Data Structures, CLP, and Language Integration
    Competencies: 4 (develop Prolog solutions), 6 (solutions for
                  computational problems)
    Purpose: Binary search trees as recursive Prolog terms. The same
             term-as-tree pattern underlies parse trees (NLP), decision
             trees (expert systems), and game trees (search) in AI.
    Runs in: SWI-Prolog AND SICStus Prolog (portable, ISO-style).

    Representation:
      empty                          -- the empty tree
      t(Left, Value, Right)          -- a node

    Suggested queries:
      ?- list_to_bst([5,3,8,1,4], T).
      ?- list_to_bst([5,3,8,1,4], T), inorder(T, Sorted).
      ?- list_to_bst([5,3,8,1,4], T), bst_member(4, T).
      ?- list_to_bst([5,3,8,1,4], T), height(T, H), size(T, N).
*/

% bst_insert(+X, +Tree, -NewTree): standard BST insertion.
% Note there is no "pointer surgery": NewTree shares all untouched
% subtrees with Tree. Persistent (immutable) data structures come free
% in logic programming.
bst_insert(X, empty, t(empty, X, empty)).
bst_insert(X, t(L, V, R), t(L2, V, R)) :-
    X < V, !,
    bst_insert(X, L, L2).
bst_insert(X, t(L, V, R), t(L, V, R2)) :-
    X > V, !,
    bst_insert(X, R, R2).
bst_insert(X, t(L, X, R), t(L, X, R)).      % duplicate: keep one copy

% list_to_bst(+List, -Tree): insert each element in turn.
list_to_bst(List, Tree) :-
    list_to_bst_acc(List, empty, Tree).

list_to_bst_acc([], T, T).
list_to_bst_acc([X|Xs], T0, T) :-
    bst_insert(X, T0, T1),
    list_to_bst_acc(Xs, T1, T).

% bst_member(+X, +Tree): O(height) membership -- the BST property lets
% us commit to one subtree per step, unlike list my_member/2.
bst_member(X, t(_, X, _)) :- !.
bst_member(X, t(L, V, _)) :- X < V, !, bst_member(X, L).
bst_member(X, t(_, _, R)) :- bst_member(X, R).

% inorder(+Tree, -List): left, root, right => sorted output for a BST.
% (Building a BST then flattening it IS a sorting algorithm.)
inorder(empty, []).
inorder(t(L, V, R), List) :-
    inorder(L, LL),
    inorder(R, RL),
    append(LL, [V|RL], List).

% height(+Tree, -H) and size(+Tree, -N): structural recursion.
height(empty, 0).
height(t(L, _, R), H) :-
    height(L, HL),
    height(R, HR),
    max_int(HL, HR, M),
    H is M + 1.

max_int(A, B, A) :- A >= B, !.
max_int(_, B, B).

size(empty, 0).
size(t(L, _, R), N) :-
    size(L, NL),
    size(R, NR),
    N is NL + NR + 1.

/*  AI connection: swap the node payload and this file becomes other
    AI structures --
      t(L, question(Q), R)   a binary decision tree (Module 12)
      t(L, move(M, Score), R) a game tree node
    The recursion patterns (insert / traverse / measure) are identical. */
