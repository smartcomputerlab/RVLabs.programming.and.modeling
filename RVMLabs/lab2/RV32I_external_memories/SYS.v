module SYS (
    input wire clk,
    input wire reset
);

    // Program Counter, Next PC, and Instruction Processing
    reg [31:0] PC;
    wire [31:0] nextPC;
    wire [31:0] instruction;

    // Register File
    reg [31:0] Registers [0:31];          // 32 registers in RISC-V

    // Register data wires for ALU inputs
    wire [31:0] REGData1;                 // Data from SourceRegister1
    wire [31:0] REGData2;                 // Data from SourceRegister2

    // ALU wires
    wire [31:0] ALUOut;                   // ALU result output
    wire TakeBranch;                      // Branch decision

    // Control signals from Decoder
    wire ALUReg, ALUImmediate, Branch, JALR, JAL, AUIPC, LUI, Load, Store, System;
    wire [4:0] SourceRegister1, SourceRegister2, DestinationRegister;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [31:0] Iimm, Simm, Bimm, Uimm, Jimm;

    // Instantiate Instruction Memory module
    InstructionMemory inst_mem (
        .addr(PC),
        .instruction(instruction)
    );

    // Instantiate Decoder
    Decoder decoder (
        .instruction(instruction),
        .ALUReg(ALUReg),
        .ALUImmediate(ALUImmediate),
        .Branch(Branch),
        .JALR(JALR),
        .JAL(JAL),
        .AUIPC(AUIPC),
        .LUI(LUI),
        .Load(Load),
        .Store(Store),
        .System(System),
        .SourceRegister1(SourceRegister1),
        .SourceRegister2(SourceRegister2),
        .DestinationRegister(DestinationRegister),
        .funct3(funct3),
        .funct7(funct7),
        .Iimm(Iimm),
        .Simm(Simm),
        .Bimm(Bimm),
        .Uimm(Uimm),
        .Jimm(Jimm)
    );

    // Read register values
    assign REGData1 = Registers[SourceRegister1];
    assign REGData2 = Registers[SourceRegister2];

    // Instantiate ALU
    ALU alu (
        .instruction(instruction),
        .ALUVAL1(REGData1),
        .ALUReg(ALUReg),
        .ALUImmediate(ALUImmediate),
        .ALUREGVAl2(REGData2),
        .Iimm(Iimm),
        .funct3(funct3),
        .funct7(funct7),
        .ALUOut(ALUOut)
    );

    // Instantiate System Memory module for data loads/stores
    wire [31:0] mem_data;
    SystemMemory sys_mem (
        .clk(clk),
        .addr(ALUOut),
        .write_data(REGData2),
        .MemRead(Load),
        .MemWrite(Store),
        .read_data(mem_data)
    );

    // Determine next PC value
    assign TakeBranch = Branch && (ALUOut == 1);
    assign nextPC = (TakeBranch) ? (PC + Bimm) :
                    (JAL)       ? (PC + Jimm) :
                    (JALR)      ? (REGData1 + Iimm) :
                    (PC + 4);

    // Write to Registers or System Memory based on instruction type
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 0;
        end else begin
            PC <= nextPC;

            // Execute different instruction types based on control signals
            if (Load) begin
                Registers[DestinationRegister] <= mem_data; // Load data from memory
            end
            if (Store) begin
                // Data already written to memory through SystemMemory module
            end
            if (ALUImmediate || ALUReg) begin
                Registers[DestinationRegister] <= ALUOut; // Write ALU result to register
            end
            if (LUI) begin
                Registers[DestinationRegister] <= Uimm; // Load upper immediate
            end
            if (AUIPC) begin
                Registers[DestinationRegister] <= PC + Uimm; // AUIPC
            end
            if (JAL || JALR) begin
                Registers[DestinationRegister] <= PC + 4; // Write PC+4 to rd for JAL/JALR
            end
        end
    end

endmodule

