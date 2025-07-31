`timescale 1ns / 1ns

module tb_bit4_Comparator;
    reg [3:0] a, b;
    wire ot;

   
    bit4_Comparator cur (
        .A(a),
        .B(b),
        .out(ot)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_bit4_Comparator);

        
        a = 4'b0000; b = 4'b0000;
        #10;

        a = 4'b1010; b = 4'b1010; 
        #10;

        a = 4'b1111; b = 4'b0111; 
        #10;

        a = 4'b0101; b = 4'b1010; 
        #10;

        a = 4'b1100; b = 4'b1100;
        #10;

        $display("The Test 4-bit_Comparator is Completed..."); 

        $finish;
    end
endmodule
