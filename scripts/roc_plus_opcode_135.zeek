module ROC_PLUS;

    function process_single_history_point_data(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {
        c = set_history_point_data_log(c);
        local log = c$roc_plus_history_point_data_log;

        log$roc_plus_link_id = link_id;

        if (data$packetType == ROC_PLUS_ENUMS::PacketType_REQUEST)
        {
            log$history_segment            = data$singleHistoryPointData$request$historySegment;
            log$point_number               = data$singleHistoryPointData$request$pointNumber;
            log$type_of_history            = ROC_PLUS_ENUMS::HISTORY_TYPE[data$singleHistoryPointData$request$typeOfHistory];
            log$history_segment_index      = data$singleHistoryPointData$request$historySegmentIndex;
            log$num_values_requested       = data$singleHistoryPointData$request$numValuesRequested;
        }
        else if (data$packetType == ROC_PLUS_ENUMS::PacketType_RESPONSE)
        {
            log$history_segment            = data$singleHistoryPointData$response$historySegment;
            log$point_number               = data$singleHistoryPointData$response$pointNumber;
            log$history_segment_index      = data$singleHistoryPointData$response$historySegmentIndex;
            log$num_values_sent            = data$singleHistoryPointData$response$numValuesSent;
            
            log$history_values = data$singleHistoryPointData$response$historyValues;
        }

        ROC_PLUS::emit_roc_plus_history_point_data_log(c);
        delete c$roc_plus_history_point_data_log;
    }