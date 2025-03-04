module UART_tb();
    reg i_clk = 1'b1;
    reg i_rst;

    wire        o_txd;
    wire [7:0]  o_data;
    wire        o_error;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, UART_tb);
    end

    UART_wrapper # (
        .D(5),
        .L(3)
    ) send(
        .i_clk  (i_clk  ),
        .i_rst  (i_rst  ),
        .o_txd  (o_txd  )
    );

    receive # (
        .D(5),
        .L(3)
    ) receive(
        .i_clk   (i_clk   ),
        .i_rst   (i_rst   ),
        .i_data  (o_txd   ),
        .o_data  (o_data  ),
        .o_error (o_error )
    );

    always #10 begin
        i_clk <= ~i_clk;
    end

    initial begin
        i_rst <= 1'b1; 
        #30;
        i_rst <= 1'b0;
        #10000;

        $finish;
    end
endmodule