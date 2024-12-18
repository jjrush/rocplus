module ROC_PLUS_ENUMS;

export{
    # ROC Plus does not provide a packet-level indication if something is a REQUEST or a RESPONSE.
    # As a result, there exist edge cases where a given packet's REQ size and RES size can be equivalent. 
    # (See Opcode 206's Read Transaction Command. The request is 6 bytes. If the response Data Type at offset 9 is a U16 or S16 then the response will also be 6 bytes.)
    # Without more information it is impossible to know how to treat the given packet.
    # Such packets are UNKNOWN and will be dropped instead of parsed.
    #
    # Section 1.2 General Message Format Details
    #
    #
    const PACKET_TYPE = {
        [ROC_PLUS_ENUMS::PacketType_REQUEST]  = "Request",
        [ROC_PLUS_ENUMS::PacketType_RESPONSE] = "Response",
        [ROC_PLUS_ENUMS::PacketType_UNKNOWN]  = "Unknown"
    }&default = "Unknown";

    #
    # Chapter 2 - Opcodes
    #
    const OPCODE = {
        [ROC_PLUS_ENUMS::Opcode_SYSTEM_CONFIG]                           = "System Config (006)",
        [ROC_PLUS_ENUMS::Opcode_READ_REALTIME_CLOCK]                     = "Read Realtime Clock (007)",
        [ROC_PLUS_ENUMS::Opcode_SET_REALTIME_CLOCK]                      = "Set Realtime Clock (008)",
        [ROC_PLUS_ENUMS::Opcode_READ_CONFIGURABLE_OPCODE_POINT_DATA]     = "Read Configurable Opcode Point Data (010)",
        [ROC_PLUS_ENUMS::Opcode_WRITE_CONFIGURABLE_OPCODE_POINT_DATA]    = "Write Configurable Opcode Point Data (011)",
        [ROC_PLUS_ENUMS::Opcode_LOGIN_REQUEST]                           = "Login Request (017)",
        [ROC_PLUS_ENUMS::Opcode_STORE_AND_FORWARD]                       = "Store And Forward (024)",
        [ROC_PLUS_ENUMS::Opcode_REQUEST_IO_POINT_POSITION]               = "Request IO Point Position (050)",
        [ROC_PLUS_ENUMS::Opcode_ACCESS_USER_DEFINED_INFORMATION]         = "Access User Defined Information (100)",
        [ROC_PLUS_ENUMS::Opcode_REQUEST_TODAY_YESTERDAY_MIN_MAX_VALUES]  = "Request Today's Yesterday's Min/Max Values (105)",
        [ROC_PLUS_ENUMS::Opcode_REQUEST_HISTORY_TAG_AND_PERIODIC_INDEX]  = "Request History Tag And Periodic Index (108)",
        [ROC_PLUS_ENUMS::Opcode_REQUEST_ALARM_DATA]                      = "Request Alarm Data (118)",
        [ROC_PLUS_ENUMS::Opcode_REQUEST_EVENT_DATA]                      = "Request Event Data (119)",
        [ROC_PLUS_ENUMS::Opcode_REQUEST_SINGLE_HISTORY_POINT_DATA]       = "Request Single History Point Data (135)",
        [ROC_PLUS_ENUMS::Opcode_REQUEST_MULTIPLE_HISTORY_POINT_DATA]     = "Request Multiple History Point Data (136)",
        [ROC_PLUS_ENUMS::Opcode_REQUEST_HISTORY_INDEX]                   = "Request History Index (137)",
        [ROC_PLUS_ENUMS::Opcode_REQUEST_DAILY_AND_PERIODIC_HISTORY]      = "Request Daily And Periodic History (138)",
        [ROC_PLUS_ENUMS::Opcode_HISTORY_INFORMATION_DATA]                = "History Information Data (139)",
        [ROC_PLUS_ENUMS::Opcode_SET_SINGLE_POINT_PARAMETERS]             = "Set Single Point Parameters (166)",
        [ROC_PLUS_ENUMS::Opcode_REQUEST_SINGLE_POINT_PARAMETERS]         = "Request Single Point Parameters (167)",
        [ROC_PLUS_ENUMS::Opcode_REQUEST_PARAMETERS]                      = "Request Parameters (180)",
        [ROC_PLUS_ENUMS::Opcode_WRITE_PARAMETERS]                        = "Write Parameters (181)",
        [ROC_PLUS_ENUMS::Opcode_GENERAL_FILE_TRANSFER]                   = "General File Transfer (203)",
        [ROC_PLUS_ENUMS::Opcode_PEER_TO_PEER_NETWORK_MESSAGES]           = "Peer To Peer Network Messages (205)",
        [ROC_PLUS_ENUMS::Opcode_READ_TRANSACTION_HISTORY_DATA]           = "Read Transaction History Data (206)",
        [ROC_PLUS_ENUMS::Opcode_SRBX_SIGNAL]                             = "Srbx Signal (224)",
        [ROC_PLUS_ENUMS::Opcode_ACKNOWLEDGE_SRBX]                        = "Acknowledge Srbx (225)",
        [ROC_PLUS_ENUMS::Opcode_ERROR_INDICATOR]                         = "Error Indicator (255)",
    }&default = "Unknown";

    const SYSTEM_MODE = {
        [ROC_PLUS_ENUMS::SystemMode_FIRMWARE_UPDATE] = "Firmware Update",
        [ROC_PLUS_ENUMS::SystemMode_RUN_MODE]        = "Run Mode"
    }&default = "Unknown";

    const LOGICAL_COMPATABILITY_STATUS = {
        [ROC_PLUS_ENUMS::LogicalCompatabilityStatus_NINE_MAX_MODULE_SLOTS]         = "Compatability Mode: 0 | 16 points per slot | 160 bytes total | 9  module slots max)",
        [ROC_PLUS_ENUMS::LogicalCompatabilityStatus_FOURTEEN_MAX_MODULE_SLOTS]     = "Compatability Mode: 1 | 16 points per slot | 240 bytes total | 14 module slots max)",
        [ROC_PLUS_ENUMS::LogicalCompatabilityStatus_TWENTY_SEVEN_MAX_MODULE_SLOTS] = "Compatability Mode: 2 | 9 points per slot  | 224 bytes total | 27 module slots max)"
    }&default = "Unknown";

    const REVISION = {
        [ROC_PLUS_ENUMS::Revision_ORIGINAL] = "Original",
        [ROC_PLUS_ENUMS::Revision_EXTENDED] = "Extended"
    }&default = "Unknown";

    const SUBTYPE = {
        [ROC_PLUS_ENUMS::Subtype_SERIES_ONE] = "Series One",
        [ROC_PLUS_ENUMS::Subtype_SERIES_TWO] = "Series Two"
    }&default = "Unknown";

    const TYPE_OF_ROC = {
        [ROC_PLUS_ENUMS::TypeOfROC_ROCPAC_ROC300]   =  "ROCPAC ROC300-Series", # 0-index is not used
        [ROC_PLUS_ENUMS::TypeOfROC_FLOBOSS_407]     =  "FloBoss 407",
        [ROC_PLUS_ENUMS::TypeOfROC_FLASHPAC_ROC300] =  "FlashPAC ROC300-Series",
        [ROC_PLUS_ENUMS::TypeOfROC_FLOBOSS_503]     =  "FloBoss 503",
        [ROC_PLUS_ENUMS::TypeOfROC_FLOBOSS_504]     =  "FloBoss 504",
        [ROC_PLUS_ENUMS::TypeOfROC_ROC800]          =  "ROC800 (809/827)",
        [ROC_PLUS_ENUMS::TypeOfROC_DL8000]          =  "DL8000",
        [ROC_PLUS_ENUMS::TypeOfROC_FB100]           =  "FB100", 
    }&default = "FB100"; # The documentation has this as 'X' which cannot be represented by an enum so we will match it on the default case

    const DAY_OF_WEEK = {
        [ROC_PLUS_ENUMS::DayOfWeek_SUNDAY]    = "Sunday",
        [ROC_PLUS_ENUMS::DayOfWeek_MONDAY]    = "Monday",
        [ROC_PLUS_ENUMS::DayOfWeek_TUESDAY]   = "Tuesday",
        [ROC_PLUS_ENUMS::DayOfWeek_WEDNESDAY] = "Wednesday",
        [ROC_PLUS_ENUMS::DayOfWeek_THURSDAY]  = "Thursday",
        [ROC_PLUS_ENUMS::DayOfWeek_FRIDAY]    = "Friday",
        [ROC_PLUS_ENUMS::DayOfWeek_SATURDAY]  = "Saturday"
    }&default = "Unknown";

    const OPCODE_17_TYPE = {
        [ROC_PLUS_ENUMS::Opcode17Type_STANDARD_LOGIN]      = "Standard Login",
        [ROC_PLUS_ENUMS::Opcode17Type_STANDARD_LOGOUT]     = "Standard Logout",
        [ROC_PLUS_ENUMS::Opcode17Type_SESSION_KEY_REQ]     = "Session Key Request",
        [ROC_PLUS_ENUMS::Opcode17Type_ENHANCED_LOGIN]      = "Enhanced Login",
        [ROC_PLUS_ENUMS::Opcode17Type_ENHANCED_LOGOUT]     = "Enhanced Logout",
        [ROC_PLUS_ENUMS::Opcode17Type_WRAPPED_SESSION_KEY] = "Wrapped Session Key",
    }&default = "Unknown";

    const IO_DATA_TYPE = {
        [ROC_PLUS_ENUMS::IODataType_POINT_TYPE]     = "Point Type",
        [ROC_PLUS_ENUMS::IODataType_LOGICAL_NUMBER] = "Logical Number"
    }&default = "Unknown";

    const POINT_TYPE = {
        [ROC_PLUS_ENUMS::PointType_USER_PROGRAM_0] = "User Program 0",
        [ROC_PLUS_ENUMS::PointType_USER_PROGRAM_1] = "User Program 1",
        [ROC_PLUS_ENUMS::PointType_USER_PROGRAM_2] = "User Program 2",
        [ROC_PLUS_ENUMS::PointType_USER_PROGRAM_3] = "User Program 3",
        [ROC_PLUS_ENUMS::PointType_USER_PROGRAM_4] = "User Program 4",
        [ROC_PLUS_ENUMS::PointType_USER_PROGRAM_5] = "User Program 5",
        [ROC_PLUS_ENUMS::PointType_USER_PROGRAM_6] = "User Program 6",
        [ROC_PLUS_ENUMS::PointType_USER_PROGRAM_7] = "User Program 7",
        [ROC_PLUS_ENUMS::PointType_USER_DEFINED]   = "User Defined",
        [ROC_PLUS_ENUMS::PointType_ROC_POINT_TYPE] = "ROC Point Type",
        [ROC_PLUS_ENUMS::PointType_NO_POINT_TYPE]  = "No Point Type"
    };

    const FILE_TRANSFER = {
        [ROC_PLUS_ENUMS::FileTransfer_OPEN]              = "Open",
        [ROC_PLUS_ENUMS::FileTransfer_READ]              = "Read",
        [ROC_PLUS_ENUMS::FileTransfer_WRITE]             = "Write",
        [ROC_PLUS_ENUMS::FileTransfer_CLOSE]             = "Close", 
        [ROC_PLUS_ENUMS::FileTransfer_DELETE]            = "Delete",
        [ROC_PLUS_ENUMS::FileTransfer_READ_DIRECTORY]    = "Read Directory",
        [ROC_PLUS_ENUMS::FileTransfer_READ_DIRECTORY_64] = "Read Directory 64"
    } &default="Unknown";

    const FILE_OPEN_OPTIONS = {
        [ROC_PLUS_ENUMS::FileOpenOptions_OPEN_READ]      = "Open Read",
        [ROC_PLUS_ENUMS::FileOpenOptions_OPEN_WRITE]     = "Open Write",
        [ROC_PLUS_ENUMS::FileOpenOptions_CREATE_WRITE]   = "Create Write",
        [ROC_PLUS_ENUMS::FileOpenOptions_OPEN_UPDATE]    = "Open Update",
        [ROC_PLUS_ENUMS::FileOpenOptions_TRUNCATE_WRITE] = "Truncate Write"
    } &default="Unknown";

    const DATA_TYPE = {
        [ROC_PLUS_ENUMS::DataType_U8]         = "U8",
        [ROC_PLUS_ENUMS::DataType_S8]         = "S8",
        [ROC_PLUS_ENUMS::DataType_U16]        = "U16",
        [ROC_PLUS_ENUMS::DataType_S16]        = "S16",
        [ROC_PLUS_ENUMS::DataType_U32]        = "U32",
        [ROC_PLUS_ENUMS::DataType_S32]        = "S32",
        [ROC_PLUS_ENUMS::DataType_FLOAT]      = "FLOAT",
        [ROC_PLUS_ENUMS::DataType_DOUBLE]     = "DOUBLE",
        [ROC_PLUS_ENUMS::DataType_STRING3]    = "STRING3",
        [ROC_PLUS_ENUMS::DataType_STRING7]    = "STRING7",
        [ROC_PLUS_ENUMS::DataType_STRING10]   = "STRING10",
        [ROC_PLUS_ENUMS::DataType_STRING20]   = "STRING20",
        [ROC_PLUS_ENUMS::DataType_STRING30]   = "STRING30",
        [ROC_PLUS_ENUMS::DataType_T_STRING40] = "T_STRING40",
        [ROC_PLUS_ENUMS::DataType_BINARY]     = "BINARY", # 1 byte
        [ROC_PLUS_ENUMS::DataType_TLP]        = "TLP",    # 3 bytes
        [ROC_PLUS_ENUMS::DataType_TIME]       = "TIME"    # 4 bytes
    } &default="Unknown";

    const TRANSACTION_HISTORY_COMMAND = {
        [ROC_PLUS_ENUMS::TransactionHistoryCommand_LIST_TRANSACTION] = "List",
        [ROC_PLUS_ENUMS::TransactionHistoryCommand_READ_TRANSACTION] = "Read"
    } &default="Unknown";

    const ERROR_CODE = {
        [ROC_PLUS_ENUMS::ErrorCode_INVALID_OPCODE_REQUEST]              = "Invalid Opcode Request",
        [ROC_PLUS_ENUMS::ErrorCode_INVALID_PARAMETER_NUMBER]            = "Invalid Parameter Number",
        [ROC_PLUS_ENUMS::ErrorCode_INVALID_LOGICAL_NUMBER]              = "Invalid Logical Number",
        [ROC_PLUS_ENUMS::ErrorCode_INVALID_POINT_TYPE]                  = "Invalid Point Type",
        [ROC_PLUS_ENUMS::ErrorCode_RECEIVED_TOO_MANY_DATA_BYTES]        = "Received Too Many Data Bytes",
        [ROC_PLUS_ENUMS::ErrorCode_RECEIVED_TOO_FEW_DATA_BYTES]         = "Received Too Few Data Bytes",
        [ROC_PLUS_ENUMS::ErrorCode_OBSOLETE_RESERVED]                   = "Obsolete (Reserved, Not Used)",
        [ROC_PLUS_ENUMS::ErrorCode_OUTSIDE_VALID_ADDRESS_RANGE]         = "Outside Valid Address Range",
        [ROC_PLUS_ENUMS::ErrorCode_INVALID_HISTORY_REQUEST]             = "Invalid History Request",
        [ROC_PLUS_ENUMS::ErrorCode_INVALID_FST_REQUEST]                 = "Invalid FST Request",
        [ROC_PLUS_ENUMS::ErrorCode_INVALID_EVENT_ENTRY]                 = "Invalid Event Entry",
        [ROC_PLUS_ENUMS::ErrorCode_REQUESTED_TOO_MANY_ALARMS]           = "Requested Too Many Alarms",
        [ROC_PLUS_ENUMS::ErrorCode_REQUESTED_TOO_MANY_EVENTS]           = "Requested Too Many Events",
        [ROC_PLUS_ENUMS::ErrorCode_WRITE_TO_READ_ONLY_PARAMETER]        = "Write to Read-Only Parameter",
        [ROC_PLUS_ENUMS::ErrorCode_SECURITY_ERROR]                      = "Security Error",
        [ROC_PLUS_ENUMS::ErrorCode_INVALID_SECURITY_LOGON]              = "Invalid Security Logon",
        [ROC_PLUS_ENUMS::ErrorCode_INVALID_STORE_AND_FORWARD_PATH]      = "Invalid Store and Forward Path",
        [ROC_PLUS_ENUMS::ErrorCode_HISTORY_CONFIGURATION_IN_PROGRESS]   = "History Configuration in Progress",
        [ROC_PLUS_ENUMS::ErrorCode_INVALID_PARAMETER_RANGE]             = "Invalid Parameter Range",
        [ROC_PLUS_ENUMS::ErrorCode_INVALID_1_DAY_HISTORY_INDEX_REQUEST] = "Invalid 1 Day History Index Request",
        [ROC_PLUS_ENUMS::ErrorCode_INVALID_HISTORY_POINT]               = "Invalid History Point",
        [ROC_PLUS_ENUMS::ErrorCode_INVALID_MIN_MAX_REQUEST]             = "Invalid Min/Max Request",
        [ROC_PLUS_ENUMS::ErrorCode_INVALID_TLP]                         = "Invalid TLP",
        [ROC_PLUS_ENUMS::ErrorCode_INVALID_TIME]                        = "Invalid Time",
        [ROC_PLUS_ENUMS::ErrorCode_ILLEGAL_MODBUS_RANGE]                = "Illegal Modbus Range",
        [ROC_PLUS_ENUMS::ErrorCode_GENERAL_ERROR]                       = "General Error",
        [ROC_PLUS_ENUMS::ErrorCode_INVALID_STATE_FOR_WRITE]             = "Invalid State for Write",
        [ROC_PLUS_ENUMS::ErrorCode_INVALID_CONFIGURABLE_OPCODE_REQUEST] = "Invalid Configurable Opcode Request",
        [ROC_PLUS_ENUMS::ErrorCode_HART_PASSTHROUGH_COMM_DISABLED]      = "HART Passthrough Comm Disabled",
        [ROC_PLUS_ENUMS::ErrorCode_HART_PASSTHROUGH_NOT_LICENSED]       = "HART Passthrough Not Licensed",
        [ROC_PLUS_ENUMS::ErrorCode_REQUEST_ACCESS_LEVEL_TOO_HIGH]       = "Request Access Level Too High",
        [ROC_PLUS_ENUMS::ErrorCode_INVALID_LOGOFF_STRING]               = "Invalid Logoff String"
    }&default = "Unknown";

}