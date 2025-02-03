"""
ROC Plus protocol payload definitions
"""

from .opcode_006 import PAYLOAD as PAYLOAD_006
from .opcode_007 import PAYLOAD as PAYLOAD_007
from .opcode_008 import PAYLOAD as PAYLOAD_008
from .opcode_010 import PAYLOAD as PAYLOAD_010
from .opcode_011 import PAYLOAD as PAYLOAD_011
from .opcode_017 import PAYLOAD as PAYLOAD_017
from .opcode_024 import PAYLOAD as PAYLOAD_024
from .opcode_050 import PAYLOAD as PAYLOAD_050
from .opcode_100 import PAYLOAD as PAYLOAD_100
from .opcode_105 import PAYLOAD as PAYLOAD_105
from .opcode_108 import PAYLOAD as PAYLOAD_108
from .opcode_118 import PAYLOAD as PAYLOAD_118
from .opcode_119 import PAYLOAD as PAYLOAD_119
from .opcode_135 import PAYLOAD as PAYLOAD_135
from .opcode_136 import PAYLOAD as PAYLOAD_136
from .opcode_137 import PAYLOAD as PAYLOAD_137
from .opcode_138 import PAYLOAD as PAYLOAD_138
from .opcode_139 import PAYLOAD as PAYLOAD_139
from .opcode_166 import PAYLOAD as PAYLOAD_166
from .opcode_167 import PAYLOAD as PAYLOAD_167
from .opcode_180 import PAYLOAD as PAYLOAD_180
from .opcode_181 import PAYLOAD as PAYLOAD_181
from .opcode_203 import PAYLOAD as PAYLOAD_203
from .opcode_205 import PAYLOAD as PAYLOAD_205
from .opcode_206 import PAYLOAD as PAYLOAD_206
from .opcode_224 import PAYLOAD as PAYLOAD_224
from .opcode_225 import PAYLOAD as PAYLOAD_225
from .opcode_255 import PAYLOAD as PAYLOAD_255

# Combine all payloads into a single dictionary
OPCODE_PAYLOADS = {
    6: PAYLOAD_006,
    7: PAYLOAD_007,
    8: PAYLOAD_008,
    10: PAYLOAD_010,
    11: PAYLOAD_011,
    17: PAYLOAD_017,
    24: PAYLOAD_024,
    50: PAYLOAD_050,
    100: PAYLOAD_100,
    105: PAYLOAD_105,
    108: PAYLOAD_108,
    118: PAYLOAD_118,
    119: PAYLOAD_119,
    135: PAYLOAD_135,
    136: PAYLOAD_136,
    137: PAYLOAD_137,
    138: PAYLOAD_138,
    139: PAYLOAD_139,
    166: PAYLOAD_166,
    167: PAYLOAD_167,
    180: PAYLOAD_180,
    181: PAYLOAD_181,
    203: PAYLOAD_203,
    205: PAYLOAD_205,
    206: PAYLOAD_206,
    224: PAYLOAD_224,
    225: PAYLOAD_225,
    255: PAYLOAD_255
} 
