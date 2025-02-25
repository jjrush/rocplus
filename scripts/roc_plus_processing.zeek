module ROC_PLUS;

    function process_message_data(c: connection, opcode: ROC_PLUS_ENUMS::Opcode, data: ROC_PLUS::DataBytes, roc_plus_link_id: string) {
        switch(opcode) {
            case ROC_PLUS_ENUMS::Opcode_SYSTEM_CONFIG:
                process_system_config(c, data, roc_plus_link_id);
                break;
            case ROC_PLUS_ENUMS::Opcode_READ_REALTIME_CLOCK:
                process_realtime_clock_read(c, data, roc_plus_link_id);
                break;
            case ROC_PLUS_ENUMS::Opcode_SET_REALTIME_CLOCK:
                process_realtime_clock_set(c, data, roc_plus_link_id);
                break;
            case ROC_PLUS_ENUMS::Opcode_READ_CONFIGURABLE_OPCODE_POINT_DATA:
                process_configurable_opcode_read(c, data, roc_plus_link_id);
                break;
            case ROC_PLUS_ENUMS::Opcode_WRITE_CONFIGURABLE_OPCODE_POINT_DATA:
                process_configurable_opcode_write(c, data, roc_plus_link_id);
                break;
            case ROC_PLUS_ENUMS::Opcode_LOGIN_REQUEST:
                process_login(c, data, roc_plus_link_id);
                break;
            case ROC_PLUS_ENUMS::Opcode_STORE_AND_FORWARD:
                process_store_and_forward(c, data, roc_plus_link_id);
                break;
            case ROC_PLUS_ENUMS::Opcode_REQUEST_IO_POINT_POSITION:
                process_io_point_position(c, data, roc_plus_link_id);
                break;
            case ROC_PLUS_ENUMS::Opcode_ACCESS_USER_DEFINED_INFORMATION:
                process_user_defined_information(c, data, roc_plus_link_id);
                break;
            case ROC_PLUS_ENUMS::Opcode_REQUEST_TODAY_YESTERDAY_MIN_MAX_VALUES:
                process_historical_min_max_vals(c, data, roc_plus_link_id);
                break;
            case ROC_PLUS_ENUMS::Opcode_REQUEST_HISTORY_TAG_AND_PERIODIC_INDEX:
                process_history_tag_periodic_index(c, data, roc_plus_link_id);
                break;
            case ROC_PLUS_ENUMS::Opcode_REQUEST_ALARM_DATA:
                process_alarm_data(c, data, roc_plus_link_id);
                break;
            case ROC_PLUS_ENUMS::Opcode_REQUEST_EVENT_DATA:
                process_event_data(c, data, roc_plus_link_id);
                break;
            case ROC_PLUS_ENUMS::Opcode_REQUEST_SINGLE_HISTORY_POINT_DATA:
                process_single_history_point_data(c, data, roc_plus_link_id);  
                break;
            case ROC_PLUS_ENUMS::Opcode_REQUEST_MULTIPLE_HISTORY_POINT_DATA:
                process_multiple_history_point_data(c, data, roc_plus_link_id); 
                break;
            case ROC_PLUS_ENUMS::Opcode_REQUEST_HISTORY_INDEX:
                process_history_index(c, data, roc_plus_link_id);
                break;
            case ROC_PLUS_ENUMS::Opcode_REQUEST_DAILY_AND_PERIODIC_HISTORY:
                process_periodic_history(c, data, roc_plus_link_id);
                break;
            case ROC_PLUS_ENUMS::Opcode_HISTORY_INFORMATION_DATA:
                process_history_information(c, data, roc_plus_link_id);
                break;
            case ROC_PLUS_ENUMS::Opcode_SET_SINGLE_POINT_PARAMETERS:
                process_set_single_point_parameters(c, data, roc_plus_link_id);
                break;
            case ROC_PLUS_ENUMS::Opcode_REQUEST_SINGLE_POINT_PARAMETERS:
                process_request_single_point_parameters(c, data, roc_plus_link_id);
                break;
            case ROC_PLUS_ENUMS::Opcode_REQUEST_PARAMETERS:
                process_request_parameters(c, data, roc_plus_link_id);
                break;
            case ROC_PLUS_ENUMS::Opcode_WRITE_PARAMETERS:
                process_write_parameters(c, data, roc_plus_link_id);
                break;
            case ROC_PLUS_ENUMS::Opcode_GENERAL_FILE_TRANSFER:
                process_file_transfer(c, data, roc_plus_link_id);
                break;
            case ROC_PLUS_ENUMS::Opcode_PEER_TO_PEER_NETWORK_MESSAGES:
                break;
            case ROC_PLUS_ENUMS::Opcode_READ_TRANSACTION_HISTORY_DATA:
                process_transaction_history(c, data, roc_plus_link_id);
                break;
            case ROC_PLUS_ENUMS::Opcode_SRBX_SIGNAL:
# RESERVED
                break;
            case ROC_PLUS_ENUMS::Opcode_ACKNOWLEDGE_SRBX:
                process_acknowledge_srbx(c, data, roc_plus_link_id);
                break;
            case ROC_PLUS_ENUMS::Opcode_ERROR_INDICATOR:
                process_error_codes(c, data, roc_plus_link_id);
                break;
        }
    }

    function process_message(c: connection, log: roc_plus_log, rocMessage: ROC_PLUS::ROC_Message) : connection {
        local opcode : ROC_PLUS_ENUMS::Opcode;
        opcode = rocMessage$opcode;

        log$roc_plus_link_id  = rocMessage$rocPlusLinkId;

        log$packet_type       = ROC_PLUS_ENUMS::PACKET_TYPE[rocMessage$dataBytes$packetType];
        log$destination_unit  = rocMessage$destinationUnit;
        log$destination_group = rocMessage$destinationGroup;
        log$source_unit       = rocMessage$sourceUnit;
        log$source_group      = rocMessage$sourceGroup;
        log$opcode            = ROC_PLUS_ENUMS::OPCODE[opcode];
        log$data_length       = rocMessage$dataLength;

        log$lsb_crc           = rocMessage$lsbCRC; # least significant byte
        log$msb_crc           = rocMessage$msbCRC; # most signfiicant byte

        # Process the command details
        process_message_data(c, opcode, rocMessage$dataBytes, log$roc_plus_link_id);

        # Return the connection
        return c;
    }

    function process_message_tcp(c: connection, log: roc_plus_log, rocMessageTCP: ROC_PLUS::ROC_Message_TCP) : connection {

        # Process the UDP msg
        c = process_message(c, c$roc_plus_log, rocMessageTCP$rocMessage);

        # Return the connection
        return c;
    }
