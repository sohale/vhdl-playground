//
// 16-bit Pseudo random number generator
// Using Linear Feedback Shift Register
//
// No copyright : Freeware, 18 Nov. 2018
//
//

// The LFSR polynomial is taken from a (by now almost famous)
// application note from Xilinx.
// Those polynomials are selected for using minimal logic
// not for getting good 'randomness'.
// Using an LFSR alone is not good:
// - They can not generate the value zero.
// - They can not produce the same number twice.
// - Every number appears only once in 2^n cycles.
// - The numbers are highly 'related' by a factor two.
//  e.g. an 8-bit LFSR would take steps:
//  1, 2, 4, 8, 16, 32, 64, 128, 33, 66, 132, 41, 82
//
//  Therefore I use only 16 of 32 bits and re-order
//  the selected bits. Even then it may take a while before,
//  (what our feelings say!) a more random sequence of number
//  appears.
//
//
// Other LFSRs polynomials (From Xilinx app. note)
//  32 =  32,31,30,10,0 (used here)
//  40 =  40,21,19,2,0
//  48 =  48,28,27,1,0
//  56 =  56,22,21,1,0
//  64 =  64, 4, 3,1,0
//  72 =  72,53,47,6,0
//  80 =  80,38,35,3,0
//  88 =  88,72,71,1,0
//  96 =  96,49,47,2,0
// 112 = 112,45,43,2,0
// 128 = 128,29,27,2,0
//
//
// Know deficiencies:
// -  Using a seed of zero will only produce zeros.
//    This module does not check that!
// -  Always running. Might add a 'next' number
//    input for power savings.
//

module prng16
// Do NOT change these parameters unless you know what you are doing
#(parameter poly    = 32'hC0000400, // max length 32, bit LFSR bits 31,30,10 are set
            degree  = 32
 )
(
  input   reset_n,
  input   clk,
  input   set,
  input   [degree-1:0] seed,
  output  [15:0] rnd
);

reg [degree-1:0] lfsr,feedback;

   always @(posedge clk or negedge reset_n)
   begin
      if (!reset_n)
         // Futile attempt to start somewhat random.
         // I know: this value is too big for some values of
         // degree, but better then too small.
         lfsr <= { {(degree/3){3'b101}},2'b10};
      else
         if (set)
            lfsr <= seed;
         else
            lfsr <= feedback;
   end

integer n;

   always @( * )
   begin
      feedback[0]= lfsr[degree-1];
      for (n=1; n<degree; n=n+1)
        feedback[n] = poly[n]==1'b0 ? lfsr[n-1] : lfsr[n-1]^lfsr[degree-1];
   end

   // Pick 16 bits (indices randomly chosen)
   assign rnd = { lfsr[27], lfsr[16], lfsr[ 6], lfsr[22],
                  lfsr[20], lfsr[ 0], lfsr[18], lfsr[26],
                  lfsr[10], lfsr[ 9], lfsr[25], lfsr[19],
                  lfsr[11], lfsr[ 7], lfsr[28], lfsr[ 8]};

endmodule

-- Solution based on 3535598
-- https://stackoverflow.com/a/53361312/4374258

/*
entity, architecture, package or configuration keyword expected
design unit missing
*/
