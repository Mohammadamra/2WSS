module Branch_compare (
    input prediction,          
    input [31:0] readData1_IS, 
    input [31:0] readData2_IS,
    input [3:0] op,
    output reg falseTaken,
    output reg falseNotTaken,
    output reg branchTaken
);

reg is_equal;
parameter BEQ = 4'b1010, 
          BNE = 4'b1011;

always @(*) begin
		is_equal <= ~(|(readData1_IS ^ readData2_IS));
	
    falseTaken    = 1'b0;
    falseNotTaken = 1'b0;
    branchTaken   = 1'b0;

    if (op == BEQ) begin
        branchTaken = (is_equal);
        falseTaken = prediction & ~branchTaken;     // Predicted Taken but was Not Taken
        falseNotTaken = ~prediction & branchTaken;  // Predicted Not Taken but was Taken
    end 
    else if (op == BNE) begin
        branchTaken = (!is_equal);
        falseTaken = prediction & ~branchTaken;
        falseNotTaken = ~prediction & branchTaken;
    end
end

endmodule 