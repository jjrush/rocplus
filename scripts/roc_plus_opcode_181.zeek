module ROC_PLUS;

    function process_write_parameters(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {
        c = set_unknown_data_log(c);
        local log = c$roc_plus_unknown_data_log;

        log$roc_plus_link_id = link_id;

        # if (data$packetType == ROC_PLUS_ENUMS::PacketType_REQUEST)
        # {
        #     TODO: figure out request
        # }
        # else if (data$packetType == ROC_PLUS_ENUMS::PacketType_RESPONSE)
        # {
        #     TODO: figure out response
        # }
        if (data$packetType == ROC_PLUS_ENUMS::PacketType_UNKNOWN)
        {
            log$data = data$writeParameters$unknown$data;
        }

        ROC_PLUS::emit_roc_plus_unknown_data_log(c);
        delete c$roc_plus_unknown_data_log;
    }