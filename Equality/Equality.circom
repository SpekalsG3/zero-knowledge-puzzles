pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/comparators.circom";

// Input 3 values using 'a'(array of length 3) and check if they all are equal.
// Return using signal 'c'.

template Equality() {
  // Your Code Here..

  signal input a[3];
  signal output c;

  signal calcs[3];
  calcs[0] <== 0;
  for (var i = 1; i < 3; i++) {
    calcs[i] <== calcs[i-1] + a[0] - a[i];
  }

  component isz = IsZero();
  isz.in <== calcs[2];
  c <== isz.out;
}

component main = Equality();
