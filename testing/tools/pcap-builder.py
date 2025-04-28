#!/usr/bin/env python3

from scapy.all import *
import crcmod
import argparse
from datetime import datetime
import sys
import logging
from payloads import OPCODE_PAYLOADS
import struct
import os

# Configure logging
logging.basicConfig(
    format='%(levelname)s: %(message)s',
    level=logging.INFO
)
logger = logging.getLogger(__name__)

# Opcode variant configuration
OPCODE_VARIANTS = {
    10: {
        'variants': ['single', 'max'],
        'description': 'Read Configurable Opcode Point Data - Response has variable data',
        'required': 'response_only'
    },
    11: {
        'variants': ['single', 'max'],
        'description': 'Write Configurable Opcode Point Data - Request has variable data',
        'required': 'request_only'
    },
    17: {
        'variants': ['login_standard', 'login_enhanced', 'logout_standard', 'logout_enhanced', 'session'],
        'description': 'Login/Logout Operations',
        'required': True
    },
    24: {
        'variants': ['single', 'max'],
        'description': 'Store and Forward - Variable data size in request',
        'required': 'request_only'
    },
    50: {
        'variants': ['mode_1', 'mode_2', 'mode_3'],
        'description': 'Request I/O Point Position',
        'required': 'response_only'
    },
    100: {
        'variants': ['single', 'max'],
        'description': 'Access User-defined Information',
        'required': 'response_only'
    },
    108: {
        'variants': ['single', 'max'],
        'description': 'Request History Tag and Periodic Index',
        'required': True
    },
    118: {
        'variants': ['single', 'max'],
        'description': 'Request Alarm Data',
        'required': True
    },
    119: {
        'variants': ['single', 'max'],
        'description': 'Request Event Data',
        'required': 'response_only'
    },
    135: {
        'variants': ['single', 'max'],
        'description': 'Request Single History Point Data',
        'required': 'response_only'
    },
    136: {
        'variants': ['single', 'max'],
        'description': 'Request Multiple History Point Data',
        'required': 'response_only'
    },
    138: {
        'variants': ['single', 'max'],
        'description': 'Request Daily and Periodic History for a Day',
        'required': 'response_only'
    },
    139: {
        'variants': ['cmd0', 'cmd0_single', 'cmd0_max', 'cmd1_single', 'cmd1_max','cmd1_max_with_timestamps', 'cmd1_max_without_timestamps'],
        'description': 'History Information Data',
        'required': True
    },
    166: {
        'variants': ['single', 'max'],
        'description': 'Set Single Point Parameters',
        'required': 'request_only'
    },
    167: {
        'variants': ['single', 'max'],
        'description': 'Request Single Point Parameters',
        'required': 'response_only'
    },
    180: {
        'variants': ['single', 'multi', 'max'],
        'description': 'Request Parameters',
        'required': True
    },
    181: {
        'variants': ['single', 'multi', 'max'],
        'description': 'Set Parameters',
        'required': 'request_only'
    },
    203: {
        'variants': ['open', 'read_single', 'read_max', 'write_single', 'write_max', 'close', 'delete', 'read_dir_single', 'read_dir_max', 'read_dir_64_single', 'read_dir_64_max'],
        'description': 'General File Transfer - Commands: Open, Read (single/max), Write (single/max), Close, Delete, Read Directory (single/max/64)',
        'required': True
    },
    205: {
        'variants': ['single', 'multi', 'max'],
        'description': 'Peer-to-Peer Network Messages',
        'required': True
    },
    206: {
        'variants': ['list', 'read', 'list_single', 'list_max', 'read_single', 'read_max'],
        'description': 'Read Transaction History Data',
        'required': True
    },
    255: {
        'variants': ['single', 'max'],
        'description': 'Invalid Parameters',
        'required': 'response_only'
    }
}

def validate_variant(opcode, variant, is_response):
    """Validate variant for the given opcode and message type"""
    if opcode not in OPCODE_VARIANTS:
        return True  # No variants defined for this opcode

    config = OPCODE_VARIANTS[opcode]
    required = config['required']

    # Check if variant is required
    if variant is None:
        if required is True:
            # Always requires variant
            raise ValueError(f"Opcode {opcode} ({config['description']}) requires --variant ({' | '.join(config['variants'])})")
        elif required == 'response_only' and is_response:
            # Only requires variant for responses
            raise ValueError(f"Opcode {opcode} ({config['description']}) requires --variant ({' | '.join(config['variants'])})")
        elif required == 'request_only' and not is_response:
            # Only requires variant for requests
            raise ValueError(f"Opcode {opcode} ({config['description']}) requires --variant ({' | '.join(config['variants'])})")
        return True

    # Validate variant if provided
    if variant not in config['variants']:
        msg_type = "response" if is_response else "request"
        valid_variants = ', '.join(config['variants'])
        raise ValueError(f"Invalid variant '{variant}' for opcode {opcode} {msg_type}.\nSupported variants are: {valid_variants}\n\nFor opcode {opcode} ({config['description']})")

    return True

