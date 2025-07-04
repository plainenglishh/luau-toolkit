local t = {};

----------------------------------------------------------------------------
--  Constant Types
----------------------------------------------------------------------------

export type OperandName = "a" | "b" | "c" | "d" | "e" | "aux";

--[=[
    The 'type' of an operand.
]=]
export type OperandType = "register" | "jump_offset" | "constant" | "proto" | "number"; 

--[=[
    Metadata about an instruction operand.
]=]
export type OperandMetadata = {
    --[=[
        The name of the operand.
    ]=]
    name: string,

    --[=[
        What types the operand can be.
    ]=]
    type: {OperandType},
    
    --[=[
        A description of what the operand does.
    ]=]
    description: string,
};

--[=[
    How the operands are encoded for an opcode.
]=]
export type OperandEncodingMode = "abc" | "ad" | "e" | "none";

--[=[
    Metadata about a bytecode instruction.
]=]
export type InstructionMetadata = {
    --[=[
        The name of the instruction.
    ]=]
    name: string,

    --[=[
        The instruction opcode number.
    ]=]
    opcode: number,

    --[=[
        The instructions's operand encoding mode.
    ]=]
    mode: OperandEncodingMode,

    --[=[
        Whether the instruction expects an auxillary instruction.
    ]=]
    aux: boolean,

    --[=[
        A description of what the instruction does.
    ]=]
    description: string,

    --[=[
        An array of operands used by the instruction.
    ]=]
    operands: {OperandMetadata},

    --[=[
        How large in 32-bit words the instruction is.
    ]=]
    size: number,
};

export type InstructionName =
    | "NOP"                  | "BREAK"                | "LOADNIL"             
    | "LOADB"                | "LOADN"                | "LOADK"               
    | "MOVE"                 | "GETGLOBAL"            | "SETGLOBAL"           
    | "GETUPVAL"             | "SETUPVAL"             | "CLOSEUPVALS"         
    | "GETIMPORT"            | "GETTABLE"             | "SETTABLE"            
    | "GETTABLEKS"           | "SETTABLEKS"           | "GETTABLEN"           
    | "SETTABLEN"            | "NEWCLOSURE"           | "NAMECALL"            
    | "CALL"                 | "RETURN"               | "JUMP"                
    | "JUMPBACK"             | "JUMPIF"               | "JUMPIFNOT"           
    | "JUMPIFEQ"             | "JUMPIFLE"             | "JUMPIFLT"            
    | "JUMPIFNOTEQ"          | "JUMPIFNOTLE"          | "JUMPIFNOTLT"         
    | "ADD"                  | "SUB"                  | "MUL"                 
    | "DIV"                  | "MOD"                  | "POW"                 
    | "ADDK"                 | "SUBK"                 | "MULK"                
    | "DIVK"                 | "MODK"                 | "POWK"                
    | "AND"                  | "OR"                   | "ANDK"                
    | "ORK"                  | "CONCAT"               | "NOT"                 
    | "MINUS"                | "LENGTH"               | "NEWTABLE"            
    | "DUPTABLE"             | "SETLIST"              | "FORNPREP"            
    | "FORNLOOP"             | "FORGLOOP"             | "FORGPREP_INEXT"      
    | "FASTCALL3"            | "FORGPREP_NEXT"        | "NATIVECALL"          
    | "GETVARARGS"           | "DUPCLOSURE"           | "PREPVARARGS"         
    | "LOADKX"               | "JUMPX"                | "FASTCALL"            
    | "COVERAGE"             | "CAPTURE"              | "SUBRK"               
    | "DIVRK"                | "FASTCALL1"            | "FASTCALL2"           
    | "FASTCALL2K"           | "FORGPREP"             | "JUMPXEQKNIL"         
    | "JUMPXEQKB"            | "JUMPXEQKN"            | "JUMPXEQKS"           
    | "IDIV"                 | "IDIVK"                ;

export type ConstantType = 
    | "nil" | "boolean" | "number" | "string" | "import" | "table" | "closure" | "vector";

export type ProtoFlag = 
    | "native_module" | "native_cold" | "native_function";


----------------------------------------------------------------------------
--  Bytecode Builder Types
----------------------------------------------------------------------------

