"""
Opcode 135: Request Single History Point Data

Request historical data for a single point. The response includes up to 60 history values,
with each value being 4 bytes in length.
"""

PAYLOAD = {
    "request": {
        "payload": {
            "history_segment": 0,      # History Segment (0-10) [UINT8]
            "point_number": 0,         # Point number [UINT8]
            "history_type": 1,         # Type of History (1=Minute, 2=Periodic, 3=Daily, 4=Daily Time Stamps) [UINT8]
            "start_index": 0,          # Starting history segment index [UINT16]
            "num_values": 30           # Number of values requested (0-60) [UINT8]
        }
    },
    "response": {
        "single": {
            "payload": {
                "history_segment": 0,      # History Segment (0-10) [UINT8]
                "point_number": 0,         # Point number [UINT8]
                "current_index": 0,        # Current history segment index [UINT16]
                "num_values": 1,           # Number of values being sent [UINT8]
                "history_values": [        # Array of 4-byte history values
                    [1] * 4                # One 4-byte history value
                ]
            }
        },
        "max": {
            "payload": {
                "history_segment": 0,      # History Segment (0-10) [UINT8]
                "point_number": 0,         # Point number [UINT8]
                "current_index": 0,        # Current history segment index [UINT16]
                "num_values": 60,          # Number of values being sent [UINT8]
                "history_values": [        # Array of 4-byte history values
                    [(i % 255) + 1] * 4    # 60 different 4-byte history values
                    for i in range(60)     # Generate 60 different values
                ]
            }
        }
    }
} 