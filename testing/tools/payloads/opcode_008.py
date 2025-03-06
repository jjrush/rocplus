"""
Opcode 8: Set Real-time Clock
"""

PAYLOAD = {
    "request": {
        "payload": {
            "second": 30,       # Current second [UINT8]
            "minute": 45,       # Current minute [UINT8]
            "hour": 12,         # Current hour [UINT8]
            "day": 15,          # Current day [UINT8]
            "month": 3,         # Current month [UINT8]
            "year": 2024        # Current year [UINT16]
        }
    },
    "response": {
        "payload": {}  # Valid response with no payload bytes
    }
} 