class ROCPlusPacketBuilder:
    def __init__(self, debug=False, src_ip=None, dst_ip=None, src_port=None, dst_port=None, protocol='tcp'):
        # Enable debug logging if requested
        if debug:
            logger.setLevel(logging.DEBUG)

        # Network configuration
        self.src_ip = src_ip or "192.168.1.100"
        self.dst_ip = dst_ip or "192.168.1.200"
        self.src_port = src_port or 32107
        self.dst_port = dst_port or 4000
        self.initial_seq = 100
        self.protocol = protocol.lower()

        # Hardcoded MAC addresses to avoid ARP lookup warnings
        self.src_mac = "00:11:22:33:44:55"
        self.dst_mac = "66:77:88:99:aa:bb"

        # ROC Plus Header configuration
        self.roc_unit = 1
        self.roc_group = 2
        self.host_unit = 3
        self.host_group = 4

        # Initialize the base timestamp (a fixed date for consistency)
        self.base_time = datetime(2023, 6, 15, 12, 0, 0)  # June 15, 2023 at noon
        self.current_timestamp = self.base_time.timestamp()

    def get_next_timestamp(self, increment=2.0):
        """Get the next timestamp and increment by the specified amount"""
        ts = self.current_timestamp
        self.current_timestamp += increment
        return ts

    def validate_ascii_field(self, value, length, field_name, fixed=True, min_length=None):
        """Validate an ASCII field length

        Args:
            value: The string value to validate
            length: For fixed=True, exact length required. For fixed=False, maximum length allowed.
            field_name: Name of the field for error messages
            fixed: If True, require exact length. If False, require length <= max_length
            min_length: Minimum length required (only used when fixed=False)
        """
        if fixed:
            if len(value) != length:
                raise ValueError(f"{field_name} must be exactly {length} ASCII characters (got {len(value)})")
        else:
            if min_length and len(value) < min_length:
                raise ValueError(f"{field_name} must be at least {min_length} ASCII characters (got {len(value)})")
            if len(value) > length:
                raise ValueError(f"{field_name} must be at most {length} ASCII characters (got {len(value)})")
        return value.encode('ascii').ljust(length)  # Always pad to full length

    def build_payload(self, opcode, is_response=False, variant=None):
        """Build the payload bytes for the given opcode"""
        if opcode not in OPCODE_PAYLOADS:
            raise ValueError(f"Opcode {opcode} is not supported")

        payload_def = OPCODE_PAYLOADS[opcode]

        # Handle variants for opcode 17 and 50
        if opcode == 17:
            if not variant:
                raise ValueError("Opcode 17 requires a variant type (--variant login_standard|login_enhanced|logout_standard|logout_enhanced|session)")
            if variant not in ["login_standard", "login_enhanced", "logout_standard", "logout_enhanced", "session"]:
                valid_variants = ["login_standard", "login_enhanced", "logout_standard", "logout_enhanced", "session"]
                raise ValueError(f"Invalid variant '{variant}' for opcode 17. Valid variants are: {', '.join(valid_variants)}")
            # No need to reassign payload_def here as opcode 17 is handled specially later
        elif opcode == 50 and is_response:
            if not variant:
                raise ValueError("Opcode 50 response requires a variant (--variant mode_1|mode_2|mode_3)")
            if variant not in payload_def["response"]:
                valid_variants = list(payload_def["response"].keys())
                raise ValueError(f"Invalid variant '{variant}' for opcode 50 response. Valid variants are: {', '.join(valid_variants)}")
        elif opcode == 166 and not is_response:
            if not variant:
                raise ValueError("Opcode 166 request requires a variant (--variant single|max)")
            if variant not in payload_def["request"]:
                valid_variants = list(payload_def["request"].keys())
                raise ValueError(f"Invalid variant '{variant}' for opcode 166 request. Valid variants are: {', '.join(valid_variants)}")

        msg_type = "response" if is_response else "request"
        if msg_type not in payload_def:
            raise ValueError(f"Opcode {opcode} does not support {'response' if is_response else 'request'} packets")

        # Get payload data based on whether this is a variant opcode or not
        needs_variant = False
        if opcode in OPCODE_VARIANTS:
            config = OPCODE_VARIANTS[opcode]
            if config['required'] is True:
                needs_variant = True
            elif config['required'] == 'response_only' and is_response:
                needs_variant = True
            elif config['required'] == 'request_only' and not is_response:
                needs_variant = True

        if needs_variant:
            if variant is None:
                raise ValueError(f"Opcode {opcode} requires a variant")

            # Check if the variant is valid
            if opcode == 17:  # Special case: variant is structured differently
                if variant not in payload_def[msg_type]:
                    valid_variants = list(payload_def[msg_type].keys())
                    raise ValueError(f"Invalid variant '{variant}' for opcode {opcode} {msg_type}. Valid variants are: {', '.join(valid_variants)}")
                payload_data = payload_def[msg_type][variant]["payload"]
            else:
                if variant not in payload_def[msg_type]:
                    if isinstance(payload_def[msg_type], dict):
                        valid_variants = list(payload_def[msg_type].keys())
                        raise ValueError(f"Invalid variant '{variant}' for opcode {opcode} {msg_type}. Valid variants are: {', '.join(valid_variants)}")
                    else:
                        # This opcode has a payload but doesn't use variants
                        raise ValueError(f"Opcode {opcode} {msg_type} does not support variants")
                payload_data = payload_def[msg_type][variant]["payload"]
        else:
            logger.debug(f"Getting standard payload data for opcode {opcode}")
            payload_data = payload_def[msg_type]["payload"]

        if not payload_data:  # Empty payload dict means no payload bytes
            return b''

        payload = b''

        if opcode == 6:  # System Configuration
            if not is_response:
                return b''  # Request has no payload

            payload += payload_data["system_mode"].to_bytes(1, byteorder='big')
            payload += payload_data["comm_port"].to_bytes(2, byteorder='big')
            payload += payload_data["security_mode"].to_bytes(1, byteorder='big')
            payload += payload_data["compatibility_status"].to_bytes(1, byteorder='big')
            payload += payload_data["revision"].to_bytes(1, byteorder='big')
            payload += payload_data["roc_subtype"].to_bytes(1, byteorder='big')
            payload += payload_data["reserved"].to_bytes(11, byteorder='big')
            payload += payload_data["roc_type"].to_bytes(1, byteorder='big')

            # Add logical points data (offsets 25-220)
            for point_count in payload_data["logical_points"]:
                payload += point_count.to_bytes(1, byteorder='big')

        elif opcode == 7:  # Read Real-time Clock
            if not is_response:
                return b''  # Request has no payload

            payload += payload_data["second"].to_bytes(1, byteorder='big')
            payload += payload_data["minute"].to_bytes(1, byteorder='big')
            payload += payload_data["hour"].to_bytes(1, byteorder='big')
            payload += payload_data["day"].to_bytes(1, byteorder='big')
            payload += payload_data["month"].to_bytes(1, byteorder='big')
            payload += payload_data["year"].to_bytes(2, byteorder='big')
            payload += payload_data["day_of_week"].to_bytes(1, byteorder='big')

        elif opcode == 8:  # Set Real-time Clock
            if is_response:
                return b''  # Response has no payload

            payload += payload_data["second"].to_bytes(1, byteorder='big')
            payload += payload_data["minute"].to_bytes(1, byteorder='big')
            payload += payload_data["hour"].to_bytes(1, byteorder='big')
            payload += payload_data["day"].to_bytes(1, byteorder='big')
            payload += payload_data["month"].to_bytes(1, byteorder='big')
            payload += payload_data["year"].to_bytes(2, byteorder='big')

        elif opcode == 10:  # Read Configurable Opcode Point Data
            # Both request and response share the same initial 3 bytes
            payload += payload_data["table_number"].to_bytes(1, byteorder='big')
            payload += payload_data["start_location"].to_bytes(1, byteorder='big')
            payload += payload_data["num_locations"].to_bytes(1, byteorder='big')

            if is_response:
                # Response includes version and data
                payload += payload_data["table_version"]  # Already in bytes
                payload += payload_data["data"]  # Already in bytes

        elif opcode == 11:  # Write Configurable Opcode Point Data
            if is_response:
                return b''  # Response has no payload

            # Request includes table info and data
            payload += payload_data["table_number"].to_bytes(1, byteorder='big')
            payload += payload_data["start_location"].to_bytes(1, byteorder='big')
            payload += payload_data["num_locations"].to_bytes(1, byteorder='big')
            payload += payload_data["data"]  # Already in bytes

        elif opcode == 17:  # Login/Logout Operations
            if variant in ('login_standard', 'logout_standard'):
                # Standard format uses fixed lengths
                payload += self.validate_ascii_field(payload_data["operator_id"], 3, "operator_id", fixed=True)  # AC3
                payload += payload_data["password"].to_bytes(2, byteorder='big')  # UINT16
                if 'access_level' in payload_data:
                    payload += payload_data["access_level"].to_bytes(1, byteorder='big')  # UINT8
                if 'logout_string' in payload_data:
                    payload += self.validate_ascii_field(payload_data["logout_string"], 6, "logout_string", fixed=True)  # AC6

            elif variant in ('login_enhanced', 'logout_enhanced'):
                # Enhanced format uses variable lengths up to max
                payload += self.validate_ascii_field(payload_data["operator_id"], 30, "operator_id", fixed=False, min_length=3)  # AC30
                payload += self.validate_ascii_field(payload_data["password"], 40, "password", fixed=False)  # AC40
                if 'access_level' in payload_data:
                    payload += payload_data["access_level"].to_bytes(1, byteorder='big')  # UINT8
                if 'logout_string' in payload_data:
                    payload += self.validate_ascii_field(payload_data["logout_string"], 6, "logout_string", fixed=True)  # AC6

            elif variant == 'session':
                if is_response:
                    payload += self.validate_ascii_field(payload_data["wrapped_key"], 24, "wrapped_key", fixed=True)  # AC24
                else:
                    payload += self.validate_ascii_field(payload_data["session_key"], 13, "session_key", fixed=True)  # AC13

        elif opcode == 24:  # Store and Forward
            if is_response:
                return b''  # No response payload

            # Add all the address and group fields
            payload += payload_data["host_address"].to_bytes(1, byteorder='big')
            payload += payload_data["host_group"].to_bytes(1, byteorder='big')
            payload += payload_data["dest1_address"].to_bytes(1, byteorder='big')
            payload += payload_data["dest1_group"].to_bytes(1, byteorder='big')
            payload += payload_data["dest2_address"].to_bytes(1, byteorder='big')
            payload += payload_data["dest2_group"].to_bytes(1, byteorder='big')
            payload += payload_data["dest3_address"].to_bytes(1, byteorder='big')
            payload += payload_data["dest3_group"].to_bytes(1, byteorder='big')
            payload += payload_data["dest4_address"].to_bytes(1, byteorder='big')
            payload += payload_data["dest4_group"].to_bytes(1, byteorder='big')
            payload += payload_data["desired_opcode"].to_bytes(1, byteorder='big')

            # Add variable data
            data = bytes(payload_data["data"])
            payload += len(data).to_bytes(1, byteorder='big')  # Data length
            payload += data  # Data bytes

        elif opcode == 50:  # Request I/O Point Position
            if not is_response:
                # Request has a single byte for I/O point type
                payload += payload_data["io_point_type"].to_bytes(1, byteorder='big')
            else:
                # Response depends on variant
                if not variant:
                    raise ValueError("Opcode 50 response requires a variant (--variant mode_1|mode_2|mode_3)")
                if variant not in payload_def["response"]:
                    raise ValueError(f"Unknown variant '{variant}' for opcode 50")

                # Get the data for the specified mode
                data = payload_def["response"][variant]["payload"]["data"]
                payload += bytes(data)  # Add all data bytes

        elif opcode == 100:  # Access User-defined Information
            if not is_response:
                # Request payload is simple
                payload += payload_data["command"].to_bytes(1, byteorder='big')
                payload += payload_data["start_point"].to_bytes(1, byteorder='big')
                payload += payload_data["num_points"].to_bytes(1, byteorder='big')
            else:
                # Response depends on variant
                if not variant:
                    raise ValueError("Opcode 100 response requires a variant (--variant single|max)")
                if variant not in payload_def["response"]:
                    raise ValueError(f"Unknown variant '{variant}' for opcode 100")

                # Get the data for the specified variant
                try:
                    variant_data = payload_def["response"][variant]["payload"]
                except KeyError as e:
                    logger.debug(f"DEBUG: KeyError accessing variant data: {e}")
                    logger.debug(f"DEBUG: payload_def structure: {payload_def}")
                    raise

                # Build response payload
                try:
                    payload += variant_data["command"].to_bytes(1, byteorder='big')
                    payload += variant_data["start_point"].to_bytes(1, byteorder='big')
                    payload += variant_data["num_points"].to_bytes(1, byteorder='big')

                    # Add point types array
                    for point_type in variant_data["point_types"]:
                        payload += point_type.to_bytes(1, byteorder='big')
                except Exception as e:
                    logger.debug(f"DEBUG: Error building response fields: {e}")
                    raise

        elif opcode == 105:  # Request Today's and Yesterday's Min/Max Values
            # Both request and response start with history segment and point number
            payload += payload_data["history_segment"].to_bytes(1, byteorder='big')
            payload += payload_data["point_number"].to_bytes(1, byteorder='big')

            if is_response:
                # Add all the additional response fields
                payload += payload_data["archival_method"].to_bytes(1, byteorder='big')
                payload += payload_data["point_type"].to_bytes(1, byteorder='big')
                payload += payload_data["point_logic_number"].to_bytes(1, byteorder='big')
                payload += payload_data["parameter_number"].to_bytes(1, byteorder='big')   # 6 bytes as of this point

                # Add float values (4 bytes each)
                payload += struct.pack('>f', payload_data["current_value"])                # 10 bytes as of this point
                payload += struct.pack('>f', payload_data["min_value_today"])              # 14 bytes as of this point
                payload += struct.pack('>f', payload_data["max_value_today"])              # 18 bytes as of this point

                # Add timestamps (UINT32 - 4 bytes each)
                payload += payload_data["min_time_today"].to_bytes(5, byteorder='big')     # 23 bytes as of this point
                payload += payload_data["max_time_today"].to_bytes(5, byteorder='big')     # 28 bytes as of this point

                # Add yesterday's values
                payload += struct.pack('>f', payload_data["min_value_yesterday"])          # 32 bytes as of this point
                payload += struct.pack('>f', payload_data["max_value_yesterday"])          # 36 bytes as of this point
                payload += payload_data["min_time_yesterday"].to_bytes(5, byteorder='big') # 41 bytes as of this point
                payload += payload_data["max_time_yesterday"].to_bytes(5, byteorder='big') # 46 bytes as of this point

                # Add last period value
                payload += struct.pack('>f', payload_data["last_period_value"])            # 50 bytes as of this point

        elif opcode == 108:  # Request History Tag and Periodic Index
            # Both request and response require variants
            if not variant:
                raise ValueError("Opcode 108 requires a variant (--variant single|max)")
            if variant not in payload_def[msg_type]:
                raise ValueError(f"Unknown variant '{variant}' for opcode 108")

            # Get variant-specific payload data
            variant_data = payload_def[msg_type][variant]["payload"]
            logger.debug(f"Opcode 108 variant data: {variant_data}")

            # Both request and response start with segment and num_points
            payload += variant_data["history_segment"].to_bytes(1, byteorder='big')
            payload += variant_data["num_points"].to_bytes(1, byteorder='big')
            logger.debug(f"Added segment ({variant_data['history_segment']}) and num_points (dec: {variant_data['num_points']}, hex: 0x{variant_data['num_points']:02x})")

            if not is_response:
                # Request includes array of points
                logger.debug(f"Building request with {len(variant_data['points'])} points (hex: 0x{len(variant_data['points']):02x})")
                for point in variant_data["points"]:
                    payload += point.to_bytes(1, byteorder='big')
            else:
                # Response includes periodic index and point data
                logger.debug(f"Building response with periodic_index {variant_data['periodic_index']} and {len(variant_data['points'])} points (hex: 0x{len(variant_data['points']):02x})")
                payload += variant_data["periodic_index"].to_bytes(2, byteorder='big')

                # Add each point
                for point in variant_data["points"]:
                    payload += point.to_bytes(1, byteorder='big')
                logger.debug(f"Added {len(variant_data['points'])} points")

                # Add the tag once after all points
                payload += self.validate_ascii_field(variant_data["tag"], 10, "tag", fixed=True)
                logger.debug(f"Added tag: {variant_data['tag']}, final payload length: {len(payload)}")
        elif opcode == 118:  # Request Alarm Data
            # Both request and response require variants
            if not variant:
                raise ValueError("Opcode 118 requires a variant (--variant empty|single|max)")
            if variant not in payload_def[msg_type]:
                raise ValueError(f"Unknown variant '{variant}' for opcode 118")

            # Get variant-specific payload data
            variant_data = payload_def[msg_type][variant]["payload"]

            # Both request and response start with num_alarms
            payload += variant_data["num_alarms"].to_bytes(1, byteorder='big')
            payload += variant_data["start_index"].to_bytes(2, byteorder='big')

            if is_response:
                # Response includes current index and alarm data
                payload += variant_data["current_index"].to_bytes(2, byteorder='big')

                # Add each alarm's data block (23 bytes each)
                for alarm_block in variant_data["alarm_data"]:
                    payload += bytes(alarm_block)
        elif opcode == 119:  # Request Event Data
            # Only response requires variants
            if is_response:
                if not variant:
                    raise ValueError("Opcode 119 response requires a variant (--variant empty|single|max)")
                if variant not in payload_def[msg_type]:
                    raise ValueError(f"Unknown variant '{variant}' for opcode 119")
                variant_data = payload_def[msg_type][variant]["payload"]
            else:
                variant_data = payload_def[msg_type]["payload"]

            # Both request and response start with num_events
            payload += variant_data["num_events"].to_bytes(1, byteorder='big')
            payload += variant_data["start_index"].to_bytes(2, byteorder='big')

            if is_response:
                # Response includes current index and event data
                payload += variant_data["current_index"].to_bytes(2, byteorder='big')

                # Add each event's data block (22 bytes each)
                for event_block in variant_data["event_data"]:
                    payload += bytes(event_block)
        elif opcode == 135:  # Request Single History Point Data
            # Only response requires variants
            if is_response:
                if not variant:
                    raise ValueError("Opcode 135 response requires a variant (--variant empty|single|max)")
                if variant not in payload_def[msg_type]:
                    raise ValueError(f"Unknown variant '{variant}' for opcode 135")
                variant_data = payload_def[msg_type][variant]["payload"]
            else:
                variant_data = payload_def[msg_type]["payload"]

            if not is_response:
                # Build request payload
                payload += variant_data["history_segment"].to_bytes(1, byteorder='big')
                payload += variant_data["point_number"].to_bytes(1, byteorder='big')
                payload += variant_data["history_type"].to_bytes(1, byteorder='big')
                payload += variant_data["start_index"].to_bytes(2, byteorder='big')
                payload += variant_data["num_values"].to_bytes(1, byteorder='big')
            else:
                # Build response payload
                payload += variant_data["history_segment"].to_bytes(1, byteorder='big')
                payload += variant_data["point_number"].to_bytes(1, byteorder='big')
                payload += variant_data["current_index"].to_bytes(2, byteorder='big')
                payload += variant_data["num_values"].to_bytes(1, byteorder='big')

                # Add each history value (4 bytes each)
                for value_block in variant_data["history_values"]:
                    payload += bytes(value_block)

        elif opcode == 136:  # Request Multiple History Point Data
            logger.debug("Building opcode 136 payload")

            if not is_response:
                # Build request payload
                logger.debug(f"History segment: {payload_data['history_segment']}")
                payload += payload_data["history_segment"].to_bytes(1, byteorder='big')
                logger.debug(f"Segment index: {payload_data['segment_index']}")
                payload += payload_data["segment_index"].to_bytes(2, byteorder='big')
                logger.debug(f"History type: {payload_data['history_type']}")
                payload += payload_data["history_type"].to_bytes(1, byteorder='big')
                logger.debug(f"Start point: {payload_data['start_point']}")
                payload += payload_data["start_point"].to_bytes(1, byteorder='big')
                logger.debug(f"Number of points: {payload_data['num_points']}")
                payload += payload_data["num_points"].to_bytes(1, byteorder='big')
                logger.debug(f"Number of periods: {payload_data['num_periods']}")
                payload += payload_data["num_periods"].to_bytes(1, byteorder='big')
            else:
                # Build response payload
                logger.debug(f"History segment: {payload_data['history_segment']}")
                payload += payload_data["history_segment"].to_bytes(1, byteorder='big')
                logger.debug(f"Segment index: {payload_data['segment_index']}")
                payload += payload_data["segment_index"].to_bytes(2, byteorder='big')
                logger.debug(f"Current index: {payload_data['current_index']}")
                payload += payload_data["current_index"].to_bytes(2, byteorder='big')
                logger.debug(f"Number of elements: {payload_data['num_elements']}")
                payload += payload_data["num_elements"].to_bytes(1, byteorder='big')

                # Add each time period with its values
                for period in payload_data["periods"]:
                    logger.debug(f"Adding period timestamp: {period['timestamp']}")
                    payload += period["timestamp"].to_bytes(4, byteorder='big')

                    # Add each value for this period
                    for value in period["values"]:
                        logger.debug(f"Adding value: {value.hex()}")
                        payload += value  # Value is already packed as float32

        elif opcode == 137:  # Request History Index for a Day
            if not is_response:
                # Build request payload
                payload += payload_data["history_segment"].to_bytes(1, byteorder='big')
                payload += payload_data["day"].to_bytes(1, byteorder='big')
                payload += payload_data["month"].to_bytes(1, byteorder='big')
            else:
                # Build response payload
                payload += payload_data["history_segment"].to_bytes(1, byteorder='big')
                payload += payload_data["periodic_index"].to_bytes(2, byteorder='big')
                payload += payload_data["periodic_entries"].to_bytes(2, byteorder='big')
                payload += payload_data["daily_index"].to_bytes(2, byteorder='big')
                payload += payload_data["daily_entries"].to_bytes(2, byteorder='big')

        elif opcode == 138:  # Request Daily and Periodic History for a Day
            # Only response requires variants
            if is_response:
                if not variant:
                    raise ValueError("Opcode 138 response requires a variant (--variant empty|single|max)")
                if variant not in payload_def[msg_type]:
                    raise ValueError(f"Unknown variant '{variant}' for opcode 138")
                variant_data = payload_def[msg_type][variant]["payload"]
            else:
                variant_data = payload_def[msg_type]["payload"]

            if not is_response:
                # Build request payload
                logger.debug("DEBUG 138: Building request payload")
                payload += variant_data["history_segment"].to_bytes(1, byteorder='big')
                payload += variant_data["point_number"].to_bytes(1, byteorder='big')
                payload += variant_data["day"].to_bytes(1, byteorder='big')
                payload += variant_data["month"].to_bytes(1, byteorder='big')
            else:
                # Build response payload
                logger.debug("DEBUG 138: Building response payload")
                logger.debug(f"DEBUG 138: history_segment = {variant_data['history_segment']}")
                payload += variant_data["history_segment"].to_bytes(1, byteorder='big')
                logger.debug(f"DEBUG 138: point_number = {variant_data['point_number']}")
                payload += variant_data["point_number"].to_bytes(1, byteorder='big')
                logger.debug(f"DEBUG 138: day = {variant_data['day']}")
                payload += variant_data["day"].to_bytes(1, byteorder='big')
                logger.debug(f"DEBUG 138: month = {variant_data['month']}")
                payload += variant_data["month"].to_bytes(1, byteorder='big')
                logger.debug(f"DEBUG 138: num_periodic = {variant_data['num_periodic']}")
                payload += variant_data["num_periodic"].to_bytes(2, byteorder='big')
                logger.debug(f"DEBUG 138: num_daily = {variant_data['num_daily']}")
                payload += variant_data["num_daily"].to_bytes(2, byteorder='big')

                # Add periodic values (4 bytes each)
                logger.debug("DEBUG 138: Adding periodic values")
                for i, value_block in enumerate(variant_data["periodic_values"]):
                    logger.debug(f"DEBUG 138: periodic value {i} = {value_block}")
                    payload += bytes(value_block)

                # Add daily values (4 bytes each)
                logger.debug("DEBUG 138: Adding daily values")
                for i, value_block in enumerate(variant_data["daily_values"]):
                    logger.debug(f"DEBUG 138: daily value {i} = {value_block}")
                    payload += bytes(value_block)

        elif opcode == 139:  # History Information Data
            # Add command and history segment for all variants
            payload += payload_data["command"].to_bytes(1, byteorder='big')
            payload += payload_data["history_segment"].to_bytes(1, byteorder='big')

            if variant.startswith("cmd0"):
                if is_response:
                    # Command 0 response includes number of points and point array
                    payload += payload_data["num_points"].to_bytes(1, byteorder='big')
                    for point in payload_data["points"]:
                        payload += point.to_bytes(1, byteorder='big')
            else:  # cmd1 variants
                if is_response:
                    # Command 1 response includes current index through point data
                    payload += payload_data["current_index"].to_bytes(2, byteorder='big')
                    payload += payload_data["num_periods"].to_bytes(1, byteorder='big')
                    payload += payload_data["req_timestamps"].to_bytes(1, byteorder='big')
                    payload += payload_data["num_points"].to_bytes(1, byteorder='big')
                    for i in range(0, payload_data["num_periods"]):
                        if( variant == "cmd1_max_with_timestamps"):
                            payload += payload_data["timestamp"][i].to_bytes(4, byteorder='big')
                        for point in payload_data["point_data"]:
                            for value_byte in point["value"]:
                                payload += value_byte.to_bytes(1, byteorder='big')
                else:
                    # Command 1 request includes segment index through points array
                    payload += payload_data["segment_index"].to_bytes(2, byteorder='big')
                    payload += payload_data["history_type"].to_bytes(1, byteorder='big')
                    payload += payload_data["num_periods"].to_bytes(1, byteorder='big')
                    payload += payload_data["req_timestamps"].to_bytes(1, byteorder='big')
                    payload += payload_data["num_points"].to_bytes(1, byteorder='big')
                    for point in payload_data["points"]:
                        payload += point.to_bytes(1, byteorder='big')

        elif opcode == 166:  # Set Single Point Parameters
            if is_response:
                return b''  # Response has no payload

            # Add fixed fields
            logger.debug("Building opcode 166 request payload")
            logger.debug(f"Point type: {payload_data['point_type']}")
            payload += payload_data["point_type"].to_bytes(1, byteorder='big')
            logger.debug(f"Point number: {payload_data['point_number']}")
            payload += payload_data["point_number"].to_bytes(1, byteorder='big')
            logger.debug(f"Number of parameters: {payload_data['num_parameters']}")
            payload += payload_data["num_parameters"].to_bytes(1, byteorder='big')
            logger.debug(f"Start parameter: {payload_data['start_param']}")
            payload += payload_data["start_param"].to_bytes(1, byteorder='big')

            # Add data block
            logger.debug(f"Data block length: {len(payload_data['data'])}")
            for value in payload_data["data"]:
                payload += value.to_bytes(1, byteorder='big')
            logger.debug(f"Final payload length: {len(payload)}")

        elif opcode == 167:  # Request Single Point Parameters
            # Add fixed fields
            logger.debug("Building opcode 167 payload")
            logger.debug(f"Point type: {payload_data['point_type']}")
            payload += payload_data["point_type"].to_bytes(1, byteorder='big')
            logger.debug(f"Point number: {payload_data['point_number']}")
            payload += payload_data["point_number"].to_bytes(1, byteorder='big')
            logger.debug(f"Number of parameters: {payload_data['num_parameters']}")
            payload += payload_data["num_parameters"].to_bytes(1, byteorder='big')
            logger.debug(f"Start parameter: {payload_data['start_param']}")
            payload += payload_data["start_param"].to_bytes(1, byteorder='big')

            # Add data block for responses only
            if is_response and "data" in payload_data:
                logger.debug(f"Data block length: {len(payload_data['data'])}")
                for value in payload_data["data"]:
                    payload += value.to_bytes(1, byteorder='big')
            logger.debug(f"Final payload length: {len(payload)}")

        elif opcode == 180:  # Request Parameters
            # Add number of parameters
            logger.debug("Building opcode 180 payload")
            logger.debug(f"Number of parameters: {payload_data['num_parameters']}")
            payload += payload_data["num_parameters"].to_bytes(1, byteorder='big')

            # Add parameter entries
            for param in payload_data["parameters"]:
                logger.debug(f"Adding parameter: {param}")
                payload += param["point_type"].to_bytes(1, byteorder='big')
                payload += param["point_number"].to_bytes(1, byteorder='big')
                payload += param["param_number"].to_bytes(1, byteorder='big')
                if is_response:
                    payload += param["param_data"].to_bytes(1, byteorder='big')
            logger.debug(f"Final payload length: {len(payload)}")

        elif opcode == 181:  # Set Parameters
            logger.debug(f"Building opcode 181 payload (is_response={is_response})")
            if is_response:
                logger.debug("Response packet - returning empty payload")
                return b''  # Response has no payload

            # Get payload data for request
            if not payload_data:
                logger.debug("No payload data found - returning empty payload")
                return b''

            # Add number of parameters
            logger.debug(f"Building request payload with data: {payload_data}")
            logger.debug(f"Number of parameters: {payload_data.get('num_parameters')}")
            payload += payload_data["num_parameters"].to_bytes(1, byteorder='big')

            # Add parameter entries with data
            for param in payload_data["parameters"]:
                logger.debug(f"Adding parameter: {param}")
                payload += param["point_type"].to_bytes(1, byteorder='big')
                payload += param["point_number"].to_bytes(1, byteorder='big')
                payload += param["param_number"].to_bytes(1, byteorder='big')
                payload += param["param_data"].to_bytes(1, byteorder='big')
            logger.debug(f"Final payload length: {len(payload)}")

        elif opcode == 203:  # General File Transfer
            logger.debug("Building opcode 203 payload")
            logger.debug(f"Command variant: {variant}")

            # Add command byte for all variants
            payload += payload_data["command"].to_bytes(1, byteorder='big')

            if variant == "open":
                if not is_response:
                    # Request: Add options, path, and filename
                    payload += payload_data["options"].to_bytes(1, byteorder='big')
                    payload += payload_data["path"].encode('ascii').ljust(100, b'\x00')  # 100-byte path
                    payload += payload_data["filename"].encode('ascii').ljust(25, b'\x00')  # 25-byte filename
                else:
                    # Response: Add file descriptor
                    payload += payload_data["file_descriptor"].to_bytes(4, byteorder='big')

            elif variant == "read_single" or variant == "read_max":
                # Add file descriptor for both request and response
                payload += payload_data["file_descriptor"].to_bytes(4, byteorder='big')

                if not is_response:
                    # Request: Add offset
                    payload += payload_data["offset"].to_bytes(4, byteorder='big')
                else:
                    # Response: Add file size, offset, num bytes, and data
                    payload += payload_data["file_size"].to_bytes(4, byteorder='big')
                    payload += payload_data["offset"].to_bytes(4, byteorder='big')
                    payload += payload_data["num_bytes"].to_bytes(1, byteorder='big')
                    payload += payload_data["data"]  # Already in bytes

            elif variant == "write_single" or variant == "write_max":
                # Add file descriptor for both request and response
                payload += payload_data["file_descriptor"].to_bytes(4, byteorder='big')

                if not is_response:
                    # Request: Add file size, offset, num bytes, and data
                    payload += payload_data["file_size"].to_bytes(4, byteorder='big')
                    payload += payload_data["offset"].to_bytes(4, byteorder='big')
                    payload += payload_data["num_bytes"].to_bytes(1, byteorder='big')
                    payload += payload_data["data"]  # Already in bytes
                else:
                    # Response: Add offset
                    payload += payload_data["offset"].to_bytes(4, byteorder='big')

            elif variant == "close":
                # Add file descriptor for request only
                if not is_response:
                    # Request: Add file descriptor
                    payload += payload_data["file_descriptor"].to_bytes(4, byteorder='big')
                # Response just has the command byte which was already added

            elif variant == "delete":
                if not is_response:
                    # Request: Add path and filename
                    payload += payload_data["path"].encode('ascii').ljust(100, b'\x00')  # 100-byte path
                    payload += payload_data["filename"].encode('ascii').ljust(25, b'\x00')  # 25-byte filename
                # Response has no additional fields

            elif variant in ("read_dir_single", "read_dir_max"):
                if not is_response:
                    # Request: Add path and total num files (1 byte for v3.05)
                    payload += payload_data["path"].encode('ascii').ljust(100, b'\x00')  # 100-byte path
                    payload += payload_data["total_num_files"].to_bytes(1, byteorder='big')  # 1 byte for v3.05
                else:
                    # Response: Add additional files flag, total files, and filenames
                    payload += payload_data["additional_files"].to_bytes(1, byteorder='big')
                    payload += payload_data["total_files"].to_bytes(1, byteorder='big')  # 1 byte for v3.05
                    # Add each filename (null-terminated)
                    for filename in payload_data["filenames"]:
                        payload += filename.encode('ascii') + b'\x00'
                    # Add final null terminator for the entire data section
                    payload += b'\x00'
            elif variant in ("read_dir_64_single", "read_dir_64_max"):
                if not is_response:
                    # Request: Add path and total num files (2 bytes for v3.10+)
                    payload += payload_data["path"].encode('ascii').ljust(100, b'\x00')  # 100-byte path
                    payload += payload_data["total_num_files"].to_bytes(2, byteorder='big')  # 2 bytes for v3.10+
                else:
                    # Response: Add additional files flag, total files, and filenames
                    payload += payload_data["additional_files"].to_bytes(1, byteorder='big')
                    payload += payload_data["total_files"].to_bytes(2, byteorder='big')  # 2 bytes for v3.10+
                    # Add each filename (null-terminated)
                    for filename in payload_data["filenames"]:
                        payload += filename.encode('ascii') + b'\x00'
                    # Add final null terminator for the entire data section
                    payload += b'\x00'

            logger.debug(f"Final payload length: {len(payload)}")

        elif opcode == 205:  # Peer-to-Peer Network Messages
            logger.debug("Building opcode 205 payload")

            # Add fixed fields
            logger.debug(f"Network ID: {payload_data['network_id']}")
            payload += payload_data["network_id"].to_bytes(1, byteorder='big')

            # Commissioned Index is 4 bytes in response, 1 byte in request
            logger.debug(f"Commissioned Index: {payload_data['commissioned_index']}")
            if is_response:
                payload += payload_data["commissioned_index"].to_bytes(4, byteorder='big')
            else:
                payload += payload_data["commissioned_index"].to_bytes(1, byteorder='big')

            logger.debug(f"Embedded Opcode: {payload_data['embedded_opcode']}")
            payload += payload_data["embedded_opcode"].to_bytes(1, byteorder='big')

            # Add embedded data length and data
            embedded_data = payload_data["embedded_data"]
            logger.debug(f"Embedded Data Length: {len(embedded_data)}")
            payload += len(embedded_data).to_bytes(1, byteorder='big')  # Length byte is part of the protocol
            logger.debug(f"Embedded Data: {embedded_data.hex()}")
            payload += embedded_data

            logger.debug(f"Final payload length: {len(payload)}")

        elif opcode == 206:  # Read Transaction History Data
            logger.debug("Building opcode 206 payload")

            # Add command byte
            logger.debug(f"Command: {payload_data['command']}")
            payload += payload_data["command"].to_bytes(1, byteorder='big')

            if payload_data["command"] == 1:  # List Transaction
                if not is_response:
                    # Build List Transaction request
                    logger.debug(f"Segment: {payload_data['segment']}")
                    payload += payload_data["segment"].to_bytes(1, byteorder='big')
                    logger.debug(f"Transaction offset: {payload_data['transaction_offset']}")
                    payload += payload_data["transaction_offset"].to_bytes(2, byteorder='big')
                else:
                    # Build List Transaction response
                    logger.debug(f"Number of transactions: {payload_data['num_transactions']}")
                    payload += payload_data["num_transactions"].to_bytes(1, byteorder='big')
                    logger.debug(f"More transactions: {payload_data['more_transactions']}")
                    payload += payload_data["more_transactions"].to_bytes(1, byteorder='big')
                    logger.debug(f"Description: {payload_data['description']}")
                    payload += payload_data["description"].ljust(10, b'\x00')  # 10-byte description
                    logger.debug(f"Payload size: {payload_data['payload_size']}")
                    payload += payload_data["payload_size"].to_bytes(2, byteorder='big')

                    # Add transaction entries
                    for txn in payload_data["transactions"]:
                        logger.debug(f"Adding transaction: {txn}")
                        payload += txn["number"].to_bytes(2, byteorder='big')
                        payload += txn["date_created"].to_bytes(4, byteorder='big')

            else:  # Read Transaction (command 2)
                if not is_response:
                    # Build Read Transaction request
                    logger.debug(f"Segment: {payload_data['segment']}")
                    payload += payload_data["segment"].to_bytes(1, byteorder='big')
                    payload += payload_data["transaction_number"].to_bytes(2, byteorder='big')
                    payload += payload_data["data_offset"].to_bytes(2, byteorder='big')
                else:
                    # Build Read Transaction response
                    from payloads.opcode_206 import DATA_TYPES

                    # Add message data size and more data flag
                    payload += payload_data["message_data_size"].to_bytes(1, byteorder='big')
                    payload += payload_data["more_data"].to_bytes(1, byteorder='big')

                    # Add each data point
                    for point in payload_data["data_points"]:
                        data_type = DATA_TYPES[point["type"]]
                        # Add data type code
                        payload += data_type["code"].to_bytes(1, byteorder='big')

                        # Add value based on type
                        if point["type"] in ["U8", "S8", "BINARY"]:
                            payload += point["value"].to_bytes(1, byteorder='big')
                        elif point["type"] in ["U16", "S16"]:
                            payload += point["value"].to_bytes(2, byteorder='big')
                        elif point["type"] in ["U32", "S32", "TIME"]:
                            payload += point["value"].to_bytes(4, byteorder='big')
                        elif point["type"] == "FLOAT":
                            payload += struct.pack('>f', point["value"])
                        elif point["type"] == "DOUBLE":
                            payload += struct.pack('>d', point["value"])
                        elif point["type"].startswith("STRING"):
                            size = data_type["size"]  # Get exact size from DATA_TYPES
                            # Encode and truncate/pad to exact size
                            encoded = point["value"].encode('ascii')[:size]
                            payload += encoded.ljust(size, b'\x00')
                        elif point["type"] == "TLP":
                            payload += point["value"].to_bytes(3, byteorder='big')

        elif opcode == 224:  # SRBX Signal
            logger.debug("Building opcode 224 payload")

            if not is_response:
                # Request is just raw data bytes (implementation dependent)
                # Format the raw data bytes individually to make debugging clearer
                raw_data = payload_data["raw_data"]
                byte_values = ', '.join([f'0x{b:02x}' for b in raw_data])
                logger.debug(f"Raw data bytes: [{byte_values}]")
                logger.debug(f"Raw data hex: {raw_data.hex()}")
                payload += raw_data
            else:
                # Response has no payload
                logger.debug("Response packet - empty payload")
                return b''

        elif opcode == 225:  # Acknowledge SRBX
            logger.debug("Building opcode 225 payload")

            if not is_response:
                # Build request payload - 2 byte current alarm index
                logger.debug(f"Current alarm index: {payload_data['current_alarm_index']}")
                payload += payload_data["current_alarm_index"].to_bytes(2, byteorder='big')
            else:
                # Response has no payload
                logger.debug("Response packet - empty payload")
                return b''

        elif opcode == 255:  # Invalid Parameters
            logger.debug("Building opcode 255 payload")

            if not is_response:
                # Request is just raw data bytes
                logger.debug(f"Raw data: {payload_data['raw_data'].hex()}")
                payload += payload_data["raw_data"]
            else:
                # Response contains error code/offset pairs
                for error in payload_data["errors"]:
                    logger.debug(f"Adding error: code={error['error_code']}, offset={error['offset']}")
                    payload += error["error_code"].to_bytes(1, byteorder='big')
                    payload += error["offset"].to_bytes(1, byteorder='big')

        return payload

    def build_header(self, opcode, payload):
        """Build the ROC Plus header bytes"""
        logger.debug(f"Building header - payload length = {len(payload)}")
        header = b''
        header += self.roc_unit.to_bytes(1, byteorder='big')
        header += self.roc_group.to_bytes(1, byteorder='big')
        header += self.host_unit.to_bytes(1, byteorder='big')
        header += self.host_group.to_bytes(1, byteorder='big')
        header += opcode.to_bytes(1, byteorder='big')

        # Standard length calculation - ensure we handle lengths > 255
        length = len(payload)
        if length > 255:
            logger.debug(f"Large payload detected ({length} bytes), truncating to 255")
            length = 255
        header += length.to_bytes(1, byteorder='big')  # Length is always 1 byte

        logger.debug(f"Header built successfully: {header.hex()}")
        return header

    def calculate_crc(self, message):
        """Calculate CRC for the message"""
        logger.debug(f"Calculating CRC for message of length {len(message)}")
        crc16 = crcmod.mkCrcFun(0x18005, rev=True, initCrc=0xFFFF, xorOut=0x0000)
        crc = crc16(message)
        logger.debug(f"CRC calculated: {crc:04x}")
        return crc.to_bytes(2, byteorder='little')

    def create_packet(self, message_bytes, is_response=False):
        """Create a single packet (TCP or UDP)"""
        logger.debug(f"Creating {self.protocol.upper()} packet with {len(message_bytes)} bytes")

        if self.protocol == 'tcp':
            return self._create_tcp_packet(message_bytes, is_response)
        else:  # UDP
            return self._create_udp_packet(message_bytes, is_response)

    def _create_tcp_packet(self, message_bytes, is_response=False):
        """Create a single TCP packet with explicit Ethernet header"""
        if is_response:
            # Response packet (from dst to src)
            packet = Ether(src=self.dst_mac, dst=self.src_mac) / IP(src=self.dst_ip, dst=self.src_ip) / TCP(
                sport=self.dst_port,
                dport=self.src_port,
                seq=self.initial_seq,
                flags="PA"
            ) / message_bytes
        else:
            # Request packet (from src to dst)
            packet = Ether(src=self.src_mac, dst=self.dst_mac) / IP(src=self.src_ip, dst=self.dst_ip) / TCP(
                sport=self.src_port,
                dport=self.dst_port,
                seq=self.initial_seq,
                flags="PA"
            ) / message_bytes

        return packet

    def _create_udp_packet(self, message_bytes, is_response=False):
        """Create a single UDP packet with explicit Ethernet header"""
        if is_response:
            # Response packet (from dst to src)
            packet = Ether(src=self.dst_mac, dst=self.src_mac) / IP(src=self.dst_ip, dst=self.src_ip) / UDP(
                sport=self.dst_port,
                dport=self.src_port
            ) / message_bytes
        else:
            # Request packet (from src to dst)
            packet = Ether(src=self.src_mac, dst=self.dst_mac) / IP(src=self.src_ip, dst=self.dst_ip) / UDP(
                sport=self.src_port,
                dport=self.dst_port
            ) / message_bytes

        # Explicitly calculate and set length fields to avoid Wireshark warnings
        # This forces Scapy to recalculate all length fields properly
        if hasattr(packet, 'len'):
            del packet.len  # Remove any existing len field so Scapy recalculates it

        return packet

    def build_pcap(self, opcode, output_file, is_response=False, variant=None):
        """Build and save the PCAP file"""
        try:
            # Build payload first
            payload = self.build_payload(opcode, is_response, variant)

            # Validate payload size before proceeding
            if len(payload) > 255:
                raise ValueError(f"Payload size ({len(payload)} bytes) exceeds maximum allowed size of 255 bytes. Please reduce the amount of data being sent.")

            # Build header with calculated length
            header = self.build_header(opcode, payload)

            # Combine message and add CRC
            try:
                logger.debug(f"Building message with header: {header.hex()} and payload: {payload.hex()}")
                message = header + payload
                logger.debug(f"Message built successfully: {message.hex()}")
                message_with_crc = message + self.calculate_crc(message)
            except Exception as e:
                logger.error(f"Error building message: {str(e)}")
                raise

            # Create and save packet
            packet = self.create_packet(message_with_crc, is_response)
            wrpcap(output_file, [packet])
            logger.info(f"Successfully created {self.protocol.upper()} PCAP file: {output_file}")

        except ValueError as e:
            logger.error(f"Invalid input or configuration: {str(e)}")
            raise
        except TypeError as e:
            logger.error(f"Data type error while building packet: {str(e)}")
            raise
        except Exception as e:
            logger.error(f"Unexpected error while creating PCAP: {str(e)}")
            raise

    def build_comprehensive_pcap(self, output_file):
        """Build a single PCAP with all opcode types in sequence with proper TCP/UDP flow"""
        packets = []

        if self.protocol == 'tcp':
            # TCP requires handshake, sequence numbers, etc.
            return self._build_comprehensive_tcp_pcap(output_file)
        else:
            # UDP is connectionless - simpler implementation
            return self._build_comprehensive_udp_pcap(output_file)

    def _build_comprehensive_tcp_pcap(self, output_file):
        """Build a comprehensive PCAP with all opcodes using TCP"""
        packets = []

        # Initialize TCP sequence counters
        seq_client = 100
        seq_server = 101

        # Reset timestamp to the base
        self.current_timestamp = self.base_time.timestamp()

        # Start with TCP 3-way handshake
        # SYN
        syn = Ether(src=self.src_mac, dst=self.dst_mac) / IP(src=self.src_ip, dst=self.dst_ip) / TCP(
            sport=self.src_port,
            dport=self.dst_port,
            flags="S",
            seq=seq_client
        )
        syn.time = self.get_next_timestamp(0.1)  # Small increment for handshake packets
        packets.append(syn)
        seq_client += 1

        # SYN-ACK
        syn_ack = Ether(src=self.dst_mac, dst=self.src_mac) / IP(src=self.dst_ip, dst=self.src_ip) / TCP(
            sport=self.dst_port,
            dport=self.src_port,
            flags="SA",
            seq=seq_server,
            ack=seq_client
        )
        syn_ack.time = self.get_next_timestamp(0.1)
        packets.append(syn_ack)
        seq_server += 1

        # ACK
        ack = Ether(src=self.src_mac, dst=self.dst_mac) / IP(src=self.src_ip, dst=self.dst_ip) / TCP(
            sport=self.src_port,
            dport=self.dst_port,
            flags="A",
            seq=seq_client,
            ack=seq_server
        )
        ack.time = self.get_next_timestamp(0.5)  # Slightly larger gap before data packets start
        packets.append(ack)

        # Build packets for each opcode
        for opcode in sorted(OPCODE_PAYLOADS.keys()):
            opcode_info = OPCODE_PAYLOADS[opcode]

            # Add a request if supported
            if "request" in opcode_info:
                try:
                    # Handle variants for request
                    if opcode in OPCODE_VARIANTS and isinstance(opcode_info["request"], dict):
                        for variant in OPCODE_VARIANTS[opcode]["variants"]:
                            if variant in opcode_info["request"]:
                                try:
                                    # Build request payload
                                    payload = self.build_payload(opcode, False, variant)
                                    header = self.build_header(opcode, payload)
                                    message = header + payload
                                    message_with_crc = message + self.calculate_crc(message)

                                    # Create packet with proper sequence numbers
                                    request_packet = Ether(src=self.src_mac, dst=self.dst_mac) / IP(src=self.src_ip, dst=self.dst_ip) / TCP(
                                        sport=self.src_port,
                                        dport=self.dst_port,
                                        flags="PA",
                                        seq=seq_client,
                                        ack=seq_server
                                    ) / message_with_crc
                                    request_packet.time = self.get_next_timestamp(2.0)  # 2.0 seconds between packets

                                    packets.append(request_packet)
                                    seq_client += len(message_with_crc)

                                    # ACK from server
                                    ack_packet = Ether(src=self.dst_mac, dst=self.src_mac) / IP(src=self.dst_ip, dst=self.src_ip) / TCP(
                                        sport=self.dst_port,
                                        dport=self.src_port,
                                        flags="A",
                                        seq=seq_server,
                                        ack=seq_client
                                    )
                                    ack_packet.time = self.get_next_timestamp(0.1)  # Minimal increment for ACK
                                    packets.append(ack_packet)
                                except Exception as e:
                                    logger.warning(f"Skipping request variant {variant} for opcode {opcode}: {str(e)}")
                    else:
                        # Standard request without variants
                        try:
                            payload = self.build_payload(opcode, False)
                            header = self.build_header(opcode, payload)
                            message = header + payload
                            message_with_crc = message + self.calculate_crc(message)

                            request_packet = Ether(src=self.src_mac, dst=self.dst_mac) / IP(src=self.src_ip, dst=self.dst_ip) / TCP(
                                sport=self.src_port,
                                dport=self.dst_port,
                                flags="PA",
                                seq=seq_client,
                                ack=seq_server
                            ) / message_with_crc
                            request_packet.time = self.get_next_timestamp(2.0)

                            packets.append(request_packet)
                            seq_client += len(message_with_crc)

                            # ACK from server
                            ack_packet = Ether(src=self.dst_mac, dst=self.src_mac) / IP(src=self.dst_ip, dst=self.src_ip) / TCP(
                                sport=self.dst_port,
                                dport=self.src_port,
                                flags="A",
                                seq=seq_server,
                                ack=seq_client
                            )
                            ack_packet.time = self.get_next_timestamp(0.1)
                            packets.append(ack_packet)
                        except Exception as e:
                            logger.warning(f"Skipping standard request for opcode {opcode}: {str(e)}")
                except Exception as e:
                    logger.warning(f"Skipping request for opcode {opcode}: {str(e)}")

            # Add a response if supported
            if "response" in opcode_info:
                try:
                    # Handle variants for response
                    if opcode in OPCODE_VARIANTS and isinstance(opcode_info["response"], dict):
                        for variant in OPCODE_VARIANTS[opcode]["variants"]:
                            if variant in opcode_info["response"]:
                                try:
                                    # Build response payload
                                    payload = self.build_payload(opcode, True, variant)
                                    header = self.build_header(opcode, payload)
                                    message = header + payload
                                    message_with_crc = message + self.calculate_crc(message)

                                    # Create packet with proper sequence numbers
                                    response_packet = Ether(src=self.dst_mac, dst=self.src_mac) / IP(src=self.dst_ip, dst=self.src_ip) / TCP(
                                        sport=self.dst_port,
                                        dport=self.src_port,
                                        flags="PA",
                                        seq=seq_server,
                                        ack=seq_client
                                    ) / message_with_crc
                                    response_packet.time = self.get_next_timestamp(2.0)

                                    packets.append(response_packet)
                                    seq_server += len(message_with_crc)

                                    # ACK from client
                                    ack_packet = Ether(src=self.src_mac, dst=self.dst_mac) / IP(src=self.src_ip, dst=self.dst_ip) / TCP(
                                        sport=self.src_port,
                                        dport=self.dst_port,
                                        flags="A",
                                        seq=seq_client,
                                        ack=seq_server
                                    )
                                    ack_packet.time = self.get_next_timestamp(0.1)
                                    packets.append(ack_packet)
                                except Exception as e:
                                    logger.warning(f"Skipping response variant {variant} for opcode {opcode}: {str(e)}")
                    else:
                        # Standard response without variants
                        try:
                            payload = self.build_payload(opcode, True)
                            header = self.build_header(opcode, payload)
                            message = header + payload
                            message_with_crc = message + self.calculate_crc(message)

                            response_packet = Ether(src=self.dst_mac, dst=self.src_mac) / IP(src=self.dst_ip, dst=self.src_ip) / TCP(
                                sport=self.dst_port,
                                dport=self.src_port,
                                flags="PA",
                                seq=seq_server,
                                ack=seq_client
                            ) / message_with_crc
                            response_packet.time = self.get_next_timestamp(2.0)

                            packets.append(response_packet)
                            seq_server += len(message_with_crc)

                            # ACK from client
                            ack_packet = Ether(src=self.src_mac, dst=self.dst_mac) / IP(src=self.src_ip, dst=self.dst_ip) / TCP(
                                sport=self.src_port,
                                dport=self.dst_port,
                                flags="A",
                                seq=seq_client,
                                ack=seq_server
                            )
                            ack_packet.time = self.get_next_timestamp(0.1)
                            packets.append(ack_packet)
                        except Exception as e:
                            logger.warning(f"Skipping standard response for opcode {opcode}: {str(e)}")
                except Exception as e:
                    logger.warning(f"Skipping response for opcode {opcode}: {str(e)}")

        # End with TCP teardown
        # FIN from client
        fin = Ether(src=self.src_mac, dst=self.dst_mac) / IP(src=self.src_ip, dst=self.dst_ip) / TCP(
            sport=self.src_port,
            dport=self.dst_port,
            flags="FA",
            seq=seq_client,
            ack=seq_server
        )
        fin.time = self.get_next_timestamp(0.1)
        packets.append(fin)
        seq_client += 1

        # FIN-ACK from server
        fin_ack = Ether(src=self.dst_mac, dst=self.src_mac) / IP(src=self.dst_ip, dst=self.src_ip) / TCP(
            sport=self.dst_port,
            dport=self.src_port,
            flags="FA",
            seq=seq_server,
            ack=seq_client
        )
        fin_ack.time = self.get_next_timestamp(0.1)
        packets.append(fin_ack)
        seq_server += 1

        # ACK from client
        last_ack = Ether(src=self.src_mac, dst=self.dst_mac) / IP(src=self.src_ip, dst=self.dst_ip) / TCP(
            sport=self.src_port,
            dport=self.dst_port,
            flags="A",
            seq=seq_client,
            ack=seq_server
        )
        last_ack.time = self.get_next_timestamp(0.1)
        packets.append(last_ack)

        # Write all packets to the output file
        wrpcap(output_file, packets)
        logger.info(f"Successfully created comprehensive TCP PCAP with {len(packets)} packets: {output_file}")
        return len(packets)

    def _build_comprehensive_udp_pcap(self, output_file):
        """Build a comprehensive PCAP with all opcodes using UDP"""
        packets = []

        # Reset timestamp to the base
        self.current_timestamp = self.base_time.timestamp()

        # Build packets for each opcode
        for opcode in sorted(OPCODE_PAYLOADS.keys()):
            opcode_info = OPCODE_PAYLOADS[opcode]

            # Add a request if supported
            if "request" in opcode_info:
                try:
                    # Handle variants for request
                    if opcode in OPCODE_VARIANTS and isinstance(opcode_info["request"], dict):
                        for variant in OPCODE_VARIANTS[opcode]["variants"]:
                            if variant in opcode_info["request"]:
                                try:
                                    # Build request payload
                                    payload = self.build_payload(opcode, False, variant)
                                    header = self.build_header(opcode, payload)
                                    message = header + payload
                                    message_with_crc = message + self.calculate_crc(message)

                                    # Create UDP packet
                                    request_packet = Ether(src=self.src_mac, dst=self.dst_mac) / IP(src=self.src_ip, dst=self.dst_ip) / UDP(
                                        sport=self.src_port,
                                        dport=self.dst_port
                                    ) / message_with_crc

                                    # Explicitly recalculate length fields
                                    if hasattr(request_packet, 'len'):
                                        del request_packet.len

                                    request_packet.time = self.get_next_timestamp(2.0)

                                    packets.append(request_packet)

                                except Exception as e:
                                    logger.warning(f"Skipping request variant {variant} for opcode {opcode}: {str(e)}")
                    else:
                        # Standard request without variants
                        try:
                            payload = self.build_payload(opcode, False)
                            header = self.build_header(opcode, payload)
                            message = header + payload
                            message_with_crc = message + self.calculate_crc(message)

                            request_packet = Ether(src=self.src_mac, dst=self.dst_mac) / IP(src=self.src_ip, dst=self.dst_ip) / UDP(
                                sport=self.src_port,
                                dport=self.dst_port
                            ) / message_with_crc

                            # Explicitly recalculate length fields
                            if hasattr(request_packet, 'len'):
                                del request_packet.len

                            request_packet.time = self.get_next_timestamp(2.0)

                            packets.append(request_packet)

                        except Exception as e:
                            logger.warning(f"Skipping standard request for opcode {opcode}: {str(e)}")
                except Exception as e:
                    logger.warning(f"Skipping request for opcode {opcode}: {str(e)}")

            # Add a response if supported
            if "response" in opcode_info:
                try:
                    # Handle variants for response
                    if opcode in OPCODE_VARIANTS and isinstance(opcode_info["response"], dict):
                        for variant in OPCODE_VARIANTS[opcode]["variants"]:
                            if variant in opcode_info["response"]:
                                try:
                                    # Build response payload
                                    payload = self.build_payload(opcode, True, variant)
                                    header = self.build_header(opcode, payload)
                                    message = header + payload
                                    message_with_crc = message + self.calculate_crc(message)

                                    # Create UDP packet
                                    response_packet = Ether(src=self.dst_mac, dst=self.src_mac) / IP(src=self.dst_ip, dst=self.src_ip) / UDP(
                                        sport=self.dst_port,
                                        dport=self.src_port
                                    ) / message_with_crc

                                    # Explicitly recalculate length fields
                                    if hasattr(response_packet, 'len'):
                                        del response_packet.len

                                    response_packet.time = self.get_next_timestamp(2.0)

                                    packets.append(response_packet)

                                except Exception as e:
                                    logger.warning(f"Skipping response variant {variant} for opcode {opcode}: {str(e)}")
                    else:
                        # Standard response without variants
                        try:
                            payload = self.build_payload(opcode, True)
                            header = self.build_header(opcode, payload)
                            message = header + payload
                            message_with_crc = message + self.calculate_crc(message)

                            response_packet = Ether(src=self.dst_mac, dst=self.src_mac) / IP(src=self.dst_ip, dst=self.src_ip) / UDP(
                                sport=self.dst_port,
                                dport=self.src_port
                            ) / message_with_crc

                            # Explicitly recalculate length fields
                            if hasattr(response_packet, 'len'):
                                del response_packet.len

                            response_packet.time = self.get_next_timestamp(2.0)

                            packets.append(response_packet)

                        except Exception as e:
                            logger.warning(f"Skipping standard response for opcode {opcode}: {str(e)}")
                except Exception as e:
                    logger.warning(f"Skipping response for opcode {opcode}: {str(e)}")

        # Write all packets to the output file
        wrpcap(output_file, packets)
        logger.info(f"Successfully created comprehensive UDP PCAP with {len(packets)} packets: {output_file}")
        return len(packets)

