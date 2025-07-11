module Forwarding_Logic (
    input [4:0] Way_0_rs,          // Source register 1 for Way 0
    input [4:0] Way_0_rt,          // Source register 2 for Way 0
    input [4:0] Way_1_rs,          // Source register 1 for Way 1
    input [4:0] Way_1_rt,          // Source register 2 for Way 1
    input [4:0] Way_0_rd_D,        // Destination register for Way 0 in Decode stage
    input [4:0] Way_1_rd_D,        // Destination register for Way 1 in Decode stage
    input [4:0] Way_0_rd_E,        // Destination register for Way 0 in Execute stage
    input [4:0] Way_1_rd_E,        // Destination register for Way 1 in Execute stage
    input [4:0] Way_0_rd_M,        // Destination register for Way 0 in Memory stage
    input [4:0] Way_1_rd_M,        // Destination register for Way 1 in Memory stage
	 input Way_0_oldest_ID, Way_0_oldest_EX, Way_0_oldest_MEM,
	 input JAL_EX, JAL_MEM,
    input Way_0_reg_write_D,       // Way 0 register write enable in Decode stage
    input Way_1_reg_write_D,       // Way 1 register write enable in Decode stage
    input Way_0_reg_write_E,       // Way 0 register write enable in Execute stage
    input Way_1_reg_write_E,       // Way 1 register write enable in Execute stage
    input Way_0_reg_write_M,       // Way 0 register write enable in Memory stage
    input Way_1_reg_write_M,       // Way 1 register write enable in Memory stage
    output reg [2:0] Way_0_forward_A, // Forwarding control for Way 0 rs
    output reg [2:0] Way_0_forward_B, // Forwarding control for Way 0 rt
    output reg [2:0] Way_1_forward_A, // Forwarding control for Way 1 rs
    output reg [2:0] Way_1_forward_B  // Forwarding control for Way 1 rt
);

    // Forwarding control encoding
    localparam NO_FORWARD = 3'b000,  // No forwarding (use register file)
               FORWARD_E_0  = 3'b001,  // Forward from Execute stage Way 0
					FORWARD_E_1  = 3'b010,  // Forward from Execute stage Way 1
               FORWARD_M_0  = 3'b011,  // Forward from Memory stage Way 0
					FORWARD_M_1  = 3'b100,  // Forward from Memory stage Way 1
               FORWARD_W_0  = 3'b101,  // Forward from Writeback stage Way 0
					FORWARD_W_1  = 3'b110;  // Forward from Writeback stage Way 1

    // Forwarding logic for Way 0
    always @(*) begin
        // Default: no forwarding
        Way_0_forward_A = NO_FORWARD;
        Way_0_forward_B = NO_FORWARD;
		  Way_1_forward_A = NO_FORWARD;
        Way_1_forward_B = NO_FORWARD;

	// We are intreasted in comparing --> Dep. inst With (W0_ID || W1_ID) THEN (W0_EX || W1_EX) THEN (W0_MEM || W1_MEM)
		  
	// Forwarding for Way 0 Rs From Way 0 OR From Way 1
        if (Way_0_reg_write_D && Way_0_rs == Way_1_rd_D && Way_0_rs != 5'b0) // ??!
            Way_0_forward_A = FORWARD_E_1;
        else if (Way_0_reg_write_E && Way_0_rs == Way_0_rd_E && Way_0_rs != 5'b0 )
            Way_0_forward_A = FORWARD_M_0;
        else if (Way_0_reg_write_E && Way_0_rs == Way_1_rd_E && Way_0_rs != 5'b0 )
            Way_0_forward_A = FORWARD_M_1;
        else if (Way_0_reg_write_M && Way_0_rs == Way_0_rd_M && Way_0_rs != 5'b0 )  
            Way_0_forward_A = FORWARD_W_0;
        else if (Way_0_reg_write_M && Way_0_rs == Way_1_rd_M && Way_0_rs != 5'b0 )  
            Way_0_forward_A = FORWARD_W_1;			

				
	// Forwarding for Way 0 Rt From Way 0
        if (Way_0_reg_write_D && Way_0_rt == Way_1_rd_D && Way_0_rt != 5'b0 )
            Way_0_forward_B = FORWARD_E_1;
        else if (Way_0_reg_write_E && Way_0_rt == Way_0_rd_E && Way_0_rt != 5'b0)
            Way_0_forward_B = FORWARD_M_0;	
        else if (Way_0_reg_write_E && Way_0_rt == Way_1_rd_E && Way_0_rt != 5'b0)
            Way_0_forward_B = FORWARD_M_1;
        else if (Way_0_reg_write_M && Way_0_rt == Way_0_rd_M && Way_0_rt != 5'b0)
            Way_0_forward_B = FORWARD_W_0;
        else if (Way_0_reg_write_M && Way_0_rt == Way_1_rd_M && Way_0_rt != 5'b0)
            Way_0_forward_B = FORWARD_W_1;
				
	// Forwarding for Way 1 Rs From Way 0
        if (Way_1_reg_write_D && Way_1_rs == Way_0_rd_D && Way_1_rs != 5'b0 )
            Way_1_forward_A = FORWARD_E_0;
        else if (Way_1_reg_write_E && Way_1_rs == Way_0_rd_E && Way_1_rs != 5'b0)
            Way_1_forward_A = FORWARD_M_0;
        else if (Way_1_reg_write_E && Way_1_rs == Way_1_rd_E && Way_1_rs != 5'b0)
            Way_1_forward_A = FORWARD_M_1;
        else if (Way_1_reg_write_M && Way_1_rs == Way_0_rd_M && Way_1_rs != 5'b0)
            Way_1_forward_A = FORWARD_W_0;
        else if (Way_1_reg_write_M && Way_1_rs == Way_1_rd_M && Way_1_rs != 5'b0)
            Way_1_forward_A = FORWARD_W_1;
				
	// Forwarding for Way 1 Rt From Way 0
        if (Way_1_reg_write_D && Way_1_rt == Way_0_rd_D && Way_1_rt != 5'b0 )
            Way_1_forward_B = FORWARD_E_0;
        else if (Way_1_reg_write_E && Way_1_rt == Way_0_rd_E && Way_1_rt != 5'b0)
            Way_1_forward_B = FORWARD_M_0;
        else if (Way_1_reg_write_E && Way_1_rt == Way_1_rd_E && Way_1_rt != 5'b0)
            Way_1_forward_B = FORWARD_M_1;
        else if (Way_1_reg_write_M && Way_1_rt == Way_0_rd_M && Way_1_rt != 5'b0)
            Way_1_forward_B = FORWARD_W_0;
        else if (Way_1_reg_write_M && Way_1_rt == Way_1_rd_M && Way_1_rt != 5'b0)
            Way_1_forward_B = FORWARD_W_1;
    				
        // Forwarding for $31 dep. From Way 1			
		if (JAL_EX)
			if (Way_0_rs == 5'h1f) 
				Way_0_forward_A = FORWARD_M_0;
			else if (Way_1_rs == 5'h1f) 
				Way_1_forward_A = FORWARD_M_0;
		
		// What if JAL_ID ???
		
		if (JAL_MEM)	
			if (Way_0_rs == 5'h1f) 
				Way_0_forward_A = FORWARD_W_0;
			else if (Way_1_rs == 5'h1f) 
				Way_1_forward_A = FORWARD_W_0;

// If i have dep. in the Way0 and Way1, from whom shall i take the forwarding ???


    end

    // Forwarding logic for Way 1
//    always @(*) begin
//        // Default: no forwarding
//        Way_1_forward_A = NO_FORWARD;
//        Way_1_forward_B = NO_FORWARD;
//
//        // Forwarding for Way 1 rs
//        if (Way_1_reg_write_D && Way_1_rs == Way_1_rd_D && Way_1_rs != 5'b0)
//            Way_1_forward_A = FORWARD_E;
//        else if (Way_1_reg_write_E && Way_1_rs == Way_1_rd_E && Way_1_rs != 5'b0)
//            Way_1_forward_A = FORWARD_M;
//        else if (Way_1_reg_write_M && Way_1_rs == Way_1_rd_M && Way_1_rs != 5'b0)
//            Way_1_forward_A = FORWARD_W;
//
//        // Forwarding for Way 1 rt
//        if (Way_1_reg_write_D && Way_1_rt == Way_1_rd_D && Way_1_rt != 5'b0)
//            Way_1_forward_B = FORWARD_E;
//        else if (Way_1_reg_write_E && Way_1_rt == Way_1_rd_E && Way_1_rt != 5'b0)
//            Way_1_forward_B = FORWARD_M;
//        else if (Way_1_reg_write_M && Way_1_rt == Way_1_rd_M && Way_1_rt != 5'b0)
//            Way_1_forward_B = FORWARD_W;
//    end

endmodule













