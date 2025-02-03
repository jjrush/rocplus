"""
Opcode 7: Read Real-time Clock
"""

PAYLOAD = {
    "request": {
        "payload": {}  # Valid request with no payload bytes
    },
    "response": {
        "payload": {
            "second": 30,       # Current second [UINT8]
            "minute": 45,       # Current minute [UINT8]
            "hour": 12,         # Current hour [UINT8]
            "day": 15,          # Current day [UINT8]
            "month": 3,         # Current month [UINT8]
            "year": 2024,       # Current year [UINT16]
            "day_of_week": 3    # Current day of week (1=Sunday -> 7=Saturday) [UINT8]
        }
    }
} 