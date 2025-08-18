// module traffic_light(
//     input  wire clk,
//     input  wire rst,   // synchronous active-high reset
//     input  wire tick,  // 1-cycle pulse marking "one second"
//     output wire ns_g,
//     output wire ns_y,
//     output wire ns_r,
//     output wire ew_g,
//     output wire ew_y,
//     output wire ew_r
// );

//     // ----------------------------------------------------
//     // State encoding (Moore FSM)
//     // ----------------------------------------------------
//     typedef enum logic [1:0] {
//         NS_GREEN  = 2'd0,
//         NS_YELLOW = 2'd1,
//         EW_GREEN  = 2'd2,
//         EW_YELLOW = 2'd3
//     } state_t;

//     state_t state_present, state_next;

//     // ----------------------------------------------------
//     // Phase durations (in ticks = seconds)
//     // ----------------------------------------------------
//     localparam int D_NS_GREEN  = 5;
//     localparam int D_NS_YELLOW = 2;
//     localparam int D_EW_GREEN  = 5;
//     localparam int D_EW_YELLOW = 2;

//     // Counter for seconds within each phase
//     logic [2:0] phase_cnt_present, phase_cnt_next; // 3 bits enough for max=5

//     // ----------------------------------------------------
//     // Next-state and counter logic
//     // ----------------------------------------------------
//     always_comb begin
//         // Default: hold current values
//         state_next      = state_present;
//         phase_cnt_next  = phase_cnt_present;

//         if (tick) begin
//             case (state_present)
//                 NS_GREEN: begin
//                     if (phase_cnt_present == D_NS_GREEN-1) begin
//                         state_next     = NS_YELLOW;
//                         phase_cnt_next = 0;
//                     end else begin
//                         phase_cnt_next = phase_cnt_present + 1;
//                     end
//                 end

//                 NS_YELLOW: begin
//                     if (phase_cnt_present == D_NS_YELLOW-1) begin
//                         state_next     = EW_GREEN;
//                         phase_cnt_next = 0;
//                     end else begin
//                         phase_cnt_next = phase_cnt_present + 1;
//                     end
//                 end

//                 EW_GREEN: begin
//                     if (phase_cnt_present == D_EW_GREEN-1) begin
//                         state_next     = EW_YELLOW;
//                         phase_cnt_next = 0;
//                     end else begin
//                         phase_cnt_next = phase_cnt_present + 1;
//                     end
//                 end

//                 EW_YELLOW: begin
//                     if (phase_cnt_present == D_EW_YELLOW-1) begin
//                         state_next     = NS_GREEN;
//                         phase_cnt_next = 0;
//                     end else begin
//                         phase_cnt_next = phase_cnt_present + 1;
//                     end
//                 end

//                 default: begin
//                     state_next     = NS_GREEN;
//                     phase_cnt_next = 0;
//                 end
//             endcase
//         end
//         // If tick == 0 → stay in same state and keep counter
//     end

//     // ----------------------------------------------------
//     // Synchronous state register
//     // ----------------------------------------------------
//     always_ff @(posedge clk) begin
//         if (rst) begin
//             state_present     <= NS_GREEN; // start in NS green
//             phase_cnt_present <= 0;
//         end else begin
//             state_present     <= state_next;
//             phase_cnt_present <= phase_cnt_next;
//         end
//     end

//     // ----------------------------------------------------
//     // Outputs (Moore style: depend only on state)
//     // ----------------------------------------------------
//     assign ns_g = (state_present == NS_GREEN);
//     assign ns_y = (state_present == NS_YELLOW);
//     assign ns_r = ~(ns_g | ns_y);

//     assign ew_g = (state_present == EW_GREEN);
//     assign ew_y = (state_present == EW_YELLOW);
//     assign ew_r = ~(ew_g | ew_y);

//     // By construction, exactly one light per direction is ON
// endmodule
module traffic_light(
    input  wire clk,
    input  wire rst,
    input  wire tick,
    output wire ns_g,
    output wire ns_y,
    output wire ns_r,
    output wire ew_g,
    output wire ew_y,
    output wire ew_r
);

    // State encoding
    parameter NS_GREEN  = 2'd0,
              NS_YELLOW = 2'd1,
              EW_GREEN  = 2'd2,
              EW_YELLOW = 2'd3;

    reg [1:0] state_present, state_next;

    // Phase durations
    parameter D_NS_GREEN  = 5,
              D_NS_YELLOW = 2,
              D_EW_GREEN  = 5,
              D_EW_YELLOW = 2;

    reg [2:0] phase_cnt_present, phase_cnt_next;

    // Next-state logic
    always @(*) begin
        state_next      = state_present;
        phase_cnt_next  = phase_cnt_present;

        if (tick) begin
            case (state_present)
                NS_GREEN: begin
                    if (phase_cnt_present == D_NS_GREEN-1) begin
                        state_next     = NS_YELLOW;
                        phase_cnt_next = 0;
                    end else begin
                        phase_cnt_next = phase_cnt_present + 1;
                    end
                end

                NS_YELLOW: begin
                    if (phase_cnt_present == D_NS_YELLOW-1) begin
                        state_next     = EW_GREEN;
                        phase_cnt_next = 0;
                    end else begin
                        phase_cnt_next = phase_cnt_present + 1;
                    end
                end

                EW_GREEN: begin
                    if (phase_cnt_present == D_EW_GREEN-1) begin
                        state_next     = EW_YELLOW;
                        phase_cnt_next = 0;
                    end else begin
                        phase_cnt_next = phase_cnt_present + 1;
                    end
                end

                EW_YELLOW: begin
                    if (phase_cnt_present == D_EW_YELLOW-1) begin
                        state_next     = NS_GREEN;
                        phase_cnt_next = 0;
                    end else begin
                        phase_cnt_next = phase_cnt_present + 1;
                    end
                end
            endcase
        end
    end

    // State registers
    always @(posedge clk) begin
        if (rst) begin
            state_present     <= NS_GREEN;
            phase_cnt_present <= 0;
        end else begin
            state_present     <= state_next;
            phase_cnt_present <= phase_cnt_next;
        end
    end

    // Outputs
    assign ns_g = (state_present == NS_GREEN);
    assign ns_y = (state_present == NS_YELLOW);
    assign ns_r = ~(ns_g | ns_y);

    assign ew_g = (state_present == EW_GREEN);
    assign ew_y = (state_present == EW_YELLOW);
    assign ew_r = ~(ew_g | ew_y);

endmodule
