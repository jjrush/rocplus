module ROC_PLUS;

    function process_error_codes(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {
        c = set_roc_plus_log(c);
        local log = c$roc_plus_log;

        log$roc_plus_link_id = link_id;

        if (data$packetType  == ROC_PLUS_ENUMS::PacketType_REQUEST) 
        {
            # This opcode will always be a response
        }
        else if(data$packetType  == ROC_PLUS_ENUMS::PacketType_RESPONSE) 
        {
            # TODO: FIX THIS LOGGING MECHANISM - need to emit create and emit log within the for loop (check others too)
            for (index, error in data$errorIndicator$response$errors)
            {
                log$error_code   = ROC_PLUS_ENUMS::ERROR_CODE[error$errorCode];
                log$error_offset = error$errorOffset;
            }

        }

        # Fire the event and tidy up
        ROC_PLUS::emit_roc_plus_log(c);
        delete c$roc_plus_log;
    }
    