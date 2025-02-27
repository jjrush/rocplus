"""
Opcode 108: Request History Tag and Periodic Index

Send history point definition and retrieve tag and history period for specified history points.
Maximum of 20 history points allowed per request, all must be within a single segment.
"""

PAYLOAD = {
    "request": {
        "single": {
            "payload": {
                "history_segment": 1,       # History Segment (0-10) [UINT8]
                "num_points": 1,            # Number of historical points [UINT8]
                "points": [                 # Array of history points [UINT8]
                    5                       # Example point number
                ]
            }
        },
        "max": {
            "payload": {
                "history_segment": 1,       # History Segment (0-10) [UINT8]
                "num_points": 20,           # Number of historical points [UINT8]
                "points": list(range(20))   # 20 sequential points as an example
            }
        }
    },
    "response": {
        "single": {
            "payload": {
                "history_segment": 1,       # History Segment (0-10) [UINT8]
                "num_points": 1,            # Number of historical points [UINT8]
                "periodic_index": 1234,     # Periodic Index (common among all points) [UINT16]
                "points": [5],              # Single point [UINT8]
                "tag": "HISTORY005"         # Tag [AC10] - comes after all points
            }
        },
        "max": {
            "payload": {
                "history_segment": 1,       # History Segment (0-10) [UINT8]
                "num_points": 20,           # Number of historical points [UINT8]
                "periodic_index": 1234,     # Periodic Index (common among all points) [UINT16]
                "points": list(range(20)),  # Array of 20 sequential points [UINT8]
                "tag": "MAXHISTORY"         # Tag [AC10] - comes after all points
            }
        }
    }
} 