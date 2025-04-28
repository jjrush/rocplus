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
./pcap-builder.py --opcode <OPCODE> [--req|--res] [--variant <VARIANT>] [--output <OUTPUT_FILE>] [--protocol <PROTOCOL>]

# Example: Generate a request packet for opcode 6
./pcap-builder.py --opcode 6 --req

# Example: Generate a request packet for opcode 139
./pcap-builder.py --opcode 139 --req --variant cmd0

# Example: Generate a response packet for opcode 180
./pcap-builder.py --opcode 180 --res --variant single --output my_packet.pcap

# Example: Generate a request packet for opcode 6 using UDP protocol
./pcap-builder.py --opcode 6 --req --protocol udp

# Example: Generate comprehensive PCAP file with all opcodes
./pcap-builder.py --all --output comprehensive.pcap

# Example: Generate comprehensive PCAP file for UDP protocol
./pcap-builder.py --all --protocol udp --output comprehensive_udp.pcap

# Example: Using custom network parameters
./pcap-builder.py --opcode 6 --req --src-ip 10.0.0.1 --dst-ip 10.0.0.2 --src-port 12345 --dst-port 5000
```

### Arguments

- `--opcode`: The ROC Plus opcode to use (required unless --all is specified)
- `--req` or `--res`: Required. Generate either a request or response packet
- `--variant`: Optional. Specific variant for opcodes that support them
- `--output`: Optional. Custom output filename
- `--debug`: Optional. Enable debug logging
- `--protocol`: Optional. Specify the protocol to use ('tcp' or 'udp'), defaults to 'tcp'
- `--all`: Optional. Generate a comprehensive PCAP with all supported opcodes, making --opcode not required
- `--src-ip`: Optional. Source IP address (default: 192.168.1.100)
- `--dst-ip`: Optional. Destination IP address (default: 192.168.1.200)
- `--src-port`: Optional. Source port (default: 32107)
- `--dst-port`: Optional. Destination port (default: 4000)
- `--comprehensive`: Alias for `--all`

Some opcodes require specific variants for requests and/or responses. Run the script with an invalid variant to see the available options for each opcode.

## Generated Files

When no output filename is specified:
- For single opcode mode: `rocplus_opcode_XXX_[variant]_[request/response]_[protocol]_[timestamp].pcap`
- For comprehensive mode: `../traces/all_opcodes_[protocol].pcap`
