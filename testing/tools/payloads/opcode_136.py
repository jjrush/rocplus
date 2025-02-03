import struct
"""
Opcode 136: Request Multiple History Point Data

Request format:
- History Segment (0-10) [UINT8]
- History Segment Index (Minute 0-59, Periodic 0) [UINT16]
- Type of History (0=Minute, 1=Periodic, 2=Daily) [UINT8]
- Starting history point (0-1) [UINT8]
- # of history points [UINT8]
- # of time periods [UINT8]

Response format:
- History Segment (0-10) [UINT8]
- History Segment Index [UINT16]
- Current history segment index [UINT16]
- # of data elements being sent [UINT8]
- For each time period:
  - Time stamp [UINT32]
  - For each history point:
    - Value [FLOAT32]

Note: (# of history points + 1) * # of time periods must not be greater than 60
Response size calculation:
- Fixed header: 6 bytes
- Per period: 4 bytes (timestamp)
- Per value: 4 bytes (float)
- Total = 6 + (periods * (4 + points * 4))
Must be <= 255 bytes
"""

PAYLOAD = {
    "request": {
        "empty": {
            "payload": {
                "history_segment": 1,
                "segment_index": 0,
                "history_type": 0,  # Minute
                "start_point": 0,
                "num_points": 0,
                "num_periods": 0
            }
        },
        "single": {
            "payload": {
                "history_segment": 1,
                "segment_index": 30,  # Middle of hour
                "history_type": 0,  # Minute
                "start_point": 0,
                "num_points": 1,
                "num_periods": 1
            }
        },
        "max": {
            "payload": {
                "history_segment": 1,
                "segment_index": 59,  # End of hour
                "history_type": 0,  # Minute
                "start_point": 0,
                "num_points": 5,  # 5 points
                "num_periods": 3   # 3 periods
            }
        }
    },
    "response": {
        "empty": {
            "payload": {
                "history_segment": 1,
                "segment_index": 0,
                "current_index": 0,
                "num_elements": 0,
                "periods": []
            }
        },
        "single": {
            "payload": {
                "history_segment": 1,
                "segment_index": 30,
                "current_index": 30,
                "num_elements": 1,
                "periods": [
                    {
                        "timestamp": 0x12345678,
                        "values": [
                            struct.pack('>f', 123.456)  # Example float value
                        ]
                    }
                ]
            }
        },
        "max": {
            "payload": {
                "history_segment": 1,
                "segment_index": 59,
                "current_index": 59,
                "num_elements": 15,  # 5 points * 3 periods
                "periods": [
                    {
                        "timestamp": 0x01020304 + i,  # Base timestamp + increment
                        "values": [
                            struct.pack('>f', 100.0 + j)  # Different value for each point
                            for j in range(5)  # 5 points
                        ]
                    }
                    for i in range(3)  # 3 periods
                ]
            }
        }
    }
} 