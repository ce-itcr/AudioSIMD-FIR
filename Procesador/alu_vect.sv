module alu_vect #(parameter N = 8, parameter M = 4) (
    input logic signed [N-1:0] a [0:M-1],
    input logic signed [N-1:0] b [0:M-1],
    input logic [3:0] ctrl,
    output logic signed [N-1:0] result [0:M-1],
    output logic [3:0] flags [0:M-1] // {neg, zero, carry, overflow} = flags;
);

    logic signed [N-1:0] temp_result [0:M-1];

    always_comb begin
        for (int i = 0; i < M; i++) begin
            case (ctrl)
                4'b0010: temp_result[i] = a[i] * b[i];   // MULI: Multiplicación
                4'b0011: temp_result[i] = a[i] >>> b[i]; // SLRI: Shift Lógico Right
                4'b0100: temp_result[i] = a[i] <<< b[i]; // SLLI: Shift Lógico Left
                4'b0101: temp_result[i] = a[i] >> b[i];  // SARI: Shift Aritmético
                default: temp_result[i] = 0;
            endcase

            // Set flags
            flags[i][3] = (temp_result[i] < 0);         // neg
            flags[i][2] = (temp_result[i] == 0);        // zero
            flags[i][1] = (ctrl == 4'b0010) && ((a[i] * b[i]) < a[i]);  // carry for multiplication
            flags[i][0] = 0;  // No hay overflow para estas operaciones vectoriales
        end
    end

    assign result = temp_result;

endmodule