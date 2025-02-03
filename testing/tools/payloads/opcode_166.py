"""
Opcode 166: Set Single Point Parameters

Request format:
- Point type [UINT8]
- Point/Logic Number [UINT8]
- Number of Parameters [UINT8]
- Starting parameter Number [UINT8]
- Data (a contiguous block) [1-230 bytes]

Response:
- No data bytes
- Acknowledgment sent back

Variants:
- empty: One data byte (0)
- single: One data byte (1)
- max: 230 data bytes
"""

PAYLOAD = {
    "request": {
        "empty": {
            "payload": {
                "point_type": 1,           # Point type [UINT8]
                "point_number": 1,         # Point/Logic Number [UINT8]
                "num_parameters": 1,       # Number of Parameters [UINT8]
                "start_param": 0,          # Starting parameter Number [UINT8]
                "data": [0]                # Minimum one byte of data (0)
            }
        },
        "single": {
            "payload": {
                "point_type": 1,           # Point type [UINT8]
                "point_number": 1,         # Point/Logic Number [UINT8]
                "num_parameters": 2,       # Number of Parameters [UINT8]
                "start_param": 0,          # Starting parameter Number [UINT8]
                "data": [1, 2]             # Two bytes of data (1, 2)
            }
        },
        "max": {
            "payload": {
                "point_type": 1,           # Point type [UINT8]
                "point_number": 1,         # Point/Logic Number [UINT8]
                "num_parameters": 230,     # Number of Parameters [UINT8]
                "start_param": 0,          # Starting parameter Number [UINT8]
                "data": list(range(230))   # 230 bytes of sequential data
            }
        }
    },
    "response": {
        "payload": {}  # Empty payload for response (acknowledgment only)
    }
} 