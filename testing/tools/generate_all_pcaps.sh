#!/bin/bash

# Create a directory for the generated PCAPs
OUTPUT_DIR="pcaps"
mkdir -p "$OUTPUT_DIR"

# Function to generate a PCAP file with given parameters
generate_pcap() {
    OPCODE=$1
    TYPE=$2  # req or res
    VARIANT=$3  # Optional variant
    
    # Base command
    CMD="python3 ./pcap-builder.py --opcode $OPCODE --$TYPE"
    
    # Add variant if provided
    if [ -n "$VARIANT" ]; then
        CMD="$CMD --variant $VARIANT"
    fi
    
    # Set output filename
    if [ -n "$VARIANT" ]; then
        FILENAME="${OUTPUT_DIR}/opcode_${OPCODE}_${VARIANT}_${TYPE}.pcap"
    else
        FILENAME="${OUTPUT_DIR}/opcode_${OPCODE}_${TYPE}.pcap"
    fi
    
    CMD="$CMD --output $FILENAME"
    
    # Execute the command
    echo "Generating: $FILENAME"
    $CMD || echo "Failed to generate $FILENAME"
}

echo "Starting to generate all ROC Plus PCAP files..."

# Generate for opcode 6 (System Configuration)
generate_pcap 6 req
generate_pcap 6 res

# Generate for opcode 7 (Read Real-time Clock)
generate_pcap 7 req
generate_pcap 7 res

# Generate for opcode 8 (Set Real-time Clock)
generate_pcap 8 req
generate_pcap 8 res

# Generate for opcode 10 (Read Configurable Opcode Point Data)
generate_pcap 10 req
for VARIANT in single max; do
    generate_pcap 10 res $VARIANT
done

# Generate for opcode 11 (Write Configurable Opcode Point Data)
for VARIANT in single max; do
    generate_pcap 11 req $VARIANT
done
generate_pcap 11 res

# Generate for opcode 17 (Login/Logout Operations)
for VARIANT in login_standard login_enhanced logout_standard logout_enhanced session; do
    generate_pcap 17 req $VARIANT
    generate_pcap 17 res $VARIANT
done

# Generate for opcode 24 (Store and Forward)
for VARIANT in single max; do
    generate_pcap 24 req $VARIANT
done
generate_pcap 24 res

# Generate for opcode 50 (Request I/O Point Position)
generate_pcap 50 req
for VARIANT in mode_1 mode_2 mode_3; do
    generate_pcap 50 res $VARIANT
done

# Generate for opcode 100 (Access User-defined Information)
generate_pcap 100 req
for VARIANT in single max; do
    generate_pcap 100 res $VARIANT
done

# Generate for opcode 105 (Request Today's and Yesterday's Min/Max Values)
generate_pcap 105 req
generate_pcap 105 res

# Generate for opcode 108 (Request History Tag and Periodic Index)
for VARIANT in single max; do
    generate_pcap 108 req $VARIANT
    generate_pcap 108 res $VARIANT
done

# Generate for opcode 118 (Request Alarm Data)
for VARIANT in single max; do
    generate_pcap 118 req $VARIANT
    generate_pcap 118 res $VARIANT
done

# Generate for opcode 119 (Request Event Data)
generate_pcap 119 req
for VARIANT in single max; do
    generate_pcap 119 res $VARIANT
done

# Generate for opcode 135 (Request Single History Point Data)
generate_pcap 135 req
for VARIANT in single max; do
    generate_pcap 135 res $VARIANT
done

# Generate for opcode 136 (Request Multiple History Point Data)
generate_pcap 136 req
for VARIANT in single max; do
    generate_pcap 136 res $VARIANT
done

# Generate for opcode 137 (Request History Index for a Day)
generate_pcap 137 req
generate_pcap 137 res

# Generate for opcode 138 (Request Daily and Periodic History for a Day)
generate_pcap 138 req
for VARIANT in single max; do
    generate_pcap 138 res $VARIANT
done

# Generate for opcode 139 Request (History Information Data)
for VARIANT in cmd0 cmd1_single cmd1_max; do
    generate_pcap 139 req $VARIANT
done

# Generate for opcode 139 Response (History Information Data)
for VARIANT in cmd0_single cmd0_max cmd1_single cmd1_max_with_timestamps cmd1_max_without_timestamps; do
    generate_pcap 139 res $VARIANT
done

# Generate for opcode 166 (Set Single Point Parameters)
for VARIANT in single max; do
    generate_pcap 166 req $VARIANT
done
generate_pcap 166 res

# Generate for opcode 167 (Request Single Point Parameters)
generate_pcap 167 req
for VARIANT in single max; do
    generate_pcap 167 res $VARIANT
done

# Generate for opcode 180 (Request Parameters)
for VARIANT in single multi max; do
    generate_pcap 180 req $VARIANT
    generate_pcap 180 res $VARIANT
done

# Generate for opcode 181 (Set Parameters)
for VARIANT in single multi max; do
    generate_pcap 181 req $VARIANT
done
generate_pcap 181 res

# Generate for opcode 203 (General File Transfer)
for VARIANT in open read_single read_max write_single write_max close delete read_dir_single read_dir_max read_dir_64_single read_dir_64_max; do
    generate_pcap 203 req $VARIANT
    generate_pcap 203 res $VARIANT
done

# Generate for opcode 205 (Peer-to-Peer Network Messages)
for VARIANT in single multi max; do
    generate_pcap 205 req $VARIANT
    generate_pcap 205 res $VARIANT
done

# Generate for opcode 206 Request (Read Transaction History Data)
for VARIANT in list read_single read_max; do
    generate_pcap 206 req $VARIANT
done

# Generate for opcode 206 Response (Read Transaction History Data)
for VARIANT in list_single list_max read_single read_max; do
    generate_pcap 206 res $VARIANT
done

# Generate for opcode 224 (SRBX Signal)
for VARIANT in single max; do
    generate_pcap 224 req $VARIANT
done
generate_pcap 224 res

# Generate for opcode 225 (Acknowledge SRBX)
generate_pcap 225 req
generate_pcap 225 res

# Generate for opcode 255 (Invalid Parameters)
generate_pcap 255 req
for VARIANT in single max; do
    generate_pcap 255 res $VARIANT
done

echo "All PCAP files have been generated in the '$OUTPUT_DIR' directory"

# Optional: Create a combined PCAP with all packets
echo "Creating combined PCAP file with all packets..."

# Check if any PCAP files were successfully generated
PCAP_COUNT=$(find "${OUTPUT_DIR}" -name "*.pcap" | wc -l)

if [ "$PCAP_COUNT" -gt 0 ]; then
    MERGECAP_CMD="mergecap -w ${OUTPUT_DIR}/all_combined.pcap ${OUTPUT_DIR}/*.pcap"
    if command -v mergecap > /dev/null 2>&1; then
        $MERGECAP_CMD
        echo "Combined PCAP created: ${OUTPUT_DIR}/all_combined.pcap"
    else
        echo "mergecap not found. To create a combined PCAP file, install Wireshark tools and run:"
        echo "$MERGECAP_CMD"
    fi
else
    echo "No PCAP files were successfully generated. Cannot create combined file."
fi

echo "Done!" 