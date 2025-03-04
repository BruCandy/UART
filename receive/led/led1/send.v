module send(
    input   wire       i_clk,
    input   wire       i_rst,
    input   wire [7:0] i_data,
    input   wire       i_we,
    output  wire       o_data,
    output  wire       o_busy
);

    parameter D = 234; //round(27MHz / 115_200bit/s)
    parameter L = 8;   //234を表現するためには8bit必要

    reg [9:0]      r_data;
    reg [L-1:0]    r_wait;       
    reg [3:0]      r_cnt;
    reg            r_state;

    assign o_data       =   r_data[0];
    assign o_busy       =   (r_state == 1);

    always @(posedge i_clk or posedge i_rst) begin
        if(i_rst) begin
            r_state     <= 0;
            r_wait       <= 0;
            r_cnt   <= 4'd0;
            r_data      <= 10'b1111111111;
        end else begin
            case (r_state)
                0: begin
                    if (i_we) begin
                        r_state <= 1;
                        r_data <= {1'b1, i_data, 1'b0};
                    end
                end
                1: begin
                    if (r_wait == D-1) begin
                        if (r_cnt == 4'd9) begin
                            r_state <= 0;
                            r_wait <= 0;
                            r_cnt <= 4'd0;
                        end else begin
                            r_data <= {1'b1, r_data[9:1]};
                            r_wait <= 0;
                            r_cnt <= r_cnt + 1'b1;
                        end
                    end else begin
                        r_wait <= r_wait + 1'b1;
                    end
                end
            endcase
        end
    end
endmodule