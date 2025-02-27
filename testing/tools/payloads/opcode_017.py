"""
Opcode 17: Login/Logout Operations

Used for login/logout operations and session key exchange.

Request formats:
- Standard Login: Operator ID [AC3], Password [UINT16]
- Enhanced Login: Operator ID [AC30], Password [AC40]
- Standard Logout: Operator ID [AC3], Password [UINT16], Access Level [UINT8], Logout String [AC6]
- Enhanced Logout: Operator ID [AC30], Password [AC40], Access Level [UINT8], Logout String [AC6]
- Session: Session Key [AC13]

Response formats:
- Login: Access Level [UINT8]
- Logout: No payload
- Session: Wrapped Key [AC24]
"""

PAYLOAD = {
    "request": {
        "login_standard": {
            "payload": {
                "operator_id": "OP1",    # 3 chars
                "password": 0x1234,      # 2 bytes
                "access_level": 0x01     # 1 byte
            }
        },
        "login_enhanced": {
            "payload": {
                "operator_id": "OPERATOR1",  # Up to 30 chars
                "password": "PASSWORD1",     # Up to 40 chars
                "access_level": 0x01,          # 1 byte
            }
        },
        "logout_standard": {
            "payload": {
                "operator_id": "OP1",       # 3 chars
                "password": 0x1234,         # 2 bytes
                "logout_string": "LOGOUT"   # 6 chars
            }
        },
        "logout_enhanced": {
            "payload": {
                "operator_id": "OPERATOR1",  # Up to 30 chars
                "password": "PASSWORD1",     # Up to 40 chars
                "logout_string": "LOGOUT"    # 6 chars
            }
        },
        "session": {
            "payload": {
                "session_key": "SESSIONKEY_13"  # 13 chars
            }
        }
    },
    "response": {
        "login_standard": {
            "payload": {}  # No payload
        },
        "login_enhanced": {
            "payload": {}  # No payload
        },
        "logout_standard": {
            "payload": {}  # No payload
        },
        "logout_enhanced": {
            "payload": {}  # No payload
        },
        "session": {
            "payload": {
                "wrapped_key": "_WRAPPED__SESSION__KEY__"  # Exactly 24 chars
            }
        }
    }
} 