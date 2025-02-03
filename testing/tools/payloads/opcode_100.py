"""
Opcode 100: Access User-defined Information

Get point type information and retrieve information about point types.
Response includes point types for each point requested (0-245 points).
"""

PAYLOAD = {
    "request": {
        "payload": {
            "command": 11,             # Command (11) [UINT8]
            "start_point": 0,          # Start Point # (0-255) [UINT8]
            "num_points": 1            # Number of Points (0-245) [UINT8]
        }
    },
    "response": {
        "empty": {  # Example with no points
            "payload": {
                "command": 11,             # Command (11) [UINT8]
                "start_point": 0,          # Start Point # (0-255) [UINT8]
                "num_points": 0,           # Number of Points (0-245) [UINT8]
                "point_types": []          # Empty array since num_points = 0
            }
        },
        "single": {  # Example with one point
            "payload": {
                "command": 11,             # Command (11) [UINT8]
                "start_point": 0,          # Start Point # (0-255) [UINT8]
                "num_points": 1,           # Number of Points (0-245) [UINT8]
                "point_types": [           # Array of point types [UINT8]
                    5  # Example: User Program (0-7)
                ]
            }
        },
        "max": {  # Example with maximum points
            "payload": {
                "command": 11,             # Command (11) [UINT8]
                "start_point": 0,          # Start Point # (0-255) [UINT8]
                "num_points": 245,         # Number of Points (0-245) [UINT8]
                "point_types": [           # Array of point types [UINT8]
                    # Mix of different point types:
                    # 0-7 = User Program
                    # 253 = User Defined
                    # 254 = ROC Point Type
                    # 255 = No Point Type
                    *([5] * 81 +           # First third: User Program
                      [253] * 82 +         # Second third: User Defined  
                      [254] * 82)          # Final third: ROC Point Type
                ]
            }
        }
    }
}