module UART_tb();
    reg i_clk = 1'b1;
    reg i_rst;
    wire o_txd;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, UART_tb);
    end

    UART_wrapper # (
        .D(5),
        .L(3)
    ) uart(
        .i_clk  (i_clk  ),
        .i_rst  (i_rst  ),
        .o_txd  (o_txd  )
    );

    always #10 begin
        i_clk <= ~i_clk;
    end

    initial begin
        i_rst <= 1'b1; #30;
        i_rst <= 1'b0;
        #100000;

        $finish;
    end
endmodule