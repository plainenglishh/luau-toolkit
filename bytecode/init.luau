local misc = require("./src/misc");
local t = require("./src/typedefs");

local bytecode = {};

bytecode.encode = require("./src/encode");
bytecode.decode = require("./src/decode");
bytecode.opcodes = require("./src/opcodes");
bytecode.constants = require("./src/constants");
bytecode.BytecodeBuilder = require("./src/BytecodeBuilder");
bytecode.get_opcode_info = misc.get_opcode_info;
bytecode.encode_import_id = misc.encode_import_id;
bytecode.decode_import_id = misc.decode_import_id;

--BEGIN_REEXPORTS
export type OperandName = t.OperandName;
export type OperandMode = t.OperandMode;
export type OperandType = t.OperandType;
export type OperandInfo = t.OperandInfo;
export type OpcodeInfo = t.OpcodeInfo;
export type OpcodeName = t.OpcodeName;
export type ConstantType = t.ConstantType;
export type ProtoFlag = t.ProtoFlag;
export type BytecodeBuilderImpl = t.BytecodeBuilderImpl;
export type BytecodeBuilder = t.BytecodeBuilder;
export type BytecodeChunk = t.BytecodeChunk;
export type BytecodeProto = t.BytecodeProto;
export type BytecodeInstruction = t.BytecodeInstruction;
export type BytecodeConstant = t.BytecodeConstant;
export type BytecodeProtoDebugInfo = t.BytecodeProtoDebugInfo;
export type BytecodeProtoTypeInfo = t.BytecodeProtoTypeInfo;
--END_REEXPORTS

return bytecode;
