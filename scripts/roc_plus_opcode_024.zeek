module ROC_PLUS;

    function process_store_and_forward(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {
        c = set_store_and_forward_log(c);
        local log = c$roc_plus_store_and_forward_log;

        log$roc_plus_link_id = link_id;

        if (data$packetType == ROC_PLUS_ENUMS::PacketType_REQUEST) 
        {
           
            log$host_address   = data$storeAndForward$request$hostAddress;
            log$host_group     = data$storeAndForward$request$hostGroup;
            log$dest1_address  = data$storeAndForward$request$dest1Address;
            log$dest1_group    = data$storeAndForward$request$dest1Group;
            log$dest2_address  = data$storeAndForward$request$dest2Address;
            log$dest2_group    = data$storeAndForward$request$dest2Group;
            log$dest3_address  = data$storeAndForward$request$dest3Address;
            log$dest3_group    = data$storeAndForward$request$dest3Group;
            log$dest4_address  = data$storeAndForward$request$dest4Address;
            log$dest4_group    = data$storeAndForward$request$dest4Group;
            log$desired_opcode = data$storeAndForward$request$desiredOpcode;
            log$num_data_bytes = data$storeAndForward$request$numDataBytes;
            log$opcode_data    = data$storeAndForward$request$opcodeData;

            ROC_PLUS::emit_roc_plus_store_and_forward_log(c);
            delete c$roc_plus_store_and_forward_log;
        }
        else if(data$packetType == ROC_PLUS_ENUMS::PacketType_RESPONSE) 
        {
            # Response is empty
        }
    }