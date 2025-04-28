"""
Opcode 205: Peer-to-Peer Network Messages

Request format:
- Network ID (1-255) [UINT8]
- Commissioned Index (1-based) [UINT8]
- Embedded ROC opcode [UINT8]
- Embedded Request Length [UINT8]
- Embedded Request Data [Variable]

Response format:
- Network ID (1-255) [UINT8]
- Commissioned Index (1-based) [UINT32] - 4 bytes
- Embedded ROC opcode [UINT8]
- Embedded Response Length [UINT8]
- Embedded Response Data [Variable]

Variants:
- single: Small embedded request/response
- multi: Medium embedded request/response
- max: Maximum embedded request/response
"""

PAYLOAD = {
    "request": {
        "single": {
            "payload": {
                "network_id": 1,
                "commissioned_index": 1,
                "embedded_opcode": 6,
                "embedded_data": bytes([0xA1])  # Single byte with distinct pattern
            }
        },
        "multi": {
            "payload": {
                "network_id": 2,
                "commissioned_index": 2,
                "embedded_opcode": 10,
                "embedded_data": bytes([0xB1, 0xB2, 0xB3, 0xB4, 0xB5])  # 5 bytes with B pattern
            }
        },
        "max": {
            "payload": {
                "network_id": 3,
                "commissioned_index": 3,
                "embedded_opcode": 180,
                "embedded_data": bytes([0xC0 + i for i in range(20)])  # 20 bytes starting at C0
            }
        }
    },
    "response": {
        "single": {
            "payload": {
                "network_id": 1,
                "commissioned_index": 0x01020304,  # 4 bytes: 01 02 03 04
                "embedded_opcode": 6,
                "embedded_data": bytes([0xD1])  # Single byte with distinct pattern
            }
        },
        "multi": {
            "payload": {
                "network_id": 2,
                "commissioned_index": 0x05060708,  # 4 bytes: 05 06 07 08
                "embedded_opcode": 10,
                "embedded_data": bytes([0xE1, 0xE2, 0xE3, 0xE4, 0xE5])  # 5 bytes with E pattern
            }
        },
        "max": {
            "payload": {
                "network_id": 3,
                "commissioned_index": 0x090A0B0C,  # 4 bytes: 09 0A 0B 0C
                "embedded_opcode": 180,
                "embedded_data": bytes([0xE0 + i for i in range(20)])  # 20 bytes starting at E0
            }
        }
    }
} 