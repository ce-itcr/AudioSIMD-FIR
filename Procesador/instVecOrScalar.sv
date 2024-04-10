module instVecOrScalar(input logic InstSelec,
							input logic[31:0] Inst,
							output logic[31:0] InstS,
							output logic[31:0] InstV);
							
logic[11:0] addi_escalar;
assign addi_escalar = 12'b001000000000;
							
							
always_comb

	case(InstSelec)
	
	1'b0: begin
				InstS = Inst;
				InstV = 32'b00011100000000000000000000000000;
			end


	1'b1: begin
				case(Inst[31:29])
				
					3'b100: begin
						InstS = {addi_escalar, Inst[19:0]};
						InstV = Inst;
					end
					
					3'b101: begin
						InstS = {addi_escalar, Inst[19:0]};
						InstV = Inst;
					end
					
					default: begin
						InstS = 32'b00100000000000000000000000000000;
						InstV = Inst;
					end
				
				endcase
			end


	
			default: begin
				InstS = 32'b00100000000000000000000000000000;
				InstV = 32'b00011100000000000000000000000000;// undefined
			end
	endcase

endmodule
