`timescale 1ns/1ns

module tb_bit_Comparator_1;
   
   reg a;
   reg b;
   wire out1;
   wire out2;
   wire out3;

   bit_Comparator_1 cur(
         .A(a),
         .B(b),
         .o1(out1),
         .o2(out2),
         .o3(out3)
   );

   initial begin
       
       $dumpfile("wave.vcd");
       $dumpvars(0,tb_bit_Comparator_1);

       a = 0 ; b = 0 ;
       #10;

       a = 0 ; b = 1 ;
       #10;

       a = 1 ; b = 0 ;
       #10;

       a = 1 ; b = 1;
       #10;

       $display("The Test 1-bit_Comparator is Completed...");
       $finish;
   end

endmodule
