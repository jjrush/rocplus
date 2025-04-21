"""
Opcode 255: Invalid Parameters

Used when invalid parameters are received by ROC800.
Request is raw data that will be logged.
Response contains error information.

Request format:
- Raw data bytes to be logged (variable length)

Response format:
Repeating for each error:
- Error code [UINT8]
- Offset of byte that caused error [UINT8]
"""

PAYLOAD = {
    "request": {
        "payload": {
            "raw_data": bytes([0x02, 0x04, 0x06, 0x08])  # This is technically reserved for ROC use but if there is data we have to parse and dump it
        }
    },
    "response": {
        "single": {
            "payload": {
                "errors": [
                    {"error_code": 6, "offset": 0x06}  # RECEIVED_TOO_FEW_DATA_BYTES
                ]
            }
        },
        "max": {
            "payload": {
                "errors": [
                    {"error_code": 1, "offset": 0x00},   # INVALID_OPCODE_REQUEST
                    {"error_code": 2, "offset": 0x01},   # INVALID_PARAMETER_NUMBER
                    {"error_code": 3, "offset": 0x02},   # INVALID_LOGICAL_NUMBER
                    {"error_code": 4, "offset": 0x03},   # INVALID_POINT_TYPE
                    {"error_code": 5, "offset": 0x04},   # RECEIVED_TOO_MANY_DATA_BYTES
                    {"error_code": 6, "offset": 0x05},   # RECEIVED_TOO_FEW_DATA_BYTES
                    {"error_code": 13, "offset": 0x06},  # OUTSIDE_VALID_ADDRESS_RANGE
                    {"error_code": 20, "offset": 0x07},  # SECURITY_ERROR
                    {"error_code": 25, "offset": 0x08},  # INVALID_PARAMETER_RANGE
                    {"error_code": 50, "offset": 0x09}   # GENERAL_ERROR
                ]
            }
        }
    }
} 