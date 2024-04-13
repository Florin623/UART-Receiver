module UART_RX(
    input            clk,
    input            rst_n,
    input            rx_baud,
    input            rx_start,
    input            rx,
    output reg       rx_done,
    output reg       parity_bit,
    output     [7:0] data_out
);

    // Gray Encoding
    localparam IDLE   = 3'b000;
    localparam START  = 3'b001;
    localparam DATA   = 3'b011;
    localparam PARITY = 3'b010;
    localparam STOP   = 3'b110;

    reg [2:0] state;
    reg [2:0] next_state;
    reg [7:0] buffer_in;
    reg [7:0] next_buffer_in;
    reg [3:0] bit_counter;
    reg [3:0] next_bit_counter;
 
    // State Register
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            state       <= IDLE;
            buffer_in   <= 0;
            bit_counter <= 0;
        end
        else begin
            state       <= next_state;
            buffer_in   <= next_buffer_in;
            bit_counter <= next_bit_counter;
        end
    end

    // Output Logic
    always_comb begin
        rx_done = 1'b0;
        next_buffer_in = buffer_in;
        next_bit_counter = bit_counter;
        parity_bit = 1'b0;
        case (state)
            IDLE  : begin
                        next_buffer_in   = 0;
                        next_bit_counter = 0;
                    end
            START : begin end
            DATA  : if (rx_baud && next_bit_counter < 8) begin
                        next_buffer_in   = {rx, buffer_in[7:1]};
                        next_bit_counter = bit_counter + 1;
                    end
            PARITY: if (rx_baud)
                        parity_bit = ^data_out;
            STOP  : if (rx_baud)
                        rx_done = 1'b1;
        endcase
    end

    assign data_out = next_buffer_in;

    // Next State Logic
    always_comb begin
        next_state = state;
        case (state)
            IDLE  : if (rx_baud && !rx && rx_start)
                        next_state = START;
            START : if (rx_baud)
                        next_state = DATA;
            DATA  : if (rx_baud && !rx && next_bit_counter == 8)
                        next_state = PARITY;
            PARITY: if (rx_baud && rx)
                        next_state = STOP;
            STOP  : if (rx_baud)
                        next_state = IDLE;
        endcase
    end

endmodule