export type _BytecodeAssemblerImpl = {
    __index: _BytecodeAssemblerImpl,

    new: () -> BytecodeAssembler,
    set_version: (self: BytecodeAssembler, version: number) -> (),
    set_types_version: (self: BytecodeAssembler, version: number) -> (),
    add_string: (self: BytecodeAssembler, str: string, force: boolean?) -> number,
    add_import: (self: BytecodeAssembler, ...string) -> number,
    begin_function: (self: BytecodeAssembler) -> number,
    get_proto_id: (self: BytecodeAssembler) -> number,
    set_max_stack_size: (self: BytecodeAssembler, value: number) -> (),
    set_num_params: (self: BytecodeAssembler, value: number) -> (),
    set_num_upvalues: (self: BytecodeAssembler, value: number) -> (),
    set_is_vararg: (self: BytecodeAssembler, value: boolean) -> (),
    set_line_defined: (self: BytecodeAssembler, value: number) -> (),
    set_debug_name: (self: BytecodeAssembler, name: string) -> (),
    set_main: (self: BytecodeAssembler, proto: number?) -> (),
    set_flag: (self: BytecodeAssembler, flag: ProtoFlag, value: boolean) -> (),
    add_constant: (self: BytecodeAssembler, type: ConstantType, value: any, force: boolean?) -> number,
    emit_instruction: (self: BytecodeAssembler, opname_or_code: InstructionName|number, ...number) -> number,
    get_offset: (self: BytecodeAssembler) -> number,
    end_function: (self: BytecodeAssembler) -> number,
    to_ir: (self: BytecodeAssembler) -> Chunk,
    assemble: (self: BytecodeAssembler) -> buffer,
};

export type BytecodeAssembler = typeof(setmetatable({} :: {
    _offset: number,
    _chunk: Chunk,
    _proto: Proto?,
    _proto_id: number?,
    _instructions: {Instruction},
}, {} :: _BytecodeAssemblerImpl));


----------------------------------------------------------------------------
--  Table representation
----------------------------------------------------------------------------

--[=[
    Zero-indexed number referring to a proto.
    
    Remember to add 1 when indexing Luau's one-indexed arrays.
]=]
export type ProtoId = number;

--[=[
    One-indexed number referring to a string table entry.
    A StringId of zero usually refers to an absent value.
]=]
export type StringId = number;

--[=[
    Table representation of a bytecode chunk.
]=]
export type Chunk = {
    luau_version: number,
    types_version: number,
    strings: {string},
    userdata_types: {number}?,
    protos: {Proto},
    main_proto: ProtoId,
};

--[=[
    Table representation of a bytecode proto.
]=]
export type Proto = {
    max_stack_size: number,
    num_params: number,
    num_upvalues: number,
    is_vararg: boolean,
    flags: {ProtoFlag},
    types: ProtoTypeInfo?,
    instructions: buffer,
    constants: {Constant},
    child_protos: {ProtoId},
    line_defined: number,
    debug_name: StringId,
    line_info: buffer?,
    debug_info: ProtoDebugInfo?,
};

--[=[
    Table representation of a bytecode instruction.
]=]
export type Instruction = {
    opcode: number,
    operands: vector,
    aux: number?,
    mode: OperandEncodingMode,
};

--[=[
    Table representation of a bytecode constant.
]=]
export type Constant = {
    type: ConstantType,
    value: any,
};

--[=[
    Table representation of a bytecode proto's debug information.
]=]
export type ProtoDebugInfo = {
    locals: {{
        name: number,
        start_pc: number,
        end_pc: number,
        register: number,
    }},
    upvalues: {{
        name: number,
    }},
};

--[=[
    Table representation of a bytecode proto's type information.
]=]
export type ProtoTypeInfo = {
    func: string,
    upvalues: {number},
    locals: {{
        type: number,
        register: number,
        start_pc: number,
        length: number,
    }},
};


----------------------------------------------------------------------------
--  Validation Types
----------------------------------------------------------------------------

export type ValidationIssueSeverity = "warn" | "error";

export type ValidationIssue = {
    severity: ValidationIssueSeverity,
    message: string,
    note: string?,
};

export type ValidationResult = {
    ok: boolean,
    issues: {ValidationIssue},
};


----------------------------------------------------------------------------
--  Misc Types
----------------------------------------------------------------------------

export type bstring = buffer | string;

export type IntoChunk = Chunk | bstring;

----------------------------------------------------------------------------
--  Export
----------------------------------------------------------------------------

return t;
