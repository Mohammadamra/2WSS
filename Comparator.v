module Comparator (
    input wire [31:0] readData1,  
    input wire [31:0] readData2,  
    output wire equal            
);

    assign equal = (readData1 == readData2);
endmodule