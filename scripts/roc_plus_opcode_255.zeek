module ROC_PLUS;

    function process_error_codes(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {
        if(data$packetType  == ROC_PLUS_ENUMS::PacketType_RESPONSE) 
        {
            local conn_response = set_roc_plus_log(c);
            local log_response = conn_response$roc_plus_log;
            log_response$roc_plus_link_id = link_id;

            log_response$error_code   = vector();
            log_response$error_offset = vector();
            for (_, error in data$errorIndicator$response$errors)
            {
                log_response$error_code   += ROC_PLUS_ENUMS::ERROR_CODE[error$errorCode];
                log_response$error_offset += error$errorOffset;
            }

            ROC_PLUS::emit_roc_plus_log(conn_response);
            delete conn_response$roc_plus_log;
        }
        else # either request or unknown
        {
            if( data$errorIndicator$unknown?$data)
            {
                # The spec says this is reserved for ROC use but if there ends up being data in this response we have to parse it because of how spicy works
                local conn_req_unk = set_unknown_data_log(c);
                local unknown_data_log = conn_req_unk$roc_plus_unknown_data_log;

                unknown_data_log$data = data$errorIndicator$unknown$data;

                # Fire the event and tidy up
                ROC_PLUS::emit_roc_plus_unknown_data_log(conn_req_unk);
                delete conn_req_unk$roc_plus_unknown_data_log;
            }
        }
    }
    