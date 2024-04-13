/* CLKS_PER_BIT = Frequency of clk / Frequency of UART

For 125 MHz Clock and 9600 baud UART
125000000 / 9600 = 13021

For 125 MHz Clock and 115200 baud UART
125000000 / 115200 = 1085
*/

module Baudrate_Generator(
    input      clk,
    input      rst_n,
    input      baudrate_select,
    output reg rx_baud
);

    reg [13:0] counter;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            rx_baud <= 1'b0;
            counter <= 0;
        end
        else begin
            if (!baudrate_select) begin
                if (counter == 13020) begin
                    rx_baud <= 1'b1;
                    counter <= 0;
                end
                else begin
                    rx_baud <= 1'b0;
                    counter <= counter + 1;
                end
            end
            else begin
                if (counter == 1084) begin
                    rx_baud <= 1'b1;
                    counter <= 0;
                end
                else begin
                    rx_baud <= 1'b0;
                    counter <= counter + 1;
                end
            end
        end  
    end

endmodule