"""
Opcode 224: SRBX Signal

Signal Report-by-Exception. Host can use various methods to retrieve the alarm index.

Request format:
- Fixed 2-byte raw data payload (0x01, 0x02)

Response format:
- No data bytes (empty payload)
"""

PAYLOAD = {
    "request": {
        "payload": {
            "raw_data": bytes([0x01, 0x02])  # Fixed 2-byte payload
        }
    },
    "response": {
        "payload": {}  # Empty payload - no data bytes
    }
} 