"""
Opcode 180: Request Parameters

Request format:
- Number of parameters requested [UINT8]
- For each parameter:
  - Point type [UINT8]
  - Point/Logic number [UINT8]
  - Parameter number [UINT8]

Response format:
- Number of parameters requested [UINT8]
- For each parameter:
  - Point type [UINT8]
  - Point/Logic number [UINT8]
  - Parameter number [UINT8]
  - Data comprising the parameter [UINT8]
  (repeat above as necessary)

Variants:
- single: Request/Response with 1 parameter
- multi: Request/Response with 3 parameters
- max: Request/Response with maximum parameters (20)
"""

PAYLOAD = {
    "request": {
        "single": {
            "payload": {
                "num_parameters": 1,
                "parameters": [
                    {
                        "point_type": 1,
                        "point_number": 1,
                        "param_number": 1
                    }
                ]
            }
        },
        "multi": {
            "payload": {
                "num_parameters": 3,
                "parameters": [
                    {
                        "point_type": 1,
                        "point_number": 1,
                        "param_number": 1
                    },
                    {
                        "point_type": 2,
                        "point_number": 2,
                        "param_number": 2
                    },
                    {
                        "point_type": 3,
                        "point_number": 3,
                        "param_number": 3
                    }
                ]
            }
        },
        "max": {
            "payload": {
                "num_parameters": 20,
                "parameters": [
                    {
                        "point_type": i + 1,
                        "point_number": i + 1,
                        "param_number": i + 1
                    }
                    for i in range(20)
                ]
            }
        }
    },
    "response": {
        "single": {
            "payload": {
                "num_parameters": 1,
                "parameters": [
                    {
                        "point_type": 1,
                        "point_number": 1,
                        "param_number": 1,
                        "param_data": 0x42
                    }
                ]
            }
        },
        "multi": {
            "payload": {
                "num_parameters": 3,
                "parameters": [
                    {
                        "point_type": 1,
                        "point_number": 1,
                        "param_number": 1,
                        "param_data": 0x42
                    },
                    {
                        "point_type": 2,
                        "point_number": 2,
                        "param_number": 2,
                        "param_data": 0x43
                    },
                    {
                        "point_type": 3,
                        "point_number": 3,
                        "param_number": 3,
                        "param_data": 0x44
                    }
                ]
            }
        },
        "max": {
            "payload": {
                "num_parameters": 20,
                "parameters": [
                    {
                        "point_type": i + 1,
                        "point_number": i + 1,
                        "param_number": i + 1,
                        "param_data": 0x42 + i
                    }
                    for i in range(20)
                ]
            }
        }
    }
} 