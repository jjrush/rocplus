module ROC_PLUS;

    function process_io_point_position(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {
        c = set_data_request_log(c);
        local log = c$roc_plus_data_request_log;

        log$roc_plus_link_id = link_id;

        if (data$packetType == ROC_PLUS_ENUMS::PacketType_REQUEST) 
        {
            log$io_data_req = ROC_PLUS_ENUMS::IO_DATA_TYPE[data$ioPointPosition$request$ioDataToReq];
        }
        else if(data$packetType == ROC_PLUS_ENUMS::PacketType_RESPONSE) 
        {
            log$io_data = data$ioPointPosition$response$ioData;
        }
        else 
        {
            return;
        }

        ROC_PLUS::emit_roc_plus_data_request_log(c);
        delete c$roc_plus_data_request_log;
    }