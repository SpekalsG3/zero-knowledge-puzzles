pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/bitify.circom";
include "../node_modules/circomlib/circuits/gates.circom";

// Create a circuit which takes an input 'a',(array of length 2 ) , then  implement power modulo 
// and return it using output 'c'.

// HINT: Non Quadratic constraints are not allowed. 

// algorithm: https://www.geeksforgeeks.org/fast-exponention-using-bit-manipulation/
// `if (last_bit)` is replaced with `last_bit * a + !last_bit` aka "if 1, multiply by `a`, otherwise by 1"

template Pow() {
  var bits = 254;
   
   // Your Code here.. 

  signal input a[2];
  signal output c;

  signal cbits[bits];
  cbits <== Num2Bits_strict()(a[1]);

  component nots[bits];
  signal as[bits+1];
  signal cs[bits+1];
  signal bas[bits];
  as[0] <== a[0];
  cs[0] <== 1;

  for (var i = 0; i < bits; i++) {
    nots[i] = NOT();
    nots[i].in <== cbits[i];
    bas[i] <== cbits[i] * as[i] + nots[i].out;
    cs[i+1] <== bas[i] * cs[i];
    as[i+1] <== as[i] * as[i];
  }

  c <== cs[bits];
}

component main = Pow();

