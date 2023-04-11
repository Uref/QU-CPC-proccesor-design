module ALU_tb();
  reg [31:0] in_1, in_2;
  reg [2:0] ctrl;
  wire [31:0] out_1;
  wire o_zero, o_minus;

  ALU ALU(in_1, in_2, ctrl, out_1, o_zero, o_minus);

  initial begin
    $monitor("%b : %b %b => %b [z:%b][m:%b]",
              ctrl, in_1, in_2, out_1, o_zero, o_minus);
  end

  initial begin
    #1
      ctrl <= 3'b000; // Add signed
      in_1 <= 2;
      in_2 <= 2;
    #1
      ctrl <= 3'b001; // Sub signed
      in_1 <= 128;
      in_2 <= 2;
    #1
      ctrl <= 3'b010; // And
      in_1 <= 127;
      in_2 <= 2;
    #1
      ctrl <= 3'b011; // Or
      in_1 <= 128;
      in_2 <= 2;
    #1
      ctrl <= 3'b100; // Xor
      in_1 <= 32'b0000_0000_0000_0000_0000_0000_0000_0110;
      in_2 <= 32'b0000_0000_0000_0000_0000_0000_0000_1010;
    #1
      ctrl <= 3'b101; // Sift right arith.
      in_1 <= 32'b1000_0000_0000_0000_0000_0000_0000_1111;
      in_2 <= 32'b0000_0000_0000_0000_0000_0000_0000_0010;
    #1
      ctrl <= 3'b110; // Sift right logic
      in_1 <= 32'b1000_0000_0000_0000_0000_0000_0000_1111;
      in_2 <= 32'b0000_0000_0000_0000_0000_0000_0000_0010;
    #1
      ctrl <= 3'b111; // Sift left logic
      in_1 <= 32'b1000_0000_0000_0000_0000_0000_0000_1111;
      in_2 <= 32'b0000_0000_0000_0000_0000_0000_0000_0010;
  end

endmodule