"""
Opcode 119: Request Event Data

Request event data from the ROC800's Event Log.
Response includes event data blocks of 22 bytes each, up to 10 events maximum.
"""

PAYLOAD = {
    "request": {
        "payload": {
            "num_events": 1,           # Number of events requested (0-10) [UINT8]
            "start_index": 1           # Starting Event Log index [UINT16]
        }
    },
    "response": {
        "single": {
            "payload": {
                "num_events": 1,           # Number of events being sent [UINT8]
                "start_index": 1,          # Starting Event Log index [UINT16]
                "current_index": 1,        # Current Event Log index [UINT16]
                "event_data": [            # Array of event data blocks
                    [1] * 22              # One 22-byte event data block
                ]
            }
        },
        "max": {
            "payload": {
                "num_events": 10,          # Number of events being sent [UINT8]
                "start_index": 1,          # Starting Event Log index [UINT16]
                "current_index": 1,        # Current Event Log index [UINT16]
                "event_data": [            # Array of event data blocks
                    [(i % 255) + 1] * 22  # Ten 22-byte event data blocks with different values
                    for i in range(10)     # Generate 10 different event blocks
                ]
            }
        }
    }
} 