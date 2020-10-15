`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2020 02:54:34 PM
// Design Name: 
// Module Name: top_7seg_Br_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_7seg_Br_tb(
    );
    // from the system
    reg clk;
    reg  rst;   
	wire rst_n;

    wire tb_usb_rx;           // USB->Serial input
    wire [7:0] rec_data;
	wire rec_avail;
	wire rec_err;


    wire tb_usb_tx;           // USB->Serial output
    reg [7:0] tx_data;
	reg tx_send;
	wire tx_empty;
	wire tx_err;
     
    // Output
	wire[7:0] io_seg;
	wire [3:0] io_sel;

    
wire [3:0] val3; 
wire [3:0] val2;   
wire [3:0] val1;   
wire [3:0] val0;      

assign rst_n = ~rst;

assign val3 = 4'h5;  
assign val2 = 4'h4;  
assign val1 = 4'h3;  
assign val0 = 4'h2;    

wire [6:0] io_seg_int;
wire [3:0] io_sel_int;

// wire up the segments as needed. Set DP off:1 for now
assign io_seg[0] = ~io_seg_int[6];
assign io_seg[1] = ~io_seg_int[5];
assign io_seg[2] = ~io_seg_int[4];
assign io_seg[3] = ~io_seg_int[3];
assign io_seg[4] = ~io_seg_int[2];
assign io_seg[5] = ~io_seg_int[1];
assign io_seg[6] = ~io_seg_int[0];
assign io_seg[7] = ~io_seg_int[7];

assign io_sel = io_sel_int;
 
IoBd_7segX4 IoBoard(
	.clk(clk),
	.reset(~rst_n),
	.seg3_hex(val3),
	.seg3_dp(1'b0),
	.seg3_ena(1'b1),
	.seg2_hex(val2),
	.seg2_dp(1'b0),
	.seg2_ena(1'b1),
	.seg1_hex(val1),
	.seg1_dp(1'b0),
	.seg1_ena(1'b1),
	.seg0_hex(val0),
	.seg0_dp(1'd0),
	.seg0_ena(1'b1),
	.bright(4'b0000),
	.seg_data(io_seg_int[6:0]),
	.seg_select(io_sel_int)
	);   
       

IoBd_Uart_RX Uart_RX(
    .clk(clk),
    .rst(rst),
    .rx_in(tb_usb_rx),
    .data_out(rec_data),
    .data_avail(rec_avail),
    .data_error(rec_err)
    );

assign tb_usb_rx = tb_usb_tx;


IoBd_Uart_TX Uart_TX(
    .clk(clk),
    .rst(rst),
    .tx_out(tb_usb_tx),
    .tx_data( tx_data ),
    .tx_rdy(tx_empty),
    .tx_req(tx_send)
    );
    
    initial begin

        rst = 1;
        clk = 0;
        #50;
        clk = 1;
        #50;
        clk = 0;
        #50;
        clk = 1;
        #50;
        clk = 0;
        #50;
        clk = 1;
        #50;
        clk = 0;
        rst = 0;
        #50;
        clk = 1;
        #50;
        clk = 0;
        tx_data = 8'h41;
        tx_send = 1;
        #50;
        repeat (4) begin
            clk =  ! clk;
            #50;
        end
        
        repeat (100) begin
            clk =  ! clk;
            #50;
            tx_send = 0;
        end
   

        repeat (100000) begin
            clk =  ! clk;
            #50;
            tx_send = 0;
        end

        #200;
        clk =  ! clk;
        end
            
endmodule




