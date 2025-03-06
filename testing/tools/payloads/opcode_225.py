"""
Opcode 225: Acknowledge SRBX

Used to acknowledge SRBX (Signal Report-by-Exception) alarms.

Request format:
- Fixed format with current alarm index (2 bytes)
- current_alarm_index: UINT16 (2 bytes)

Response format:
- No data bytes (empty payload)
"""

PAYLOAD = {
    "request": {
        "payload": {
            "current_alarm_index": 0x0000  # Default to 0, can be any UINT16 value
        }
    },
    "response": {
        "payload": {}  # Empty payload - no data bytes
    }
} 