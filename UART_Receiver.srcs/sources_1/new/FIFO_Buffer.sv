module FIFO_Buffer #(parameter ADDR_W = 5)(
    input            clk,
    input            rst_n,
    input            wr_en,
    input            rd_en,
    input      [7:0] data_in,
    output reg [7:0] data_out,
    output           empty,
    output           full
 );

    wire                 wr_en_mem;
    wire                 rd_en_mem;
    reg [ADDR_W - 1 : 0] wr_ptr_reg;
    reg [ADDR_W - 1 : 0] rd_ptr_reg;
    reg [ADDR_W - 1 : 0] fifo_counter;
    reg [7:0]            memory [0 : 2**ADDR_W - 1];

    //WRITE POINTER	
    always_ff @(posedge clk) begin
        if (!rst_n)
            wr_ptr_reg <= 0;
        else if (wr_en_mem)
            wr_ptr_reg <= wr_ptr_reg + 1;
    end

    //READ POINTER	
    always_ff @(posedge clk) begin
        if (!rst_n)
            rd_ptr_reg <= 0;
        else if (rd_en_mem)
            rd_ptr_reg <= rd_ptr_reg + 1;
    end

    //FIFO COUNTER
    always_ff @(posedge clk) begin
        if (!rst_n)
            fifo_counter <= 0;
        else if (!wr_en_mem && rd_en_mem)
            fifo_counter <= fifo_counter - 1;
        else if (wr_en_mem && !rd_en_mem)
            fifo_counter <= fifo_counter + 1;	
    end

    //READ_ENABLE AND WRITE_ENABLE
    assign wr_en_mem = wr_en & !full;
    assign rd_en_mem = rd_en & !empty;

    //FULL AND EMPTY
    assign full  = (fifo_counter == 2**ADDR_W);
    assign empty = (fifo_counter == 0);

    always_ff @(posedge clk) begin
        if (wr_en_mem)
            memory[wr_ptr_reg] <= data_in;
        else if (rd_en_mem)
            data_out <= memory[rd_ptr_reg];
    end

endmodule