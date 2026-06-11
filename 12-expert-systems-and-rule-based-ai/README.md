# Module 12: Expert Systems and Rule-Based AI Applications

Expert systems were logic programming's first commercial triumph (MYCIN, XCON, and
thousands of corporate descendants): capture a specialist's knowledge as rules, add an
inference engine, and ship advice. This module builds two: an **interactive
identification system** (the classic "animal expert" that asks yes/no questions and
remembers your answers) and a **decision-support system** with the feature that made
expert systems trustworthy in practice — an **explanation facility** that answers
*"why did you conclude that?"* with the actual rule chain, built with the
meta-interpreter technique from Module 4.

## Competencies Addressed

- **3.** Construct knowledge-representation schema for problems in artificial intelligence (rule bases as KR).
- **4.** Develop solutions using a Prolog-based logic programming language.
- **5.** Evaluate the use of logic programming for its applications in artificial intelligence and other domains (why rule-based systems won — and where they struggle).
- **6.** Develop logic programming-based solutions for computational problems and applications in artificial intelligence.

## Files

| File | Language | What it shows |
|---|---|---|
| `animal_expert.pl` | Prolog (portable: SWI + SICStus, see I/O note) | Interactive animal identification: rules over askable attributes; asked answers are remembered with `assertz/1` (working memory) so no question is asked twice; `retractall/1` resets between consultations. |
| `loan_advisor.pl` | Prolog (portable: SWI + SICStus) | Non-interactive decision support: applicant facts + eligibility rules + an explanation facility (`advise/3` returns the proof tree; `explain/1` prints it as indented "because…" text). |

## Running the Examples

```
swipl animal_expert.pl
```

```prolog
?- identify(Animal).        % answer the questions with yes. or no.
?- restart.                 % forget answers, consult again
```

**I/O note:** answers must be Prolog terms ending in a period — type `yes.` or `no.`
then Enter. This uses ISO `read/1` and works identically in SWI and SICStus; it is
the price of staying portable (each system has fancier I/O of its own).

```
swipl loan_advisor.pl
```

```prolog
?- advise(alice, Decision, Proof).
?- explain(alice).                 % the "why" facility, printed nicely
?- explain(carol).
?- forall_applicants.              % report on every applicant
```

## Expected Output / Experimentation Notes

- `animal_expert.pl` can identify: cheetah, tiger, giraffe, zebra, ostrich, penguin,
  albatross. Answer to reach `penguin` (it cannot fly but swims) and note which
  questions were *not* asked — rule order prunes the dialogue.
- `explain(carol).` should print a denial with the failing condition stated. This
  "explanation as proof tree" is the same `solve_trace/2` idea from Module 4 grown up.
- Discussion (competency 5): rules made the system auditable — a regulator can read
  `loan_advisor.pl`. Compare a neural-network loan model (Module 13 takes this up).

## Student Extension Ideas

1. Add three animals to `animal_expert.pl` (e.g., bat, dolphin, eagle) — you will
   need at least one new askable attribute; keep the dialogue short by ordering rules
   well.
2. Add a `does_not_know` answer option (treat it as `no` but report at the end which
   answers were uncertain).
3. Give `loan_advisor.pl` a new rule for student applicants and write a test applicant
   it approves that the current rules deny.
4. Add simple certainty factors: each rule carries a confidence (0–1), conclusions
   multiply confidences along the chain, and `advise/3` reports the score (MYCIN's
   approach, simplified).
