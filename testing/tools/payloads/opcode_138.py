"""
Opcode 138: Request Daily and Periodic History for a Day

Request periodic and daily history data for a specific day of a specified history point.
Response includes arrays of periodic values and daily values, with counts specified in the header.
Each value is 4 bytes in length.
"""

PAYLOAD = {
    "request": {
        "payload": {
            "history_segment": 1,      # History Segment (0-10) [UINT8]
            "point_number": 2,         # Point number [UINT8]
            "day": 3,                  # Day requested [UINT8]
            "month": 4                 # Month requested [UINT8]
        }
    },
    "response": {
        "single": {
            "payload": {
                "history_segment": 0,      # History Segment (0-10) [UINT8]
                "point_number": 0,         # Point number [UINT8]
                "day": 1,                  # Day requested [UINT8]
                "month": 1,                # Month requested [UINT8]
                "num_periodic": 1,         # Number of periodic entries [UINT16]
                "num_daily": 1,           # Number of daily entries [UINT16]
                "periodic_values": [       # Array of 4-byte periodic values
                    [1] * 4               # One 4-byte periodic value
                ],
                "daily_values": [         # Array of 4-byte daily values
                    [2] * 4               # One 4-byte daily value
                ]
            }
        },
        "max": {
            "payload": {
                "history_segment": 0,      # History Segment (0-10) [UINT8]
                "point_number": 0,         # Point number [UINT8]
                "day": 1,                  # Day requested [UINT8]
                "month": 1,                # Month requested [UINT8]
                "num_periodic": 47,        # Number of periodic entries [UINT16] - Adjusted to fit in 255-byte payload
                "num_daily": 12,          # Number of daily entries [UINT16] - Adjusted to fit in 255-byte payload
                "periodic_values": [       # Array of 4-byte periodic values (47 * 4 = 188 bytes)
                    [(i % 155) + 1] * 4   # 47 different 4-byte periodic values (keeping values under 256)
                    for i in range(47)     # Generate 47 different values
                ],
                "daily_values": [         # Array of 4-byte daily values (12 * 4 = 48 bytes)
                    [(i % 155) + 1] * 4   # 12 different 4-byte daily values (keeping values under 256)
                    for i in range(12)     # Generate 12 different values
                ]
            }
        }
    }
} 