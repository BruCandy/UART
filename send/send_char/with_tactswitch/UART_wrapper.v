module UART_wrapper (
    input   wire i_clk,
    input   wire i_rst,
    input   wire i_sed,
    input   wire i_cnt,
    output  wire o_txd
);

    parameter D = 234;
    parameter L = 8;

    reg [1:0]   r_state;
    reg         r_we;
    reg [7:0]   r_data;
    reg [4:0]   r_cnt;

    wire        w_busy;

    UART # (
        .D(D),
        .L(L)
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
            r_we    <= 1'b0;
            r_cnt   <= 4'd0;
            r_state <= 2'b00;
        end else if (r_state == 2'b00 && i_cnt) begin
            if (r_cnt < 5'd28) begin
                r_cnt <= r_cnt + 1'b1;
            end else begin
                r_cnt <= 5'd0;
            end
        end else if (r_state == 2'b00 && i_sed && r_cnt  != 4'd0) begin
            r_state <= 2'b01;
        end else begin
            case (r_state)
                2'b01: begin
                    case (r_cnt)
                        1  : r_data <= 8'h20; // 空白
                        2  : r_data <= 8'h61; // a
                        3  : r_data <= 8'h62; // b 
                        4  : r_data <= 8'h63; // c 
                        5  : r_data <= 8'h64; // d
                        6  : r_data <= 8'h65; // e
                        7  : r_data <= 8'h66; // f
                        8  : r_data <= 8'h67; // g
                        9  : r_data <= 8'h68; // h
                        10 : r_data <= 8'h69; // i
                        11 : r_data <= 8'h6A; // j
                        12 : r_data <= 8'h6B; // k
                        13 : r_data <= 8'h6C; // l
                        14 : r_data <= 8'h6D; // m
                        15 : r_data <= 8'h6E; // n
                        16 : r_data <= 8'h6F; // o
                        17 : r_data <= 8'h70; // p
                        18 : r_data <= 8'h71; // q
                        19 : r_data <= 8'h72; // r
                        20 : r_data <= 8'h73; // s
                        21 : r_data <= 8'h74; // t
                        22 : r_data <= 8'h75; // u
                        23 : r_data <= 8'h76; // v
                        24 : r_data <= 8'h77; // w
                        25 : r_data <= 8'h78; // x
                        26 : r_data <= 8'h79; // y
                        27 : r_data <= 8'h7A; // z
                    endcase
                    r_we    <= 1'b1;
                    r_state <= 2'b10;
                end
                2'b10: begin
                    if (!w_busy) begin
                        r_we    <= 1'b0;
                         r_state <= 2'b10; 
                    end
                end
                2'b11: begin
                    // 送信完了状態
                    // リセットをして、再び送信できる状態にする
                end
            endcase
        end
    end
endmodule
