"""
Opcode 203: General File Transfer

Used for file operations on the ROC800. All paths must start with '/flash/'.

Commands:
1. Open - Must be performed before reading or writing
2. Read - Must use File Descriptor returned by Open
3. Write - Must use File Descriptor returned by Open
4. Close - Closes opened file and removes descriptor
5. Delete - Can delete file or directory within /flash
6. Read Directory Contents - Returns filenames in /flash/data directory

Request format varies by command:
- Open (1): Command(1), Options(1), Path(100), Filename(25)
- Read (2): Command(1), File Descriptor(4), Offset(4)
- Write (3): Command(1), File Descriptor(4), File Size(4), Offset(4), Num Bytes(1), Data(230 max)
          The above Write format can be repeated for multiple data blocks, but total payload must not exceed 255 bytes
- Close (4): Command(1), File Descriptor(4)
- Delete (5): Command(1), Path(100), Filename(25)
- Read Dir (6): Command(1), Path(100), Total Num Files(1)

Response format varies by command:
- Open (1): Command(1), File Descriptor(4)
- Read (2): Command(1), File Descriptor(4), File Size(4), Offset(4), Num Bytes(1), Data(230 max)
         The above Read format can be repeated for multiple data blocks, but total payload must not exceed 255 bytes
- Write (3): Command(1), File Descriptor(4), Offset(4)
- Close (4): Command(1)
- Delete (5): Command(1)
- Read Dir (6): Command(1), Additional Files(1), Total Files(1), Filenames(variable)
                Each filename is null-terminated, and the entire data section ends with an additional null

Note: While Write requests and Read responses support repeating data blocks, the total payload size
(including all repeated blocks) must not exceed 255 bytes due to protocol limitations.

Variants:
- read_single/write_single: Single small data block
- read_max/write_max: Multiple data blocks up to 255-byte limit
- read_dir_single: Single filename in directory
- read_dir_max: Multiple filenames up to 255-byte limit
"""

PAYLOAD = {
    "request": {
        "open": {
            "payload": {
                "command": 1,
                "options": 0,  # 0=read, 1=write, 2=create, 3=update, 4=truncate
                "path": "/flash/data/",
                "filename": "example.txt"
            }
        },
        "read_single": {
            "payload": {
                "command": 2,
                "file_descriptor": 0,
                "file_size": 10,
                "offset": 0,
                "num_bytes": 4,
                "data": bytes([0x01, 0x02, 0x03, 0x04])  # Simple 4-byte pattern
            }
        },
        "read_max": {
            "payload": {
                "command": 2,
                "file_descriptor": 0,
                "file_size": 240,
                "offset": 0,
                "num_bytes": 230,
                "data": bytes([i % 256 for i in range(230)])  # Maximum data in first block
            }
        },
        "write_single": {
            "payload": {
                "command": 3,
                "file_descriptor": 0,
                "file_size": 10,
                "offset": 0,
                "num_bytes": 4,
                "data": bytes([0x0A, 0x0B, 0x0C, 0x0D])  # Simple 4-byte pattern
            }
        },
        "write_max": {
            "payload": {
                "command": 3,
                "file_descriptor": 0,
                "file_size": 240,
                "offset": 0,
                "num_bytes": 230,
                "data": bytes([i % 256 for i in range(230)])  # Maximum data in first block
            }
        },
        "close": {
            "payload": {
                "command": 4,
                "file_descriptor": 10
            }
        },
        "delete": {
            "payload": {
                "command": 6,
                "path": "/flash/data/",
                "filename": "example.txt"
            }
        },
        "read_dir_single": {
            "payload": {
                "command": 6,
                "path": "/flash/data/",
                "total_num_files": 1  # 1 byte for v3.05
            }
        },
        "read_dir_max": {
            "payload": {
                "command": 6,
                "path": "/flash/data/",
                "total_num_files": 10  # 1 byte for v3.05
            }
        },
        "read_dir_64_single": {  # Version 3.10 or greater
            "payload": {
                "command": 6,
                "path": "/flash/data/",
                "total_num_files": 1  # 2 bytes for version 3.10+
            }
        },
        "read_dir_64_max": {  # Version 3.10 or greater
            "payload": {
                "command": 6,
                "path": "/flash/data/",
                "total_num_files": 10  # 2 bytes for version 3.10+
            }
        }
    },
    "response": {
        "open": {
            "payload": {
                "command": 1,
                "file_descriptor": 0
            }
        },
        "read_single": {
            "payload": {
                "command": 2,
                "file_descriptor": 0,
                "file_size": 10,
                "offset": 0,
                "num_bytes": 4,
                "data": bytes([0x01, 0x02, 0x03, 0x04])  # Simple 4-byte pattern
            }
        },
        "read_max": {
            "payload": {
                "command": 2,
                "file_descriptor": 0,
                "file_size": 240,
                "offset": 0,
                "num_bytes": 230,
                "data": bytes([i % 256 for i in range(230)])  # Maximum data in first block
            }
        },
        "write_single": {
            "payload": {
                "command": 3,
                "file_descriptor": 0,
                "offset": 0,
                "num_bytes": 4,
                "data": bytes([0x0A, 0x0B, 0x0C, 0x0D])  # Simple 4-byte pattern
            }
        },
        "write_max": {
            "payload": {
                "command": 3,
                "file_descriptor": 0,
                "offset": 0,
                "num_bytes": 230,
                "data": bytes([i % 256 for i in range(230)])  # Maximum data in first block
            }
        },
        "close": {
            "payload": {
                "command": 4  # Response only includes command byte
            }
        },
        "delete": {
            "payload": {
                "command": 5  # Response only includes command byte
            }
        },
        "read_dir_single": {
            "payload": {
                "command": 6,
                "additional_files": 0,  # No more files
                "total_files": 1,
                "filenames": ["test.txt"]  # Single filename
            }
        },
        "read_dir_max": {
            "payload": {
                "command": 6,
                "additional_files": 1,  # More files available
                "total_files": 10,
                "filenames": [  # Multiple filenames up to payload limit
                    "data1.txt",
                    "data2.txt",
                    "data3.txt",
                    "config.ini",
                    "log.txt",
                    "backup.dat",
                    "settings.cfg",
                    "history.db",
                    "alarms.log",
                    "events.dat"
                ]
            }
        },
        "read_dir_64_single": {  # Version 3.10 or greater
            "payload": {
                "command": 64,          # Documentation states 64
                "additional_files": 0,  # No more files
                "total_files": 1,
                "filenames": ["test.txt"]  # Single filename
            }
        },
        "read_dir_64_max": {  # Version 3.10 or greater
            "payload": {
                "command": 64,          # Documentation states 64
                "additional_files": 1,  # More files available
                "total_files": 10,
                "filenames": [  # Multiple filenames up to payload limit
                    "data1.txt",
                    "data2.txt",
                    "data3.txt",
                    "config.ini",
                    "log.txt",
                    "backup.dat",
                    "settings.cfg",
                    "history.db",
                    "alarms.log",
                    "events.dat"
                ]
            }
        }
    }
} 