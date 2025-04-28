"""
Opcode 24: Store and Forward

Used to forward messages through intermediate ROC units.

Request format:
- Host Address [UINT8]
- Host Group [UINT8]
- Destination 1 Address [UINT8]
- Destination 1 Group [UINT8]
- Destination 2 Address [UINT8]
- Destination 2 Group [UINT8]
- Destination 3 Address [UINT8]
- Destination 3 Group [UINT8]
- Destination 4 Address [UINT8]
- Destination 4 Group [UINT8]
- Desired Opcode [UINT8]
- Data Length [UINT8]
- Data [variable length]

Response format:
- No payload

Variants (request only):
- single: Small data payload (1 byte)
- max: Maximum data payload (244 bytes - limited by 255 byte total payload size minus 11 header bytes)
"""

PAYLOAD = {
    "request": {
        "single": {
            "payload": {
                "host_address": 1,
                "host_group": 2,
                "dest1_address": 3,
                "dest1_group": 4,
                "dest2_address": 5,
                "dest2_group": 6,
                "dest3_address": 7,
                "dest3_group": 8,
                "dest4_address": 9,
                "dest4_group": 10,
                "desired_opcode": 11,
                "data": bytes([0x42])  # Single byte of data
            }
        },
        "max": {
            "payload": {
                "host_address": 1,
                "host_group": 2,
                "dest1_address": 3,
                "dest1_group": 4,
                "dest2_address": 5,
                "dest2_group": 6,
                "dest3_address": 7,
                "dest3_group": 8,
                "dest4_address": 9,
                "dest4_group": 10,
                "desired_opcode": 11,
                "data": bytes([i % 256 for i in range(243)])  # Maximum data size (255 - 11 header bytes)
            }
        }
    },
    "response": {
        "payload": {}  # No response payload
    }
} 