"""
Course:  CSC350: Logic Programming for Artificial Intelligence
Module:  14 - Evaluation of Logic Programming in AI and Other Domains
Competencies: 5 (evaluate logic programming vs other paradigms)
Purpose: The procedural contestant in the three-paradigm comparison.
         Same data and queries (Q1-Q5) as family_relations.pl and
         family_relations.sql. Notice what must be made EXPLICIT here:
         iteration, direction, and recursion bookkeeping.
Runs in: Python 3 (standard library only) -- run: python family_relations.py
"""

# ---- Data: identical to the Prolog facts and the SQL rows ------------------

PARENT = [
    ("pam", "bob"),
    ("tom", "bob"),
    ("tom", "liz"),
    ("bob", "ann"),
    ("bob", "pat"),
    ("pat", "jim"),
]


# ---- The relations, procedurally -------------------------------------------
# In Prolog, grandparent/2 is ONE rule usable in every direction. As
# functions, each query direction is its own code path. That asymmetry
# is the core observation of this comparison.

def grandchildren_of(person):                       # Q1 direction
    return [c2 for p, c1 in PARENT if p == person
            for p2, c2 in PARENT if p2 == c1]


def grandparents_of(person):                        # Q2 direction: new code!
    return [p for p, c1 in PARENT
            for p2, c2 in PARENT if p2 == c1 and c2 == person]


def siblings_of(person):                            # Q3
    parents = [p for p, c in PARENT if c == person]
    return sorted({c for p, c in PARENT if p in parents and c != person})


def descendants_of(person):                         # Q4: recursion, manually
    """Transitive closure with explicit bookkeeping (compare ancestor/2:
    two Prolog clauses). The visited set guards against cycles -- Prolog's
    pure version has the same obligation (Module 3), so this is a fair fight;
    but here the traversal order, the accumulation, and the guard are all
    OUR job rather than the engine's."""
    result, frontier = [], [person]
    visited = set()
    while frontier:
        current = frontier.pop(0)
        for p, c in PARENT:
            if p == current and c not in visited:
                visited.add(c)
                result.append(c)
                frontier.append(c)
    return result


def ancestors_of(person):                           # Q5 direction: new code AGAIN
    result, frontier = [], [person]
    visited = set()
    while frontier:
        current = frontier.pop(0)
        for p, c in PARENT:
            if c == current and p not in visited:
                visited.add(p)
                result.append(p)
                frontier.append(p)
    return result


if __name__ == "__main__":
    print("Q1 grandchildren of tom: ", grandchildren_of("tom"))
    print("Q2 grandparents of jim:  ", grandparents_of("jim"))
    print("Q3 siblings of ann:      ", siblings_of("ann"))
    print("Q4 descendants of tom:   ", descendants_of("tom"))
    print("Q5 ancestors of jim:     ", ancestors_of("jim"))

    print("""
Scorecard notes:
  - Five queries required five functions; the Prolog file answers all
    five with three rules.
  - But: this file runs anywhere Python runs, debugs with ordinary
    tools, and every teammate can read it today. Ecosystem is a
    paradigm feature too -- weigh it honestly (see README).""")
