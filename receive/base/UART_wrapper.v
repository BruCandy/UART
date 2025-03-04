module UART_wrapper (
    input   wire i_clk,
    input   wire i_rst,
    output  wire o_txd
);

    parameter D = 234;
    parameter L = 8;

    reg [1:0]   r_state;
    reg         r_we;

    wire [7:0]  w_data;
    wire        w_busy;

    send # (
        .D(D),
        .L(L)
    ) send (
        .i_clk  (i_clk  ),
        .i_rst  (i_rst  ),
        .i_data (w_data ),
        .i_we   (r_we   ),
        .o_data (o_txd  ),
        .o_busy (w_busy )
    );

    assign w_data = 8'h41;

    always @(posedge i_clk or posedge i_rst) begin
        if (i_rst) begin
            r_state <= 2'b00;
            r_we    <= 1'b0;
        end else begin
            case (r_state)
                2'b00: begin
                    r_we    <= 1'b1;
                    r_state <= 2'b01;
                end
                2'b01: begin
                    if (!w_busy) begin
                        r_we    <= 1'b0;
                        r_state <= 2'b10;
                    end
                end
                2'b10: begin
                    // ボタン(i_rst)を押して、もう一度送信
                    r_we    <= 1'b0;
                end
            endcase
        end
    end
endmodule
