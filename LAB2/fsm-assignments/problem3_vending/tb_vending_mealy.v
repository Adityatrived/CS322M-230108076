`timescale 1ns/1ps
module tb_vending_mealy;
    reg clk, rst;
    reg [1:0] coin;
    wire dispense, chg5;
    wire [1:0] state_present;

    vending_mealy dut (
        .clk(clk),
        .rst(rst),
        .coin(coin),
        .dispense(dispense),
        .chg5(chg5),
        .state_present(state_present)
    );

    // clock generation (10 ns period)
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_vending_mealy);

        
        coin = 2'b00; rst = 1; #20;
        rst = 0; #10; 


        // Scenario: insert 10, then 10 -> vend
        coin = 2'b10; #10; coin = 2'b00; #10;
        coin = 2'b10; #10; coin = 2'b00; #10;

        // Scenario: insert 5, then 5, then 10 -> vend
        coin = 2'b01; #10; coin = 2'b00; #10;
        coin = 2'b01; #10; coin = 2'b00; #10;
        coin = 2'b10; #10; coin = 2'b00; #10;

        // Scenario: insert 15 (5+10), then 10 -> vend + change
        coin = 2'b01; #10; coin = 2'b00; #10;
        coin = 2'b10; #10; coin = 2'b00; #10;
        coin = 2'b10; #10; coin = 2'b00; #10;

        #50; $finish;
    end

    initial begin
        $monitor("%0t | clk=%b coin=%b state=%0d dispense=%b chg5=%b", $time, clk, coin, state_present, dispense, chg5);
    end
endmodule