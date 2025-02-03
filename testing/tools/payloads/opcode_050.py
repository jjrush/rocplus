"""
Opcode 50: Request I/O Point Position

Request I/O Point Types or Logical Numbers based on system mode:
- Mode 1: 160 bytes response
- Mode 2: 240 bytes response
- Mode 3: 224 bytes response
"""

PAYLOAD = {
    "request": {
        "payload": {
            "io_point_type": 1  # 1 = I/O Logical Number [UINT8]
        }
    },
    "response": {
        "mode_1": {
            "payload": {
                "data": [1] * 160  # 160 bytes of I/O Point Types or Logical Numbers
            }
        },
        "mode_2": {
            "payload": {
                "data": [2] * 240  # 240 bytes of I/O Point Types or Logical Numbers
            }
        },
        "mode_3": {
            "payload": {
                "data": [3] * 224  # 224 bytes of I/O Point Types or Logical Numbers
            }
        }
    }
} 