"""
Opcode 137: Request History Index for a Day

Request the Periodic and Daily Index for a specific day of a specified history point.
Returns the starting indices and number of entries for both periodic and daily data.
"""

PAYLOAD = {
    "request": {
        "payload": {
            "history_segment": 0,      # History Segment (0-10) [UINT8]
            "day": 1,                  # Day requested [UINT8]
            "month": 1                 # Month requested [UINT8]
        }
    },
    "response": {
        "payload": {
            "history_segment": 0,      # History Segment (0-10) [UINT8]
            "periodic_index": 1000,    # Starting Periodic Index for day and month [UINT16]
            "periodic_entries": 96,    # Number of periodic entries for day [UINT16]
            "daily_index": 500,        # Daily Index for day and month [UINT16]
            "daily_entries": 24        # Number of daily entries per contract day [UINT16]
        }
    }
} 