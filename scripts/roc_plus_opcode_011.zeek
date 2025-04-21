module ROC_PLUS;

    function process_configurable_opcode_write(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {
        if (data$packetType == ROC_PLUS_ENUMS::PacketType_REQUEST) 
        {
            c = set_configurable_opcode_log(c);
            local log = c$roc_plus_configurable_opcode_log;

            log$roc_plus_link_id = link_id;
            
            log$table_number            = data$writeConfigurableOpcodePointData$request$tableNumber;
            log$starting_table_location = data$writeConfigurableOpcodePointData$request$startingTableLocation;
            log$num_table_locations     = data$writeConfigurableOpcodePointData$request$numTableLocations;
            log$data                    = data$writeConfigurableOpcodePointData$request$data;
        
            # Fire the event and tidy up
            ROC_PLUS::emit_roc_plus_configurable_opcode_log(c);
            delete c$roc_plus_configurable_opcode_log;
        }
        else if(data$packetType == ROC_PLUS_ENUMS::PacketType_RESPONSE)
        {
            # Response is empty for opcode 11
        }


    }