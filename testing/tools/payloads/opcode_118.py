"""
Opcode 118: Request Alarm Data

Request alarm data from the ROC800's Alarm Log.
Response includes alarm data blocks of 23 bytes each, up to 10 alarms maximum.
"""

PAYLOAD = {
    "request": {
        "empty": {
            "payload": {
                "num_alarms": 0,           # Number of alarms requested (0-10) [UINT8]
                "start_index": 1           # Starting Alarm Log index [UINT16]
            }
        },
        "single": {
            "payload": {
                "num_alarms": 1,           # Number of alarms requested (0-10) [UINT8]
                "start_index": 1           # Starting Alarm Log index [UINT16]
            }
        },
        "max": {
            "payload": {
                "num_alarms": 10,          # Number of alarms requested (0-10) [UINT8]
                "start_index": 1           # Starting Alarm Log index [UINT16]
            }
        }
    },
    "response": {
        "empty": {
            "payload": {
                "num_alarms": 0,           # Number of alarms being sent [UINT8]
                "start_index": 1,          # Starting Alarm Log index [UINT16]
                "current_index": 1,        # Current Alarm Log index [UINT16]
                "alarm_data": []           # Empty array since num_alarms = 0
            }
        },
        "single": {
            "payload": {
                "num_alarms": 1,           # Number of alarms being sent [UINT8]
                "start_index": 1,          # Starting Alarm Log index [UINT16]
                "current_index": 1,        # Current Alarm Log index [UINT16]
                "alarm_data": [            # Array of alarm data blocks
                    [1] * 23              # One 23-byte alarm data block
                ]
            }
        },
        "max": {
            "payload": {
                "num_alarms": 10,          # Number of alarms being sent [UINT8]
                "start_index": 1,          # Starting Alarm Log index [UINT16]
                "current_index": 1,        # Current Alarm Log index [UINT16]
                "alarm_data": [            # Array of alarm data blocks
                    [(i % 255) + 1] * 23  # Ten 23-byte alarm data blocks with different values
                    for i in range(10)     # Generate 10 different alarm blocks
                ]
            }
        }
    }
} 