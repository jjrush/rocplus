module ROC_PLUS;

    function process_set_single_point_parameters(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {
        if (data$packetType == ROC_PLUS_ENUMS::PacketType_REQUEST)
        {
            c = set_single_point_parameters_log(c);
            local log = c$roc_plus_single_point_parameters_log;

            log$roc_plus_link_id = link_id;
            
            log$point_type          = data$setSinglePointParameters$request$pointType;
            log$point_logic_number  = data$setSinglePointParameters$request$pointLogicNumber;
            log$num_parameters      = data$setSinglePointParameters$request$numParameters;
            log$start_parameter_num = data$setSinglePointParameters$request$startParameterNum;
            log$parameter_data      = data$setSinglePointParameters$request$parameterData;

            ROC_PLUS::emit_roc_plus_single_point_parameters_log(c);
            delete c$roc_plus_single_point_parameters_log;
        }
        # Response is empty - just acknowledgment


    }