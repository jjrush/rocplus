# ROC Plus PCAP Builder

A utility script for generating PCAP files containing ROC Plus protocol packets for testing and analysis.

## Installation

Dependencies can be installed using either pip or apt:

```bash
# Using pip
pip install -r requirements.txt

# Using apt
sudo apt-get install $(cat apt-requirements.txt)
```

## Usage

The script generates PCAP files containing either request or response packets for various ROC Plus opcodes:

```bash
# Basic usage
./pcap-builder.py --opcode <OPCODE> [--req|--res] [--variant <VARIANT>] [--output <OUTPUT_FILE>]

# Example: Generate a request packet for opcode 6
./pcap-builder.py --opcode 6 --req

# Example: Generate a request packet for opcode 139
./pcap-builder.py --opcode 139 --req --variant cmd0

# Example: Generate a response packet for opcode 180
./pcap-builder.py --opcode 180 --res --variant single --output my_packet.pcap
```

### Arguments

- `--opcode`: Required. The ROC Plus opcode to use
- `--req` or `--res`: Required. Generate either a request or response packet
- `--variant`: Optional. Specific variant for opcodes that support them
- `--output`: Optional. Custom output filename
- `--debug`: Optional. Enable debug logging

Some opcodes require specific variants for requests and/or responses. Run the script with an invalid variant to see the available options for each opcode.
