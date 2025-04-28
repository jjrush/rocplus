module ROC_PLUS;

    function process_multiple_history_point_data(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {
        c = set_history_point_data_log(c);
        local log = c$roc_plus_history_point_data_log;

        log$roc_plus_link_id = link_id;

        if (data$packetType == ROC_PLUS_ENUMS::PacketType_REQUEST)
        {
            log$history_segment       = data$multipleHistoryPointData$request$historySegment;
            log$history_segment_index = data$multipleHistoryPointData$request$historySegmentIndex;
            log$type_of_history       = ROC_PLUS_ENUMS::HISTORY_TYPE[data$multipleHistoryPointData$request$typeOfHistory];
            log$point_number          = data$multipleHistoryPointData$request$historyPoint;
            log$num_history_points    = data$multipleHistoryPointData$request$numHistoryPoints;
            log$num_time_periods      = data$multipleHistoryPointData$request$numTimePeriods;
        }

        else if (data$packetType == ROC_PLUS_ENUMS::PacketType_RESPONSE)
        {
            log$history_segment               = data$multipleHistoryPointData$response$historySegment;
            log$history_segment_index         = data$multipleHistoryPointData$response$historySegmentIndex;
            log$current_history_segment_index = data$multipleHistoryPointData$response$currentHistorySegmentIndex;
            log$num_data_elements_sent        = data$multipleHistoryPointData$response$numDataElementsSent;

            if ( data$multipleHistoryPointData$response$numDataElementsSent != 0 ) {
                log$history_timestamps = vector();
                log$history_values = vector();
                for (_, history_value in data$multipleHistoryPointData$response$historyValues)
                {
                    log$history_timestamps += double_to_time(count_to_double(history_value$timestamp));
                    log$history_values += history_value$value;
                }
            }
        }

        ROC_PLUS::emit_roc_plus_history_point_data_log(c);
        delete c$roc_plus_history_point_data_log;
    }