module synchronous_fifo #(
  parameter data_width=8,
  parameter fifo_depth=8
)(
  input clk,reset,
  input wr_en,re_en,
  input [data_width-1:0]data_in,
  output reg [data_width-1:0]data_out,
  output  full,
  output  empty
);
  
  localparam fifo_depth_log=$clog2(fifo_depth);
  
  reg [fifo_depth_log:0]wr_ptr; // 3:0
  reg [fifo_depth_log:0]re_ptr; //3:0
  
  reg [data_width-1:0]fifo[fifo_depth];
  
  //write logic
  
  always @(posedge clk or posedge reset) begin
    if(reset)
      wr_ptr<=0;
    else if(wr_en && !full) begin
      fifo[wr_ptr[fifo_depth_log-1:0]]<=data_in;
      wr_ptr<=wr_ptr+1;
    end
  end
  
  //read logic
  
  always @(posedge clk or posedge reset) begin
    if(reset)
      re_ptr<=0;
    else if(re_en && !empty) begin
      data_out<=fifo[re_ptr[fifo_depth_log-1:0]];
      re_ptr<=re_ptr+1;
    end  
  end
  
  assign empty = (wr_ptr==re_ptr);
  
  assign full = ( {~wr_ptr[3],wr_ptr[2:0]} == re_ptr );
  
endmodule
    
      
