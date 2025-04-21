module ROC_PLUS;

    function process_system_config(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {

        if (data$packetType  == ROC_PLUS_ENUMS::PacketType_REQUEST) 
        {
            # no data in opcode 6 request
        }
        else if(data$packetType  == ROC_PLUS_ENUMS::PacketType_RESPONSE)
        {
            c = set_sys_cfg_log(c);
            local log = c$roc_plus_sys_cfg_log;

            log$roc_plus_link_id = link_id;


            log$system_mode                  = ROC_PLUS_ENUMS::SYSTEM_MODE[data$systemConfiguration$response$systemMode];
            log$port_number                  = data$systemConfiguration$response$portNumber;
            log$security_access_mode         = data$systemConfiguration$response$securityAccessMode;
            log$logical_compatability_status = ROC_PLUS_ENUMS::LOGICAL_COMPATABILITY_STATUS[data$systemConfiguration$response$logicalCompatabilityStatus];
            log$opcode_revision              = ROC_PLUS_ENUMS::REVISION[data$systemConfiguration$response$opcodeRevision];
            log$subtype                      = ROC_PLUS_ENUMS::SUBTYPE[data$systemConfiguration$response$subtype];
            log$type_of_roc                  = ROC_PLUS_ENUMS::TYPE_OF_ROC[data$systemConfiguration$response$typeOfROC];

            log$point_types = vector();
            for (_, point_type in data$systemConfiguration$response$pointTypes)
            {
                log$point_types += point_type;
            }

            # Fire the event and tidy up
            ROC_PLUS::emit_roc_plus_sys_cfg_log(c);
            delete c$roc_plus_sys_cfg_log;
        }


    }
    