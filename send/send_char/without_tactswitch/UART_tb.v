module UART_tb();
    reg i_clk = 1'b1;
    reg i_sed = 1'b0;
    reg i_cnt = 1'b0;
    wire o_txd;
    wire o_led;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, UART_tb);
    end

    UART_wrapper # (
        .D(5),
        .L(3)
    ) uart (
        .i_clk  (i_clk  ),
        .i_sed  (i_sed  ),
        .i_cnt  (i_cnt  ),
        .o_txd  (o_txd  ),
        .o_led  (o_led  )
    );

    always #10 begin
        i_clk <= ~i_clk;
    end

    initial begin
        // 初期状態
        #10;
        i_sed <= 1'b1; #20;
        i_sed <= 1'b0; #10;

        // カウント状態（ボタン10回押す）
        repeat (10) begin
            i_cnt <= 1'b1; #10;
            i_cnt <= 1'b0; #10;
        end

        // 送信状態（送信待ち状態）
        i_sed <= 1'b1; #10;
        i_sed <= 1'b0;

        #2000;
        // 送信完了

        // 初期状態
        i_sed <= 1'b1; #20;
        i_sed <= 1'b0; #10;

        // カウント状態（ボタン8回押す）
        repeat (8) begin
            i_cnt <= 1'b1; #10;
            i_cnt <= 1'b0; #10;
        end

        // 送信状態（送信待ち状態）
        i_sed <= 1'b1; #10;
        i_sed <= 1'b0;

        // 送信完了
        #10000;

        $finish;
    end
endmodule
