module ROC_PLUS;

    function process_system_config(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {
        c = set_sys_cfg_log(c);
        local sys_cfg_log = c$roc_plus_sys_cfg_log;

        sys_cfg_log$roc_plus_link_id = link_id;

        if (data$packetType  == ROC_PLUS_ENUMS::PacketType_REQUEST) 
        {
            # no data in opcode 6 request
        }
        else if(data$packetType  == ROC_PLUS_ENUMS::PacketType_RESPONSE)
        {
            sys_cfg_log$system_mode                  = ROC_PLUS_ENUMS::SYSTEM_MODE[data$systemConfiguration$response$systemMode];
            sys_cfg_log$port_number                  = data$systemConfiguration$response$portNumber;
            sys_cfg_log$security_access_mode         = data$systemConfiguration$response$securityAccessMode;
            sys_cfg_log$logical_compatability_status = ROC_PLUS_ENUMS::LOGICAL_COMPATABILITY_STATUS[data$systemConfiguration$response$logicalCompatabilityStatus];
            sys_cfg_log$opcode_revision              = ROC_PLUS_ENUMS::REVISION[data$systemConfiguration$response$opcodeRevision];
            sys_cfg_log$subtype                      = ROC_PLUS_ENUMS::SUBTYPE[data$systemConfiguration$response$subtype];
            sys_cfg_log$type_of_roc                  = ROC_PLUS_ENUMS::TYPE_OF_ROC[data$systemConfiguration$response$typeOfROC];

            sys_cfg_log$point_types = vector();
            for (_, point_type in data$systemConfiguration$response$pointTypes)
            {
                sys_cfg_log$point_types += point_type;
            }
        }

        # Fire the event and tidy up
        ROC_PLUS::emit_roc_plus_sys_cfg_log(c);
        delete c$roc_plus_sys_cfg_log;
    }
    