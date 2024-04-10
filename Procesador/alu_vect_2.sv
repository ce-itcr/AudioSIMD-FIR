module alu_vect_2 #(parameter N = 8, parameter M = 16) (
    input logic signed [0:M-1][N-1:0] a,
    input logic signed [0:M-1][N-1:0] b,
    input logic [3:0] ctrl,
    output logic signed [0:M-1][N-1:0] result,
    output logic [3:0] flags // {neg, zero, carry, overflow} = flags;
);

    logic signed [0:M-1][N-1:0] temp_result;

    always_comb begin
        for (int i = 0; i < M; i++) begin
            case (ctrl)
                4'b1000: temp_result[i] = a[i] * b[i];   // MULI: Multiplicación
                4'b1001: temp_result[i] = a[i] >>> b[i]; // SLRI: Shift Lógico Right
                4'b1010: temp_result[i] = a[i] <<< b[i]; // SLLI: Shift Lógico Left
                4'b1011: temp_result[i] = a[i] >> b[i];  // SARI: Shift Aritmético
                default: temp_result[i] = 0;
            endcase

            flags = 4'b0000;
        end
    end

    assign result = temp_result;

endmodule