"""
Opcode 105: Request Today's and Yesterday's Min/Max Values

Send history point definition and retrieve min/max data.
All time values are UINT32 (4 bytes) containing seconds since 12:00AM Jan 1, 1970.
"""

PAYLOAD = {
    "request": {
        "payload": {
            "history_segment": 1,       # History Segment (0-10) [UINT8]
            "point_number": 1           # History point number [UINT8]
        }
    },
    "response": {
        "payload": {
            "history_segment": 1,       # History Segment (0-10) [UINT8]
            "point_number": 1,          # Historical point number [UINT8]
            "archival_method": 0,       # Historical Archival Method Type [UINT8]
            "point_type": 0,            # Point type [UINT8]
            "point_logic_number": 0,    # Point/Logic number [UINT8]
            "parameter_number": 0,      # Parameter number [UINT8]
            "current_value": 1.0,       # Current value [float]
            "min_value_today": 0.5,     # Minimum value since contract hour [float]
            "max_value_today": 1.5,     # Maximum value since contract hour [float]
            "min_time_today": 1704067200,  # Time of minimum value occurrence [UINT32]
            "max_time_today": 1704067200,  # Time of maximum value occurrence [UINT32]
            "min_value_yesterday": 0.3,    # Minimum value yesterday [float]
            "max_value_yesterday": 1.7,    # Maximum value yesterday [float]
            "min_time_yesterday": 1704067200,  # Time of yesterday's min value [UINT32]
            "max_time_yesterday": 1704067200,  # Time of yesterday's max value [UINT32]
            "last_period_value": 1.2        # Value during last completed period [float]
        }
    }
} 