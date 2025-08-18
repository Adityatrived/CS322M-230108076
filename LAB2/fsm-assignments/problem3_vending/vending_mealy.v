`timescale 1ns/1ps

module vending_mealy (
    input  wire       clk,
    input  wire       rst,       // synchronous active-high reset
    input  wire [1:0] coin,      // 01 = 5, 10 = 10, 00 = idle
    output wire       dispense,  // pulse when vending
    output wire       chg5,      // pulse when change 5 is returned
    output wire [1:0] state_present 
);

    // State encoding
    localparam [1:0] ST_IDLE = 2'b00,
                     ST_5    = 2'b01,
                     ST_10   = 2'b10,
                     ST_15   = 2'b11;

    reg [1:0] state_present_reg, state_next;

    
    reg mealy_disp, mealy_chg;
    
    reg dispense_reg, chg_reg;

    wire coin5  = (coin == 2'b01);
    wire coin10 = (coin == 2'b10);

    
    always @(*) begin
        
        state_next = state_present_reg;
        mealy_disp = 1'b0;
        mealy_chg  = 1'b0;

        case (state_present_reg)
            ST_IDLE: begin
                if (coin5)  state_next = ST_5;
                else if (coin10) state_next = ST_10;
            end

            ST_5: begin
                if (coin5)      state_next = ST_10;
                else if (coin10) state_next = ST_15;
            end

            ST_10: begin
                if (coin5)      state_next = ST_15;
                else if (coin10) begin
                    mealy_disp = 1'b1;
                    state_next = ST_IDLE;
                end
            end

            ST_15: begin
                if (coin5) begin
                    mealy_disp = 1'b1;
                    state_next = ST_IDLE;
                end else if (coin10) begin
                    mealy_disp = 1'b1;
                    mealy_chg  = 1'b1;
                    state_next = ST_IDLE;
                end
            end
        endcase
    end

    
    always @(posedge clk) begin
        if (rst) begin
            state_present_reg <= ST_IDLE;
            dispense_reg      <= 1'b0;
            chg_reg           <= 1'b0;
        end else begin
            state_present_reg <= state_next;
            dispense_reg      <= mealy_disp;
            chg_reg           <= mealy_chg;
        end
    end

    
    assign dispense      = dispense_reg;
    assign chg5          = chg_reg;
    assign state_present = state_present_reg;

endmodule