module Adder #(parameter Size = 32)(
    input [Size - 1 : 0] a,
    input [31: 0] PC,
	 input Reset,
    output reg [31: 0] f
);

reg [27:0]a_concat;
    always @(*) begin
        if (Size == 32) begin
				if(Reset)
					f = 32'b0; // Standard addition for BRNCH & NEXTPC
				else
					f = a + PC;
        end else if (Size == 26) begin
				a_concat = {2'b00, a[25:0]};
            f = {PC[31:28], a_concat[27:0]}; // Concatenate upper 4 bits of PC with 'a || 00'
        end
    end
endmodule

