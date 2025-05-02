pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/mimc.circom";
include "../node_modules/circomlib/circuits/gates.circom";

/*
    Given a 4x4 sudoku board with array signal input "question" and "solution", check if the solution is correct.

    "question" is a 16 length array. Example: [0,4,0,0,0,0,1,0,0,0,0,3,2,0,0,0] == [0, 4, 0, 0]
                                                                                   [0, 0, 1, 0]
                                                                                   [0, 0, 0, 3]
                                                                                   [2, 0, 0, 0]

    "solution" is a 16 length array. Example: [1,4,3,2,3,2,1,4,4,1,2,3,2,3,4,1] == [1, 4, 3, 2]
                                                                                   [3, 2, 1, 4]
                                                                                   [4, 1, 2, 3]
                                                                                   [2, 3, 4, 1]

    "out" is the signal output of the circuit. "out" is 1 if the solution is correct, otherwise 0.                                                                               
*/

template EvalPolyFactor(n) {
    signal input x;
    signal input in[n];
    signal output out;

    signal t[n];
    t[0] <== x - in[0];
    for (var i = 1; i < n; i++) {
        t[i] <== t[i-1] * (x - in[i]);
    }

    out <== t[n-1];
}

template CheckSudokuLine(n) {
    signal input in[n];
    signal output out;

    signal orig[n];
    for (var i = 0; i < n; i++) {
        orig[i] <== i + 1;
    }

    component mimc = MultiMiMC7(n, 10);
    mimc.in <== in;
    mimc.k <== 1;

    component evalIn = EvalPolyFactor(n);
    evalIn.x <== mimc.out;
    evalIn.in <== in;

    component evalOrig = EvalPolyFactor(n);
    evalOrig.x <== mimc.out;
    evalOrig.in <== orig;

    out <== IsEqual()([evalIn.out, evalOrig.out]);
}


template Sudoku () {
    // Question Setup 
    signal input  question[16];
    signal input solution[16];

    signal output out;
    
    // Checking if the question is valid
    for(var v = 0; v < 16; v++){
        log(solution[v],question[v]);
        assert(question[v] == solution[v] || question[v] == 0);
    }
    
    var m = 0 ;
    component row1[4];
    for(var q = 0; q < 4; q++){
        row1[m] = IsEqual();
        row1[m].in[0]  <== question[q];
        row1[m].in[1] <== 0;
        m++;
    }
    3 === row1[3].out + row1[2].out + row1[1].out + row1[0].out;

    m = 0;
    component row2[4];
    for(var q = 4; q < 8; q++){
        row2[m] = IsEqual();
        row2[m].in[0]  <== question[q];
        row2[m].in[1] <== 0;
        m++;
    }
    3 === row2[3].out + row2[2].out + row2[1].out + row2[0].out; 

    m = 0;
    component row3[4];
    for(var q = 8; q < 12; q++){
        row3[m] = IsEqual();
        row3[m].in[0]  <== question[q];
        row3[m].in[1] <== 0;
        m++;
    }
    3 === row3[3].out + row3[2].out + row3[1].out + row3[0].out; 

    m = 0;
    component row4[4];
    for(var q = 12; q < 16; q++){
        row4[m] = IsEqual();
        row4[m].in[0]  <== question[q];
        row4[m].in[1] <== 0;
        m++;
    }
    3 === row4[3].out + row4[2].out + row4[1].out + row4[0].out; 

    // Write your solution from here.. Good Luck!

    component checks[12];

    for (var i = 0; i < 4; i++) {
        // rows
        var m = i * 4;
        checks[i] = CheckSudokuLine(4);
        checks[i].in <== [solution[m+0], solution[m+1], solution[m+2], solution[m+3]];

        // columns
        checks[4+i] = CheckSudokuLine(4);
        checks[4+i].in <== [solution[0+i], solution[4+i], solution[8+i], solution[12+i]];
    }

    // boxes
    // no real pattern here
    checks[7+1] = CheckSudokuLine(4);
    checks[7+1].in <== [solution[ 0], solution[ 1], solution[ 4], solution[ 5]];
    checks[7+2] = CheckSudokuLine(4);
    checks[7+2].in <== [solution[ 2], solution[ 3], solution[ 6], solution[ 7]];
    checks[7+3] = CheckSudokuLine(4);
    checks[7+3].in <== [solution[ 8], solution[ 9], solution[12], solution[13]];
    checks[7+4] = CheckSudokuLine(4);
    checks[7+4].in <== [solution[10], solution[11], solution[14], solution[15]];

    component ands[12];
    signal flags[13];
    flags[0] <== 1;

    for (var i = 0; i < 12; i++) {
        ands[i] = AND();
        ands[i].a <== flags[i];
        ands[i].b <== checks[i].out;
        flags[i+1] <== ands[i].out;
    }

    out <== flags[12];
}


component main = Sudoku();

