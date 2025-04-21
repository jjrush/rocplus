"""
Opcode 6: System Configuration
"""

PAYLOAD = {
    "request": {
        "payload": {}  # Valid request with no payload bytes
    },
    "response": {
        "payload": {
            "system_mode": 1,           # 0=Firmware Update Mode, 1=Run Mode
            "comm_port": 2,             # Port number this request arrived on
            "security_mode": 0,         # Security Access Mode for the port
            "compatibility_status": 2,   # Logical Compatibility Status - Version 2.00
            "revision": 1,              # Opcode 6 Revision (Version 2.02) - 0=Original
            "roc_subtype": 1,           # 1=Series 1, 0=Series 2
            "reserved": 0,              # Reserved for future use (always 0)
            # Type of ROC:
            # 1 = ROCPAC ROC300-Series
            # 2 = FloBoss 407
            # 3 = FlashPAC ROC300-Series
            # 4 = FloBoss 503
            # 5 = FloBoss 504
            # 6 = ROC800 (809/827)
            # 11 = DL8000
            # X = FB100-Series
            "roc_type": 6,
            # Number of logical points for each point type (60-255)
            # Index 0 corresponds to point type 60, index 1 to point type 61, etc.
            "logical_points": list(range(0, 196))
        }
    }
} 