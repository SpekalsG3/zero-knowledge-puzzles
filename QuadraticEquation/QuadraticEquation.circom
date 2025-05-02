pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/comparators.circom";

// Create a Quadratic Equation( ax^2 + bx + c ) verifier using the below data.
// Use comparators.circom lib to compare results if equal

template EvalPoly(n) {
    signal input in[n];
    signal input x;
    signal output out;

    signal pows[n+1];
    signal comb[n+1];
    pows[n] <== 1;
    comb[n] <== 0;

    for (var i = n-1; i >= 0; i--) {
        comb[i] <== comb[i+1] + pows[i+1] * in[i];
        pows[i] <== pows[i+1] * x;
    }

    out <== comb[0];
}

template QuadraticEquation() {
    signal input x;     // x value
    signal input a;     // coeffecient of x^2
    signal input b;     // coeffecient of x 
    signal input c;     // constant c in equation
    signal input res;   // Expected result of the equation
    signal output out;  // If res is correct , then return 1 , else 0 . 

    // your code here

    component eval = EvalPoly(3);
    eval.in <== [a, b, c];
    eval.x <== x;

    out <== IsEqual()([res, eval.out]);
}

component main  = QuadraticEquation();



