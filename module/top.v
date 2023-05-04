`include "module/controller.v"
`include "module/datapath.v"

module top(
  input         clk, rst,
  input         ACKD_n, ACKI_n,
  input [31:0]  IDT,
  input [2:0]   OINT_n,

  output [31:0] IAD, DAD,
  output        MREQ, WRITE,
  output [1:0]  SIZE,
  output        IACK_n,

  inout [31:0]  DDT  // in: readData, out: writeData
);

  wire [1:0]  w_memSize;
  wire        w_regWrite;
  wire        w_ALUSrc;
  wire [1:0]  w_PCSrc;
  wire [2:0]  w_immSrc;
  wire        w_immPlusSrc;
  wire        w_readDataSrc;
  wire [1:0]  w_resultSrc;
  wire [3:0]  w_ALUCtrl;
  wire        w_zero, w_neg, w_negU;


  // inout 
  wire [31:0] w_writeData;
  reg [31:0] r_readData;
  // reg [31:0] r_oDDT;
  always @(negedge clk, negedge rst) begin
    if (~rst)       r_readData <= 32'b0;
    else            r_readData <= DDT;
    // else            r_readData <= 32'bx;
  end
  // always @(posedge clk)
  //   r_oDDT <= w_writeData;
  // assign DDT = WRITE? r_oDDT : 32'bz;
  assign DDT = WRITE? w_writeData : r_readData;

  // reset some controll bit
  // reg r_regWrite;
  // always @(negedge clk, negedge rst) begin
  //   if (~rst) begin
  //     r_regWrite <= 1'b0;
  //   end else begin
  //     r_regWrite <= w_regWrite;
  //   end
  // end

  datapath datapath(
    .i_clk(clk), .i_reset_x(rst),
    .i_inst(IDT), .i_readData(r_readData),

    .i_memSize(w_memSize),
    .i_regWrite(w_regWrite),
    .i_PCSrc(w_PCSrc), .i_ALUSrc(w_ALUSrc),
    .i_immSrc(w_immSrc), .i_immPlusSrc(w_immPlusSrc),
    .i_readDataSrc(w_readDataSrc), .i_resultSrc(w_resultSrc),
    .i_ALUCtrl(w_ALUCtrl),

    .o_PC(IAD), .o_ALUOut(DAD), .o_writeData(w_writeData),

    .o_zero(w_zero), .o_neg(w_neg), .o_negU(w_negU)
  );

  controller controller(
    .i_inst(IDT),

    .i_zero(w_zero), .i_neg(w_neg), .i_negU(w_negU),

    .o_memReq(MREQ), .o_memWrite(WRITE),
    .o_memSize(SIZE),

    .o_regWrite(w_regWrite), 
    .o_PCSrc(w_PCSrc), .o_ALUSrc(w_ALUSrc), 
    .o_immSrc(w_immSrc), .o_immPlusSrc(w_immPlusSrc), 
    .o_readDataSrc(w_readDataSrc), .o_resultSrc(w_resultSrc), 
    .o_ALUCtrl(w_ALUCtrl)
  );

endmodule