"""
Opcode 139: History Information Data

Two command types:
Command 0: Request configured points
Command 1: Request specified point data

Response includes configured points for Command 0,
or timestamp and value pairs for Command 1.
"""

PAYLOAD = {
    "request": {
        "cmd0": {
            "payload": {
                "command": 0,              # Command (0) [UINT8]
                "history_segment": 0       # History Segment (0-10) [UINT8]
            }
        },
        "cmd1_empty": {
            "payload": {
                "command": 1,              # Command (1) [UINT8]
                "history_segment": 0,      # History Segment (0-10) [UINT8]
                "segment_index": 0,        # History Segment Index [UINT16]
                "history_type": 0,         # Type of History (0=Minute, 1=Periodic, 2=Daily) [UINT8]
                "num_periods": 0,          # Number of time periods [UINT8]
                "req_timestamps": 0,       # Request Timestamps [UINT8]
                "num_points": 0,           # Number of points [UINT8]
                "points": []               # Empty array since num_points = 0
            }
        },
        "cmd1_single": {
            "payload": {
                "command": 1,              # Command (1) [UINT8]
                "history_segment": 2,      # History Segment (0-10) [UINT8]
                "segment_index": 3,        # History Segment Index [UINT16]
                "history_type": 0,         # Type of History (0=Minute, 1=Periodic, 2=Daily) [UINT8]
                "num_periods": 1,          # Number of time periods [UINT8]
                "req_timestamps": 1,       # Request Timestamps [UINT8]
                "num_points": 1,           # Number of points [UINT8]
                "points": [5]              # One history point
            }
        },
        "cmd1_max": {
            "payload": {
                "command": 1,              # Command (1) [UINT8]
                "history_segment": 0,      # History Segment (0-10) [UINT8]
                "segment_index": 0,        # History Segment Index [UINT16]
                "history_type": 0,         # Type of History (0=Minute, 1=Periodic, 2=Daily) [UINT8]
                "num_periods": 60,         # Number of time periods [UINT8]
                "req_timestamps": 1,       # Request Timestamps [UINT8]
                "num_points": 20,          # Number of points [UINT8]
                "points": list(range(20))  # 20 sequential points
            }
        }
    },
    "response": {
        "cmd0_empty": {
            "payload": {
                "command": 0,              # Command (0) [UINT8]
                "history_segment": 0,      # History Segment (0-10) [UINT8]
                "num_points": 0,           # Number of configured points [UINT8]
                "points": []               # Empty array since num_points = 0
            }
        },
        "cmd0_single": {
            "payload": {
                "command": 0,              # Command (0) [UINT8]
                "history_segment": 0,      # History Segment (0-10) [UINT8]
                "num_points": 1,           # Number of configured points [UINT8]
                "points": [0]              # One configured point
            }
        },
        "cmd0_max": {
            "payload": {
                "command": 0,              # Command (0) [UINT8]
                "history_segment": 0,      # History Segment (0-10) [UINT8]
                "num_points": 20,          # Number of configured points [UINT8]
                "points": list(range(20))  # 20 sequential points
            }
        },
        "cmd1_empty": {
            "payload": {
                "command": 1,              # Command (1) [UINT8]
                "history_segment": 0,      # History Segment (0-10) [UINT8]
                "current_index": 0,        # Current Index [UINT16]
                "num_periods": 0,          # Number of time periods [UINT8]
                "req_timestamps": 0,       # Request Timestamps [UINT8]
                "num_points": 0,           # Number of points [UINT8]
                "point_data": []           # Empty array since num_points = 0
            }
        },
        "cmd1_single": {
            "payload": {
                "command": 1,              # Command (1) [UINT8]
                "history_segment": 0,      # History Segment (0-10) [UINT8]
                "current_index": 0,        # Current Index [UINT16]
                "num_periods": 1,          # Number of time periods [UINT8]
                "req_timestamps": 1,       # Request Timestamps [UINT8]
                "num_points": 1,           # Number of points [UINT8]
                "point_data": [            # Array of timestamp/value pairs
                    {
                        "timestamp": 1234567890,  # Timestamp [UINT32]
                        "value": [1, 2, 3, 4]     # 4-byte value
                    }
                ]
            }
        },
        "cmd1_max": {
            "payload": {
                "command": 1,              # Command (1) [UINT8]
                "history_segment": 0,      # History Segment (0-10) [UINT8]
                "current_index": 0,        # Current Index [UINT16]
                "num_periods": 60,         # Number of time periods [UINT8]
                "req_timestamps": 1,       # Request Timestamps [UINT8]
                "num_points": 20,          # Number of points [UINT8]
                "point_data": [            # Array of timestamp/value pairs
                    {
                        "timestamp": 1234567890 + i,  # Timestamp [UINT32]
                        "value": [(i % 155) + 1] * 4  # 4-byte value
                    }
                    for i in range(20)     # Generate 20 different points
                ]
            }
        }
    }
} 