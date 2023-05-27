module setPrePCSrc (
  input       i_zero, i_neg, i_negU,
  input [2:0] i_funct3,
  input       i_branch, i_jalr, i_ecall,

  output [1:0] o_prePCSrc
);

  wire w_takeBranch = judgeBranch(
                      i_branch, i_zero, i_neg, i_negU,
                      i_funct3);

  /* */
  // prePCSrc
  //   00: PC+4
  //   01: takeBranch
  //   10: ecall
  //   11: jalr
  assign o_prePCSrc[1] = (i_ecall | i_jalr);
  assign o_prePCSrc[0] = (w_takeBranch | i_jalr);

  function judgeBranch(
    input       i_branch,
    input       i_zero, i_neg, i_negU,
    input [2:0] i_funct3
  );

    if (i_branch) begin
      case (i_funct3)
        3'b000: // beq 
          judgeBranch = i_zero;
        3'b001: // bne
          judgeBranch = ~i_zero;
        3'b100: // blt
          judgeBranch = i_neg;
        3'b101: // bge
          judgeBranch = ~i_neg;
        3'b110: // bltu
          judgeBranch = i_negU;
        3'b111: // bgeu
          judgeBranch = ~i_negU;
        default: // ???
          judgeBranch = 1'bx;
      endcase
    end 
    else begin
          judgeBranch = 1'b0;
    end
  endfunction

endmodule