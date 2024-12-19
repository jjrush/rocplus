spicy_add_analyzer(
    NAME roc_plus
    PACKAGE_NAME roc_plus
    SOURCES zeek_roc_plus.spicy
            roc_plus_functions.spicy
            roc_plus_functions.cc
            roc_plus.spicy
            roc_plus.evt
            roc_plus_enums.spicy
            roc_plus_opcode_006.spicy
            roc_plus_opcode_007.spicy
            roc_plus_opcode_008.spicy
            roc_plus_opcode_010.spicy
            roc_plus_opcode_011.spicy
            roc_plus_opcode_017.spicy
            roc_plus_opcode_024.spicy
            roc_plus_opcode_050.spicy
            roc_plus_opcode_100.spicy
            roc_plus_opcode_105.spicy
            roc_plus_opcode_108.spicy
            roc_plus_opcode_118.spicy
            roc_plus_opcode_119.spicy
            roc_plus_opcode_137.spicy
            roc_plus_opcode_138.spicy
            roc_plus_opcode_166.spicy
            roc_plus_opcode_167.spicy
        #     roc_plus_opcode_180.spicy
            roc_plus_opcode_203.spicy
            roc_plus_opcode_206.spicy
            roc_plus_opcode_255.spicy
    SCRIPTS ../scripts/__load__.zeek
            ../scripts/main.zeek
            ../scripts/roc_plus_enums.zeek
            ../scripts/roc_plus_processing.zeek
            ../scripts/roc_plus_event_processing.zeek
            ../scripts/roc_plus_types.zeek
            ../scripts/roc_plus_utilities.zeek
            ../scripts/roc_plus_opcode_006.zeek
            ../scripts/roc_plus_opcode_007.zeek
            ../scripts/roc_plus_opcode_008.zeek
            ../scripts/roc_plus_opcode_010.zeek
            ../scripts/roc_plus_opcode_011.zeek
            ../scripts/roc_plus_opcode_017.zeek
            ../scripts/roc_plus_opcode_024.zeek
            ../scripts/roc_plus_opcode_050.zeek
            ../scripts/roc_plus_opcode_100.zeek
            ../scripts/roc_plus_opcode_105.zeek
            ../scripts/roc_plus_opcode_108.zeek
            ../scripts/roc_plus_opcode_118.zeek
            ../scripts/roc_plus_opcode_119.zeek
            ../scripts/roc_plus_opcode_137.zeek
            ../scripts/roc_plus_opcode_138.zeek
            ../scripts/roc_plus_opcode_166.zeek
            ../scripts/roc_plus_opcode_167.zeek
        #     roc_plus_opcode_180.zeek
        #     roc_plus_opcode_181.zeek
            ../scripts/roc_plus_opcode_203.zeek
            ../scripts/roc_plus_opcode_206.zeek
            ../scripts/roc_plus_opcode_255.zeek
    ENV HILTI_CXX_FLAGS=-fno-var-tracking-assignments
)