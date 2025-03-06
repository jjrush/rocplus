"""
Opcode 10: Read Configurable Opcode Point Data

Used to read point data from a ROC800. The response includes table version and variable data.

Request format:
- Table Number [UINT8]
- Start Location [UINT8]
- Number of Locations [UINT8]

Response format:
- Table Number [UINT8]
- Start Location [UINT8]
- Number of Locations [UINT8]
- Table Version [UINT32] (4 bytes)
- Data [variable length]

Variants (response only):
- single: Read a single point (1 location)
- max: Read maximum number of points (255 locations)
"""

PAYLOAD = {
    "request": {
        "payload": {
            "table_number": 1,
            "start_location": 0,
            "num_locations": 1
        }
    },
    "response": {
        "single": {
            "payload": {
                "table_number": 1,
                "start_location": 0,
                "num_locations": 1,
                "table_version": bytes([0x00, 0x00, 0x01, 0x00]),  # 4-byte version number
                "data": bytes([0x42])  # Single data byte
            }
        },
        "max": {
            "payload": {
                "table_number": 15,
                "start_location": 0,
                "num_locations": 44,  # Documentation says 1-44 for table locations
                "table_version": bytes([0x00, 0x00, 0x01, 0x00]),  # 4-byte version number
                "data": bytes([i % 44 for i in range(44)])  # 44 data bytes + 7 header bytes = 51 total
            }
        }
    }
} 