module UART_Receiver(
    input        clk,
    input        rst_n,
    input        baudrate_select,
    input        rx,
    input        rd_en,
    output       parity_bit,
    output [7:0] data_out,
    output       empty
);

    wire       rx_baud;
    wire       rx_done;
    wire       rx_start;
    wire [7:0] uart_rx_output_data;

    FIFO_Buffer #(5) fifo(
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(rx_done),
        .rd_en(rd_en),
        .data_in(uart_rx_output_data),
        .data_out(data_out),
        .empty(empty),
        .full(rx_start)
    );

    Baudrate_Generator baud_generator(
        .clk(clk),
        .rst_n(rst_n),
        .baudrate_select(baudrate_select),
        .rx_baud(rx_baud)
    );

    UART_RX uart_rx(
        .clk(clk),
        .rst_n(rst_n),
        .rx_baud(rx_baud),
        .rx_start(!rx_start),
        .rx(rx),
        .rx_done(rx_done),
        .parity_bit(parity_bit),
        .data_out(uart_rx_output_data)
    );

endmodule