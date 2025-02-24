module UART_tb();
    reg i_clk = 1'b1;
    reg i_rst;
    reg i_sed;
    reg i_cnt;
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
        .i_sed  (i_sed  ),
        .i_cnt  (i_cnt  ),
        .o_txd  (o_txd  )
    );

    always #10 begin
        i_clk <= ~i_clk;
    end

    initial begin
        i_rst <= 1'b1; #10;
        i_rst <= 1'b0; #10;
        
        i_cnt <= 1'b1; #10;
        i_cnt <= 1'b0; #10;
        
        i_cnt <= 1'b1; #10;
        i_cnt <= 1'b0; #10;
        
        i_cnt <= 1'b1; #10;
        i_cnt <= 1'b0; #10;
        
        i_cnt <= 1'b1; #10;
        i_cnt <= 1'b0; #10;
        
        i_cnt <= 1'b1; #10;
        i_cnt <= 1'b0; #10;
        
        i_cnt <= 1'b1; #10;
        i_cnt <= 1'b0; #10;
        
        i_cnt <= 1'b1; #10;
        i_cnt <= 1'b0; #10;
        
        i_cnt <= 1'b1; #10;
        i_cnt <= 1'b0; #10;
        
        i_cnt <= 1'b1; #10;
        i_cnt <= 1'b0; #10;
        
        i_cnt <= 1'b1; #10;
        i_cnt <= 1'b0; #10;

        i_sed <= 1'b1; #10;
        i_sed <= 1'b0;
        #10000;

        $finish;
    end
endmodule