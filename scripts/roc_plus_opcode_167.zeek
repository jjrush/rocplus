module ROC_PLUS;

    function process_request_single_point_parameters(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {
        c = set_single_point_parameters_log(c);
        local log = c$roc_plus_single_point_parameters_log;

        log$roc_plus_link_id = link_id;

        if (data$packetType == ROC_PLUS_ENUMS::PacketType_REQUEST)
        {
            log$point_type          = data$requestSinglePointParameters$request$pointType;
            log$point_logic_number  = data$requestSinglePointParameters$request$pointLogicNumber;
            log$num_parameters      = data$requestSinglePointParameters$request$numParameters;
            log$start_parameter_num = data$requestSinglePointParameters$request$startParameterNum;
        }
        else if (data$packetType == ROC_PLUS_ENUMS::PacketType_RESPONSE)
        {
            log$point_type          = data$requestSinglePointParameters$response$pointType;
            log$point_logic_number  = data$requestSinglePointParameters$response$pointLogicNumber;
            log$num_parameters      = data$requestSinglePointParameters$response$numParameters;
            log$start_parameter_num = data$requestSinglePointParameters$response$startParameterNum;
            log$parameter_data      = data$requestSinglePointParameters$response$parameterData;
        }

        ROC_PLUS::emit_roc_plus_single_point_parameters_log(c);
        delete c$roc_plus_single_point_parameters_log;
    }