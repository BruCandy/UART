module UART_wrapper (
    input   wire i_clk,
    input   wire i_rst,
    output  wire o_txd
);

    reg [1:0]   r_state;
    reg         r_we;
    reg [7:0]   r_data;
    reg [3:0]   r_cnt;

    wire        w_busy;

    UART # (
        .D(234),
        .L(8)
    ) uart (
        .i_clk  (i_clk  ),
        .i_rst  (i_rst  ),
        .i_data (r_data ),
        .i_we   (r_we   ),
        .o_data (o_txd  ),
        .o_busy (w_busy )
    );


    always @(posedge i_clk or posedge i_rst) begin
        if (i_rst) begin
            r_state <= 2'b00;
            r_we    <= 1'b0;
            r_cnt   <= 4'd0;
        end else begin
            case (r_state)
                2'b00: begin
                    case (r_cnt)
                        4'd0 : r_data <= 8'h48; // H
                        4'd1 : r_data <= 8'h65; // e
                        4'd2 : r_data <= 8'h6c; // l
                        4'd3 : r_data <= 8'h6c; // l
                        4'd4 : r_data <= 8'h6f; // o
                        4'd5 : r_data <= 8'h2c; // ,
                        4'd6 : r_data <= 8'h20; //  
                        4'd7 : r_data <= 8'h57; // W
                        4'd8 : r_data <= 8'h6f; // o
                        4'd9 : r_data <= 8'h72; // r
                        4'd10: r_data <= 8'h6c; // l
                        4'd11: r_data <= 8'h64; // d
                        4'd12: r_data <= 8'h0d; // \r (キャリッジリターン)
                        4'd13: r_data <= 8'h0a; // \n (改行)
                        default: r_data <= 8'h00;
                    endcase
                    r_we    <= 1'b1;
                    r_state <= 2'b01;
                end
                2'b01: begin
                    if (!w_busy) begin
                        r_we    <= 1'b0;
                        if (r_cnt == 4'd13) begin
                            r_state <= 2'b10;
                        end else begin
                            r_state <= 2'b00;
                            r_cnt <= r_cnt + 1'b1;
                        end
                    end
                end
                2'b10: begin
                    // ここで次の動作を制御する（例えば連続送信など）
                    // 今回は1回送信後に何もしない
                end
            endcase
        end
    end
endmodule
