module led1_receive (
    input wire i_clk,
    input wire i_rst,
    input wire i_data,
    output wire o_led,
    output wire o_error
);

    // クロック数が27MHzの機器と通信速度115_200bit/sで通信
    parameter D = 234; // round(27MHz / 115_200bit/s)
    parameter L = 8;   // 234を表現するためには8bit必要
    parameter ERROR_DURATION = 1350000; // 約50ms (27MHz ÷ 20)
 
    reg [1:0] r_state = 2'b00;
    reg [L-1:0]    r_wait;   
    reg [3:0] r_cnt;
    reg [7:0] r_data = 8'b00000000;
    reg       r_led = 0;
    reg r_error = 0;
    reg error_counter = 0;

    assign o_led = r_led;
    assign o_error = r_error;

    always @(posedge i_clk or posedge i_rst) begin
        if (i_rst) begin
            r_state <= 2'b00;
            r_cnt <= 0;
            r_wait <= 0;
            r_data <= 0;
            r_error <= 0;
            error_counter <= 0;
        end else begin
            case (r_state)
                2'b00: begin // スタートビットの検知
                    r_data <= 0;
                    r_error <= 0;
                    if (i_data == 0) begin
                        if (r_wait == D/2) begin
                            r_state <= 2'b01;
                            r_wait <= 0;
                            r_cnt <= 0;
                        end else begin
                            r_wait <= r_wait + 1'b1;
                        end
                    end else begin
                        r_wait <= 0;
                    end
                end
                2'b01: begin // 受信中
                    if (r_wait == D-1) begin
                        r_wait <= 0;
                        r_data <= {i_data, r_data[7:1]};
                        r_cnt <= r_cnt + 1'b1;

                        if (r_cnt == 7) begin
                            r_state <= 2'b10;
                            r_cnt <= 0;
                        end
                    end else begin
                        r_wait <= r_wait + 1'b1;
                    end
                end
                2'b10: begin // 受信終了
                    if (r_wait == D-1) begin
                        if (i_data == 1) begin // ストップビットが1なら正常
                            if (r_led == 0 && r_data == 8'h01) begin
                                r_led <= 1;
                            end else if (r_led == 1 && r_data == 8'h01) begin
                                r_led <= 0;
                            end
                            r_state <= 2'b00; // 次の受信の準備
                        end else begin
                            r_state <= 2'b11;
                        end
                        r_wait <= 0;
                    end else begin
                        r_wait <= r_wait + 1'b1;
                    end
                end
                2'b11: begin //エラー
                    r_error <= 1;
                    if (error_counter < ERROR_DURATION) begin
                        error_counter <= error_counter + 1'b1;  // 一定時間カウント
                    end else begin
                        r_state <= 2'b00;  // 時間が経過したら通常状態へ
                        r_error <= 0;  // LEDを消灯
                    end
                end
            endcase
        end
    end

endmodule