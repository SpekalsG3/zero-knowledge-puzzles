pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/gates.circom";

// In this exercise , we will learn how to check the range of a private variable and prove that 
// it is within the range . 

// For example we can prove that a certain person's income is within the range
// Declare 3 input signals `a`, `lowerbound` and `upperbound`.
// If 'a' is within the range, output 1 , else output 0 using 'out'


template Range() {
    // your code here

  signal input a;
  signal input lowerbound;
  signal input upperbound;
  signal output out;

  component and = AND();
  and.a <== GreaterEqThan(252)([a, lowerbound]);
  and.b <== LessEqThan(252)([a, upperbound]);

  out <== and.out;
}

component main  = Range();


