`timescale 1ns / 1ps

module UART_Receiver_TB();
    reg        clk;
    reg        rst_n;
    reg        baudrate_select;
    reg        rx;
    reg        rd_en;
    wire       parity_bit;
    wire [7:0] data_out;
    wire       empty;

    UART_Receiver DUT(
        .clk(clk),
        .rst_n(rst_n),
        .baudrate_select(baudrate_select),
        .rx(rx),
        .rd_en(rd_en),
        .parity_bit(parity_bit),
        .data_out(data_out),
        .empty(empty)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = !clk;
    end

    initial begin
        #2;
        rst_n = 1'b0;
        baudrate_select = 1'b0;     // 9600 bits per second
        rx = 1'b1;
        rd_en = 1'b0;
        repeat(2) @(posedge clk);
        #3;
        rst_n = 1'b1;

        repeat(13020) @(posedge clk);
        rx = 1'b0;      // START

        repeat(26042) @(posedge clk);
        rx = 1'b1;      // 1st bit of data

        repeat(13021) @(posedge clk);
        rx = 1'b1;      // 2nd bit of data

        repeat(13021) @(posedge clk);
        rx = 1'b0;      // 3rd bit of data

        repeat(13020) @(posedge clk);
        rx = 1'b0;      // 4th bit of data

        repeat(13022) @(posedge clk);
        rx = 1'b1;      // 5th bit of data

        repeat(13021) @(posedge clk);
        rx = 1'b0;      // 6th bit of data

        repeat(13021) @(posedge clk);
        rx = 1'b0;      // 7th bit of data

        repeat(13021) @(posedge clk);
        rx = 1'b1;      // 8th bit of data

        repeat(13021) @(posedge clk);
        rx = 1'b0;      // PARITY

        repeat(26042) @(posedge clk);
        rx = 1'b1;      // STOP

        repeat(13023) @(posedge clk);
        rd_en = 1'b1;

        repeat(14000) @(posedge clk);

        #2;
        rst_n = 1'b0;
        baudrate_select = 1'b1;     // 115200 bits per second
        rx = 1'b1;
        rd_en = 1'b0;
        repeat(2) @(posedge clk);
        #3;
        rst_n = 1'b1;

        repeat(1084) @(posedge clk);
        rx = 1'b0;      // START

        repeat(2170) @(posedge clk);
        rx = 1'b0;      // 1st bit of data

        repeat(1085) @(posedge clk);
        rx = 1'b0;      // 2nd bit of data

        repeat(1085) @(posedge clk);
        rx = 1'b0;      // 3rd bit of data

        repeat(1085) @(posedge clk);
        rx = 1'b1;      // 4th bit of data

        repeat(1086) @(posedge clk);
        rx = 1'b1;      // 5th bit of data

        repeat(1084) @(posedge clk);
        rx = 1'b0;      // 6th bit of data

        repeat(1085) @(posedge clk);
        rx = 1'b1;      // 7th bit of data

        repeat(1085) @(posedge clk);
        rx = 1'b0;      // 8th bit of data

        repeat(1085) @(posedge clk);
        rx = 1'b0;      // PARITY

        repeat(1085) @(posedge clk);
        rx = 1'b1;      // STOP

        repeat(1087) @(posedge clk);
        rd_en = 1'b1;

        repeat(3200) @(posedge clk);

        $finish;
    end

endmodule