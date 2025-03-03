#!/usr/bin/env python3
"""
Generate a comprehensive ROCplus PCAP file with all supported opcodes
in a single TCP stream with proper sequencing.

This replaces the functionality of generate_all_pcaps.sh but ensures
correct TCP stream reassembly by maintaining proper sequence numbers.
"""

import os
import sys
import argparse
import logging
from datetime import datetime

# Ensure we can import from our current directory
sys.path.append(os.path.dirname(os.path.abspath(__file__)))
# Import by dynamically loading the module to avoid filename issues
import importlib.util
spec = importlib.util.spec_from_file_location("pcap_builder", 
    os.path.join(os.path.dirname(os.path.abspath(__file__)), "pcap-builder.py"))
pcap_builder = importlib.util.module_from_spec(spec)
spec.loader.exec_module(pcap_builder)
ROCPlusPacketBuilder = pcap_builder.ROCPlusPacketBuilder

# Configure logging
logging.basicConfig(
    format='%(levelname)s: %(message)s',
    level=logging.INFO
)
logger = logging.getLogger(__name__)

def main():
    parser = argparse.ArgumentParser(description="Generate a comprehensive ROCplus PCAP with all opcodes")
    parser.add_argument('--output', '-o', type=str, help='Output PCAP filename')
    parser.add_argument('--debug', '-d', action='store_true', help='Enable debug logging')
    parser.add_argument('--src-ip', type=str, help='Source IP address (default: 192.168.1.100)')
    parser.add_argument('--dst-ip', type=str, help='Destination IP address (default: 192.168.1.200)')
    parser.add_argument('--src-port', type=int, help='Source port (default: 32107)')
    parser.add_argument('--dst-port', type=int, help='Destination port (default: 4000)')
    args = parser.parse_args()

    # Configure debug logging if requested
    if args.debug:
        logger.setLevel(logging.DEBUG)

    # Create output directory if it doesn't exist
    output_dir = os.path.dirname(args.output) if args.output else '../traces'
    if output_dir and not os.path.exists(output_dir):
        os.makedirs(output_dir)
        logger.info(f"Created output directory: {output_dir}")

    # Set default output filename if not provided
    output_file = args.output or f"{output_dir}/all_opcodes.pcap"

    logger.info("Generating comprehensive ROCplus PCAP with all opcodes...")
    logger.info(f"Output file: {output_file}")

    # Create the packet builder
    builder = ROCPlusPacketBuilder(
        debug=args.debug,
        src_ip=args.src_ip,
        dst_ip=args.dst_ip,
        src_port=args.src_port,
        dst_port=args.dst_port
    )

    try:
        # Build the comprehensive PCAP
        packet_count = builder.build_comprehensive_pcap(output_file)
        logger.info(f"Successfully generated PCAP with {packet_count} packets")
        logger.info(f"PCAP file created: {output_file}")
        return 0
    except Exception as e:
        logger.error(f"Error generating PCAP: {str(e)}")
        return 1

if __name__ == "__main__":
    sys.exit(main()) 