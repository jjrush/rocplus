module ROC_PLUS;

    function process_user_defined_information(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {
        c = set_user_defined_info_log(c);
        local log = c$roc_plus_user_defined_info_log;

        log$roc_plus_link_id = link_id;

        if (data$packetType == ROC_PLUS_ENUMS::PacketType_REQUEST) 
        {
            log$command     = data$accessUserDefinedInfo$request$command;
            log$start_point = data$accessUserDefinedInfo$request$startPoint;
            log$num_points  = data$accessUserDefinedInfo$request$numPoints;
        }
        else if(data$packetType == ROC_PLUS_ENUMS::PacketType_RESPONSE) 
        {
            log$command     = data$accessUserDefinedInfo$response$command;
            log$start_point = data$accessUserDefinedInfo$response$startPoint;
            log$num_points  = data$accessUserDefinedInfo$response$numPoints;
            
            # Initialize point_types as an empty vector
            log$point_types = vector();
            
            # Add each point type to the vector using vector_cat
            for (index in data$accessUserDefinedInfo$response$pointTypes) 
            {
                log$point_types += ROC_PLUS_ENUMS::POINT_TYPE[data$accessUserDefinedInfo$response$pointTypes[index]$pointType];
            }
        }

        ROC_PLUS::emit_roc_plus_user_defined_info_log(c);
        delete c$roc_plus_user_defined_info_log;
    }