"""
Course:  CSC350: Logic Programming for Artificial Intelligence
Module:  13 - Neuro-Symbolic AI and Inductive Logic Programming
Competencies: 5 (evaluate logic programming alongside other AI approaches),
              6 (solutions for AI applications)
Purpose: A complete neuro-symbolic pipeline in ~150 lines, no libraries:
           NEURAL layer  - a perceptron trained from data to judge whether
                           fruit is ripe (learned, fast, unexplainable)
           SYMBOLIC layer - hard rules combining the perceptron's verdict
                           with domain knowledge (written, auditable)
         The final test case shows the symbolic layer VETOING a confident
         but unacceptable neural verdict -- the architectural pattern
         behind real neuro-symbolic systems.
Runs in: Python 3 (standard library only) -- run: python neuro_symbolic_demo.py
"""

# ---------------------------------------------------------------------------
# NEURAL LAYER: a perceptron, the simplest trainable classifier.
# Features per fruit: (softness 0-1, sweetness 0-1, color_score 0-1)
# Label: 1 = ripe, 0 = not ripe.
# ---------------------------------------------------------------------------

TRAINING_DATA = [
    # softness, sweetness, color   -> ripe?
    ((0.9, 0.8, 0.9), 1),
    ((0.8, 0.9, 0.7), 1),
    ((0.7, 0.7, 0.8), 1),
    ((0.9, 0.6, 0.8), 1),
    ((0.2, 0.3, 0.4), 0),
    ((0.3, 0.2, 0.2), 0),
    ((0.4, 0.4, 0.3), 0),
    ((0.1, 0.5, 0.3), 0),
]


class Perceptron:
    """w . x + b > 0 => ripe. Trained with the classic perceptron rule."""

    def __init__(self, n_features):
        self.w = [0.0] * n_features
        self.b = 0.0

    def predict(self, x):
        activation = sum(wi * xi for wi, xi in zip(self.w, x)) + self.b
        return 1 if activation > 0 else 0

    def train(self, data, epochs=20, lr=0.1):
        for epoch in range(epochs):
            errors = 0
            for x, label in data:
                error = label - self.predict(x)
                if error != 0:
                    errors += 1
                    self.w = [wi + lr * error * xi for wi, xi in zip(self.w, x)]
                    self.b += lr * error
            print(f"  epoch {epoch + 1:2d}: {errors} misclassification(s)")
            if errors == 0:        # converged: training data linearly separable
                break


# ---------------------------------------------------------------------------
# SYMBOLIC LAYER: rules a human wrote and a human can audit.
# This is the role a Prolog rule base plays in a production hybrid;
# here it is Python so the demo runs with zero dependencies. Note the
# rules' Prolog-like shape: conditions -> conclusion, first match wins.
# ---------------------------------------------------------------------------

# Domain knowledge that NO amount of ripeness data could supply:
RECALLED_BATCHES = {"batch_7"}          # food-safety recall
ALLERGY_FRUIT = {"kiwi"}                # customer allergy profile


def symbolic_decision(fruit, batch, neural_says_ripe):
    """Combine the learned verdict with hard constraints.

    Returns (decision, reason). Rules are ordered: safety rules first --
    they OVERRIDE the neural verdict no matter how confident it is.
    """
    if batch in RECALLED_BATCHES:
        return "REJECT", f"batch '{batch}' is under recall (overrides neural verdict)"
    if fruit in ALLERGY_FRUIT:
        return "REJECT", f"'{fruit}' conflicts with customer allergy profile"
    if neural_says_ripe:
        return "ACCEPT", "perceptron judges it ripe; no rule objects"
    return "REJECT", "perceptron judges it not ripe"


# ---------------------------------------------------------------------------
# THE PIPELINE: perception (learned) feeds reasoning (written).
# ---------------------------------------------------------------------------

if __name__ == "__main__":
    print("Training the neural layer (perceptron):")
    net = Perceptron(n_features=3)
    net.train(TRAINING_DATA)
    print(f"  learned weights: {[round(w, 2) for w in net.w]}, bias {net.b:+.2f}")
    print("  (Try explaining THOSE numbers to a food-safety auditor.)\n")

    test_cases = [
        # fruit,    batch,     features
        ("banana",  "batch_3", (0.85, 0.80, 0.90)),   # ripe, no rule fires
        ("apple",   "batch_5", (0.20, 0.30, 0.30)),   # unripe
        ("kiwi",    "batch_2", (0.90, 0.85, 0.80)),   # ripe BUT allergy rule
        ("mango",   "batch_7", (0.95, 0.90, 0.95)),   # very ripe BUT recalled
    ]

    print("Hybrid decisions (neural verdict -> symbolic rules):")
    for fruit, batch, features in test_cases:
        ripe = net.predict(features) == 1
        decision, reason = symbolic_decision(fruit, batch, ripe)
        neural = "ripe" if ripe else "not ripe"
        print(f"  {fruit:7s} [{batch}]: neural says {neural:8s} -> {decision}: {reason}")

    print("""
The division of labor:
  - The PERCEPTRON learned its judgment from data. Retraining adapts it;
    nobody can read it. (Module 13's ILP learner is the contrast: its
    output is a readable rule.)
  - The RULES contributed knowledge absent from the training data
    (recalls, allergies) and aren't statistical: a recall is a fact.
  - Composition: neural proposes, symbolic disposes. AlphaGeometry,
    DeepProbLog, and Scallop are industrial-strength versions of this
    same split.""")
