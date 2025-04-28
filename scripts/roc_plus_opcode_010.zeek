module ROC_PLUS;

    function process_configurable_opcode_read(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {
        c = set_configurable_opcode_log(c);
        local log = c$roc_plus_configurable_opcode_log;

        log$roc_plus_link_id = link_id;

        if (data$packetType == ROC_PLUS_ENUMS::PacketType_REQUEST) 
        {
            log$table_number            = data$readConfigurableOpcodePointData$request$tableNumber;
            log$starting_table_location = data$readConfigurableOpcodePointData$request$startingTableLocation;
            log$num_table_locations     = data$readConfigurableOpcodePointData$request$numTableLocations;
        }
        else if(data$packetType == ROC_PLUS_ENUMS::PacketType_RESPONSE) 
        {
            log$table_number            = data$readConfigurableOpcodePointData$response$tableNumber;
            log$starting_table_location = data$readConfigurableOpcodePointData$response$startingTableLocation;
            log$num_table_locations     = data$readConfigurableOpcodePointData$response$numTableLocations;
            log$table_version_number    = data$readConfigurableOpcodePointData$response$tableVersionNumber;
            log$data                    = data$readConfigurableOpcodePointData$response$data;
        }
        else 
        {
            delete c$roc_plus_configurable_opcode_log;
            return;
        }

        # Fire the event and tidy up
        ROC_PLUS::emit_roc_plus_configurable_opcode_log(c);
        delete c$roc_plus_configurable_opcode_log;
    }