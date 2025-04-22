module ROC_PLUS;

    function process_history_information(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {        
        if (data$packetType == ROC_PLUS_ENUMS::PacketType_REQUEST)
        {
            local conn_request = set_history_information_log(c);
            local log_request = conn_request$roc_plus_history_information_log;

            log_request$roc_plus_link_id = link_id;

            log_request$command = ROC_PLUS_ENUMS::HISTORY_SUB_COMMANDS[data$historyInformationData$command];
            if (data$historyInformationData$command == ROC_PLUS_ENUMS::HistorySubCommands_REQUEST_CONFIGURED_POINTS){
                log_request$history_segment = data$historyInformationData$request$configuredPointsRequest$historySegment;
            }
            else if (data$historyInformationData$command == ROC_PLUS_ENUMS::HistorySubCommands_REQUEST_SPECIFIED_POINT_DATA){
                log_request$history_segment       = data$historyInformationData$request$specifiedPointDataRequest$historySegment;
                log_request$history_segment_index = data$historyInformationData$request$specifiedPointDataRequest$historySegmentIndex;
                log_request$type_of_history       = ROC_PLUS_ENUMS::HISTORY_TYPE[data$historyInformationData$request$specifiedPointDataRequest$typeOfHistory];
                log_request$num_time_periods      = data$historyInformationData$request$specifiedPointDataRequest$numTimePeriods;
                log_request$request_timestamps    = data$historyInformationData$request$specifiedPointDataRequest$requestTimestamps;
                log_request$num_points            = data$historyInformationData$request$specifiedPointDataRequest$numPoints;
                
                log_request$requested_history_points = vector();
                for (_, point in data$historyInformationData$request$specifiedPointDataRequest$requestedHistoryPoints) {
                    log_request$requested_history_points += point;
                }
            }
            ROC_PLUS::emit_roc_plus_history_information_log(conn_request);
            delete conn_request$roc_plus_history_information_log;
        }
        else if (data$packetType == ROC_PLUS_ENUMS::PacketType_RESPONSE)
        {
            local conn_response = set_history_information_log(c);
            local log_response = conn_response$roc_plus_history_information_log;

            log_response$roc_plus_link_id = link_id;

            log_response$command = ROC_PLUS_ENUMS::HISTORY_SUB_COMMANDS[data$historyInformationData$command];
            if (data$historyInformationData$command == ROC_PLUS_ENUMS::HistorySubCommands_REQUEST_CONFIGURED_POINTS){
                log_response$history_segment       = data$historyInformationData$response$configuredPointsResponse$historySegment;
                log_response$num_configured_points = data$historyInformationData$response$configuredPointsResponse$numConfiguredPoints;

                log_response$configured_points = vector();
                for (_, point in data$historyInformationData$response$configuredPointsResponse$configuredPoints) {
                    log_response$configured_points += point;
                }
            }
            else if (data$historyInformationData$command == ROC_PLUS_ENUMS::HistorySubCommands_REQUEST_SPECIFIED_POINT_DATA){
                log_response$history_segment    = data$historyInformationData$response$specifiedPointDataResponse$historySegment;
                log_response$current_index      = data$historyInformationData$response$specifiedPointDataResponse$currentHistorySegmentIndex;
                log_response$num_time_periods   = data$historyInformationData$response$specifiedPointDataResponse$numTimePeriods;
                log_response$request_timestamps = data$historyInformationData$response$specifiedPointDataResponse$requestTimestamps;
                log_response$num_points         = data$historyInformationData$response$specifiedPointDataResponse$numPoints;
                
                local counter = 0;
                # for each time period
                while(counter < data$historyInformationData$response$specifiedPointDataResponse$numTimePeriods) {
                    local history_points = data$historyInformationData$response$specifiedPointDataResponse$timePeriodHistoryPointsList[counter]$historyPointValues;

                    # Set sesssion rocplus log object
                    local conn = set_time_period_history_points_log(c);
                    local listLog = conn$roc_plus_time_period_history_points_log;

                    listLog$roc_plus_link_id = link_id;
                    if (data$historyInformationData$response$specifiedPointDataResponse$timePeriodHistoryPointsList[counter]?$timestampForIndex) {
                        listLog$timestamp_for_index = double_to_time(count_to_double(data$historyInformationData$response$specifiedPointDataResponse$timePeriodHistoryPointsList[counter]$timestampForIndex));
                    }

                    listLog$history_point_values = vector();
                    # log each point in the time period
                    for (_, history_point in history_points) {

                        listLog$history_point_values += history_point;

                        # Fire the event and tidy up
                        ROC_PLUS::emit_roc_plus_time_period_history_points_log(conn);
                        delete conn$roc_plus_time_period_history_points_log;
                    }
                    counter += 1;
                }
            }
            ROC_PLUS::emit_roc_plus_history_information_log(conn_response);
            delete conn_response$roc_plus_history_information_log;
        }
        else {
            if ( data$historyInformationData$unknown?$data && data$historyInformationData$unknown$data != "" ) {
                local unknown_connection = set_unknown_data_log(c);
                local unknown_data_log = unknown_connection$roc_plus_unknown_data_log;

                unknown_data_log$roc_plus_link_id = link_id;

                unknown_data_log$data = ROC_PLUS_ENUMS::HISTORY_SUB_COMMANDS[data$historyInformationData$command] + "," + data$historyInformationData$unknown$data;
                
                ROC_PLUS::emit_roc_plus_unknown_data_log(unknown_connection);
                delete unknown_connection$roc_plus_unknown_data_log;
            }
        }
    }