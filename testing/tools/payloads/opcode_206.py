"""
Opcode 206: Read Transaction History Data

Commands:
1. List Transaction (Command 1)
   - Lists transactions currently stored in system
2. Read Transaction (Command 2)
   - Reads data for specified transaction

List Transaction Request format:
- Command (1) [UINT8]
- Segment [UINT8]
- Transaction offset [UINT16]

List Transaction Response format:
- Command (1) [UINT8]
- Number of transactions [UINT8]
- More transactions flag [UINT8]
- Description [10 bytes]
- Payload Size [UINT16]
- For each transaction:
  - Transaction number [UINT16]
  - Date created [UINT32]

Read Transaction Request format:
- Command (2) [UINT8]
- Segment [UINT8]
- Transaction Number [UINT16]
- Offset into data [UINT16]

Read Transaction Response format:
- Command (2) [UINT8]
- Message Data Size [UINT8]
- More data flag [UINT8]
- Data Type [UINT8]
- Repeating for num bytes:
  - Data size [variable]
  - Value [variable]

Variants:
Request:
- list: List Transaction request
- read: Read Transaction request

Response:
- list_single: List with one transaction
- list_max: List with multiple transactions
- read_single: Read with single data point
- read_max: Read with multiple data points
"""

# Data type enum values and their sizes
DATA_TYPES = {
    "U8": {"code": 1, "size": 1},
    "S8": {"code": 2, "size": 1},
    "U16": {"code": 3, "size": 2},
    "S16": {"code": 4, "size": 2},
    "U32": {"code": 5, "size": 4},
    "S32": {"code": 6, "size": 4},
    "FLOAT": {"code": 7, "size": 4},
    "DOUBLE": {"code": 8, "size": 8},
    "STRING3": {"code": 9, "size": 3},
    "STRING7": {"code": 10, "size": 7},
    "STRING10": {"code": 11, "size": 10},
    "STRING20": {"code": 12, "size": 20},
    "STRING30": {"code": 14, "size": 30},
    "STRING40": {"code": 15, "size": 40},
    "BINARY": {"code": 17, "size": 1},
    "TLP": {"code": 18, "size": 3},
    "TIME": {"code": 20, "size": 4}
}

PAYLOAD = {
    "request": {
        "list": {
            "payload": {
                "command": 1,
                "segment": 1,
                "transaction_offset": 0
            }
        },
        "read_single": {
            "payload": {
                "command": 2,  # Read Transaction
                "segment": 1,
                "transaction_number": 1234,
                "data_offset": 0  # Start at beginning
            }
        },
        "read_max": {
            "payload": {
                "command": 2,  # Read Transaction
                "segment": 1,
                "transaction_number": 1234,
                "data_offset": 0  # Start at beginning
            }
        }
    },
    "response": {
        "list_single": {
            "payload": {
                "command": 1,
                "num_transactions": 1,
                "more_transactions": 0,
                "description": b"SINGLE TXN",
                "payload_size": 6,
                "transactions": [
                    {
                        "number": 1,
                        "date_created": 0x12345678
                    }
                ]
            }
        },
        "list_max": {
            "payload": {
                "command": 1,
                "num_transactions": 3,
                "more_transactions": 1,
                "description": b"MULTI TXNS",
                "payload_size": 6,
                "transactions": [
                    {
                        "number": 1,
                        "date_created": 0x12345678
                    },
                    {
                        "number": 2,
                        "date_created": 0x23456789
                    },
                    {
                        "number": 3,
                        "date_created": 0x3456789A
                    }
                ]
            }
        },
        "read_single": {
            "payload": {
                "command": 2,  # Read Transaction
                "message_data_size": 6,  # 1 byte type + 1 byte U8 value + 1 byte type + 4 byte FLOAT
                "more_data": 0,  # No more data
                "data_points": [
                    {
                        "type": "FLOAT",  # code 7 (1 byte) + value (4 bytes)
                        "value": 3.14159
                    }
                ]
            }
        },
        "read_max": {
            "payload": {
                "command": 2,  # Read Transaction
                "message_data_size": 24,  # Total size: U16(3) + STRING10(11) + FLOAT(5) + TIME(5) = 24 bytes
                "more_data": 1,  # More data available
                "data_points": [
                    {
                        "type": "U16",  # code 3 (1 byte) + value (2 bytes)
                        "value": 1234
                    },
                    {
                        "type": "STRING10",  # code 11 (1 byte) + value (10 bytes)
                        "value": "Test"  # Should be padded to exactly 10 bytes
                    },
                    {
                        "type": "FLOAT",  # code 7 (1 byte) + value (4 bytes)
                        "value": 2.71828
                    },
                    {
                        "type": "TIME",  # code 20 (1 byte) + value (4 bytes)
                        "value": 1234567890
                    }
                ]
            }
        }
    }
} 