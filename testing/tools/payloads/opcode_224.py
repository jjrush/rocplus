"""
Opcode 224: SRBX Signal

Signal Report-by-Exception. Host can use various methods to retrieve the alarm index.

Request format:
- Variable/undefined format (implementation dependent)
- Raw data bytes will be logged for analysis
- Single: Simple 1-byte pattern
- Max: Complex multi-byte pattern

Response format:
- No data bytes (empty payload)
"""

PAYLOAD = {
    "request": {
        "single": {
            "payload": {
                "raw_data": bytes([0x42])  # Simple single-byte pattern
            }
        },
        "max": {
            "payload": {
                "raw_data": bytes([  # Complex multi-byte pattern
                    0x01, 0x02, 0x03, 0x04,  # Example sequence
                    0xFF, 0xFE, 0xFD, 0xFC,  # Descending sequence
                    0xAA, 0x55, 0xAA, 0x55   # Alternating pattern
                ])
            }
        }
    },
    "response": {
        "payload": {}  # Empty payload - no data bytes
    }
} 