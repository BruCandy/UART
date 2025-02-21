module UART_tb();
    reg i_clk = 1'b0;
    reg i_rst;
    reg [7:0] i_data = 8'h41;
    reg i_we = 1'b0;
    wire o_data;
    wire o_busy;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, UART_tb);
    end

    UART uart(
        .i_clk  (i_clk  ),
        .i_rst  (i_rst  ),
        .i_data (i_data ),
        .i_we   (i_we   ),
        .o_data (o_data ),
        .o_busy (o_busy )
    );

    always #10 begin
        i_clk <= ~i_clk;
    end

    initial begin
        i_rst <= 1'b1; #30;
        i_rst <= 1'b0; #10;

        i_we <= 1'b1; #20;
        i_we <= 1'b0;
        wait (o_busy == 1'b0); #100;
        $finish;
    end
endmodule