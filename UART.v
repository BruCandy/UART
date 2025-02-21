module UART(
    input   wire       i_clk,
    input   wire       i_rst,
    input   wire [7:0] i_data,
    input   wire       i_we,
    output  wire       o_data,
    output  wire       o_busy
);

    parameter D = 234; //round(27MHz / 115_200bit/s)

    reg [9:0]  r_data;
    reg [7:0]  r_cnt;       //234を表現するためには8bit必要
    reg [3:0]  r_cnt_bit;
    reg        r_state;

    wire [9:0]  w_data;
    wire [7:0]  w_cnt;      //234を表現するためには8bit必要
    wire [3:0]  w_cnt_bit;
    wire        w_state;


    assign o_data       =   r_data[0];
    assign o_busy       =   (r_state == 1);
    assign w_state     =   (r_state == 0 && i_we == 1) ? 1 : 
                            (r_state == 1 && r_cnt == D-1 && r_cnt_bit == 4'd9) ? 0 : r_state;
    assign w_cnt       =   (r_state == 1 && r_cnt == D-1) ? 0 :
                            (r_state == 1 && r_cnt != D-1) ? r_cnt + 1'b1 : r_cnt;
    assign w_cnt_bit   =   (r_state == 1 && r_cnt == D-1 && r_cnt_bit == 4'd9) ? 4'd0 :
                            (r_state == 1 && r_cnt == D-1 && r_cnt_bit != 4'd9) ? r_cnt_bit + 1'b1 : r_cnt_bit;
    assign w_data      =   (r_state == 0 && i_we == 1) ? {1'b1, i_data, 1'b0} :
                            (r_state == 1 && r_cnt == D-1 && r_cnt_bit != 4'd9) ? {1'b1, r_data[9:1]} : r_data;


    always @(posedge i_clk) begin
        if(i_rst) begin
            r_state     <= 0;
            r_cnt       <= 0;
            r_cnt_bit   <= 4'd0;
            r_data      <= 10'h3ff;
        end else begin
            r_state     <= w_state;
            r_cnt       <= w_cnt;
            r_cnt_bit   <= w_cnt_bit;
            r_data      <= w_data;
        end
    end

endmodule