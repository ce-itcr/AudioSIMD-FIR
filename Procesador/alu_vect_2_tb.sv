module alu_vect_2_tb;

    // Parámetros del diseño
    parameter N = 8; // Longitud de los elementos del vector
    parameter M = 4; // Número de elementos en el vector

    // Definición de señales
    logic signed [0:M-1][N-1:0] a;
    logic signed [0:M-1][N-1:0] b;
    logic [3:0] ctrl;
    logic signed [0:M-1][N-1:0] result;
    logic [3:0] flags;

    // Instancia de la ALU vectorial
    alu_vect_2 #(N, M) dut (
        .a(a),
        .b(b),
        .ctrl(ctrl),
        .result(result),
        .flags(flags)
    );

    // Generador de estímulos
    initial begin
        $randomseed($time);

        // Generar vectores de entrada aleatorios
        for (int i = 0; i < M; i++) begin
            a[i] = $random;
            b[i] = $random;
        end

        // Aplicar operaciones y mostrar resultados
        // MULI: Multiplicación
        ctrl = 4'b0010;
        #10;
        $display("Multiplicación:");
        for (int i = 0; i < M; i++) begin
            $display("a[%0d] * b[%0d] = %d", i, i, result[i]);
        end

        // SLRI: Shift Lógico Right
        ctrl = 4'b0011;
        #10;
        $display("Shift Lógico Right:");
        for (int i = 0; i < M; i++) begin
            $display("a[%0d] >>> b[%0d] = %d", i, i, result[i]);
        end

        // SLLI: Shift Lógico Left
        ctrl = 4'b0100;
        #10;
        $display("Shift Lógico Left:");
        for (int i = 0; i < M; i++) begin
            $display("a[%0d] <<< b[%0d] = %d", i, i, result[i]);
        end

        // SARI: Shift Aritmético
        ctrl = 4'b0101;
        #10;
        $display("Shift Aritmético:");
        for (int i = 0; i < M; i++) begin
            $display("a[%0d] >> b[%0d] = %d", i, i, result[i]);
        end

        // Finalizar la simulación
        $stop;
    end

endmodule