def main():
    parser = argparse.ArgumentParser(description="Build ROC Plus PCAP files")
    parser.add_argument('--opcode', type=int, help='ROC Plus opcode to use')
    parser.add_argument('--output', type=str, help='Output PCAP filename')
    parser.add_argument('--req', action='store_true', help='Generate request packet')
    parser.add_argument('--res', action='store_true', help='Generate response packet')
    parser.add_argument('--variant', type=str, help='Variant type for specific opcodes')
    parser.add_argument('--debug', action='store_true', help='Enable debug logging')
    parser.add_argument('--src-ip', type=str, help='Source IP address (default: 192.168.1.100)')
    parser.add_argument('--dst-ip', type=str, help='Destination IP address (default: 192.168.1.200)')
    parser.add_argument('--src-port', type=int, help='Source port (default: 32107)')
    parser.add_argument('--dst-port', type=int, help='Destination port (default: 4000)')
    parser.add_argument('--comprehensive', '--all', action='store_true', help='Generate a comprehensive PCAP with all opcodes')
    parser.add_argument('--protocol', choices=['tcp', 'udp'], default='tcp', help='Protocol to use (default: tcp)')
    args = parser.parse_args()

    # Configure debug logging if requested
    if args.debug:
        logger.setLevel(logging.DEBUG)

    # Create builder with network params directly passed to constructor
    builder = ROCPlusPacketBuilder(
        debug=args.debug,
        src_ip=args.src_ip,
        dst_ip=args.dst_ip,
        src_port=args.src_port,
        dst_port=args.dst_port,
        protocol=args.protocol
    )

    # Handle comprehensive mode
    if args.comprehensive:
        # Create output directory if it doesn't exist (for default output path)
        default_dir = '../traces'
        if args.output:
            output_dir = os.path.dirname(args.output)
        else:
            output_dir = default_dir

        if output_dir and not os.path.exists(output_dir):
            os.makedirs(output_dir)
            logger.info(f"Created output directory: {output_dir}")

        protocol_suffix = args.protocol
        output_file = args.output or f"{output_dir}/all_opcodes_{protocol_suffix}.pcap"

        try:
            logger.info(f"Generating comprehensive ROCplus {args.protocol.upper()} PCAP with all opcodes...")
            logger.info(f"Output file: {output_file}")
            packet_count = builder.build_comprehensive_pcap(output_file)
            logger.info(f"Successfully generated PCAP with {packet_count} packets")
            logger.info(f"PCAP file created: {output_file}")
            sys.exit(0)
        except Exception as e:
            logger.error(f"Error creating comprehensive PCAP: {str(e)}")
            sys.exit(1)

    # Check for required args in single opcode mode
    if not args.opcode:
        parser.error('Must specify --opcode when not in comprehensive mode')

    if not args.req and not args.res:
        parser.error('Must specify either --req or --res')

    if args.req and args.res:
        parser.error('Cannot specify both --req and --res')

    try:
        # Check if opcode is valid
        if args.opcode not in OPCODE_PAYLOADS:
            logger.error(f"Error: Invalid opcode {args.opcode}")
            logger.info("\nValid opcodes:")
            for opcode in sorted(OPCODE_PAYLOADS.keys()):
                desc = OPCODE_VARIANTS[opcode]['description'] if opcode in OPCODE_VARIANTS else ''
                logger.info(f"  {opcode:3d}: {desc}")
            sys.exit(1)

        # Validate variant
        try:
            validate_variant(args.opcode, args.variant, args.res)
        except ValueError as e:
            if "requires --variant" in str(e) or "Invalid variant" in str(e):
                logger.error("Variant Error: " + str(e))
                if args.opcode in OPCODE_VARIANTS:
                    config = OPCODE_VARIANTS[args.opcode]
                    logger.info(f"\nFor opcode {args.opcode} ({config['description']}):")
                    if config['required'] == 'response_only':
                        logger.info("  Request: No variants required")
                        logger.info("  Response variants:")
                    elif config['required'] == 'request_only':
                        logger.info("  Request variants:")
                        logger.info("  Response: No variants required")
                    else:
                        logger.info("  Available variants:")
                    for variant in config['variants']:
                        logger.info(f"    - {variant}")
                sys.exit(1)
            raise

        # Generate default filename if none provided
        msg_type = "response" if args.res else "request"
        variant_suffix = f"_{args.variant}" if args.variant else ""
        protocol_suffix = args.protocol
        output_file = args.output or f"rocplus_opcode_{args.opcode:03d}{variant_suffix}_{msg_type}_{protocol_suffix}_{datetime.now().strftime('%Y%m%d_%H%M%S')}.pcap"

        builder.build_pcap(args.opcode, output_file, is_response=args.res, variant=args.variant)
    except ValueError as e:
        # Specifically catch and format ValueError which is used for validation errors
        error_msg = str(e)
        if "variant" in error_msg.lower() or "invalid" in error_msg.lower():
            logger.error(f"Variant Error: {error_msg}")

            # If we have information about valid variants, show them
            if args.opcode in OPCODE_VARIANTS:
                config = OPCODE_VARIANTS[args.opcode]
                logger.info(f"\nFor opcode {args.opcode} ({config['description']}):")
                if "variants" in config:
                    logger.info("Valid variants are:")
                    for variant in config['variants']:
                        logger.info(f"  - {variant}")
        else:
            logger.error(f"Validation Error: {error_msg}")
        sys.exit(1)
    except Exception as e:
        logger.error(f"Error: {str(e)}")
        if args.debug:
            import traceback
            logger.debug("Stack trace:")
            logger.debug(traceback.format_exc())
        sys.exit(1)

if __name__ == "__main__":
    main()