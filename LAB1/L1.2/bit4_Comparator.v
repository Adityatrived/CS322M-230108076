module bit4_Comparator(
    input [3:0] A,
    input [3:0] B,
    output out
);
    wire [3:0] eq_bits;

    
    assign eq_bits[0] = ~(A[0] ^ B[0]);
    assign eq_bits[1] = ~(A[1] ^ B[1]);
    assign eq_bits[2] = ~(A[2] ^ B[2]);
    assign eq_bits[3] = ~(A[3] ^ B[3]);

   
    assign out = eq_bits[0] & eq_bits[1] & eq_bits[2] & eq_bits[3];
    // assign out = &eq_bits;
    
endmodule 