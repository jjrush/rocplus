"""
Opcode 11: Write Configurable Opcode Point Data

Used to write point data to a ROC800.

Request format:
- Table Number [UINT8]
- Start Location [UINT8]
- Number of Locations [UINT8]
- Data [variable length]

Response format:
- No payload

Variants (request only):
- single: Write a single point (1 location)
- max: Write maximum number of points (255 locations)
"""

PAYLOAD = {
    "request": {
        "single": {
            "payload": {
                "table_number": 1,
                "start_location": 0,
                "num_locations": 1,
                "data": bytes([0x42])  # Single data byte
            }
        },
        "max": {
            "payload": {
                "table_number": 1,
                "start_location": 0,
                "num_locations": 252,
                "data": bytes([i % 256 for i in range(252)])  # 252 data bytes + 3 header bytes = 255 total
            }
        }
    },
    "response": {
        "payload": {}  # No response payload
    }
} 