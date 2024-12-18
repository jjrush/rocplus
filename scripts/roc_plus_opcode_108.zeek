module ROC_PLUS;

    function process_history_tag_periodic_index(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {
        c = set_data_request_log(c);
        local log = c$roc_plus_data_request_log;

        log$roc_plus_link_id = link_id;

        if (data$packetType == ROC_PLUS_ENUMS::PacketType_REQUEST)
        {
            log$history_segment = data$requestHistoryTagAndPeriodicIndex$request$historySegment;
            log$num_points      = data$requestHistoryTagAndPeriodicIndex$request$numPoints;
            
            for (index, historicalPoint in data$requestHistoryTagAndPeriodicIndex$request$historicalPoints)
            {
                log$historical_points[index] = historicalPoint$historicalPoint;
            }
        }
        else if(data$packetType == ROC_PLUS_ENUMS::PacketType_RESPONSE)
        {
            log$history_segment = data$requestHistoryTagAndPeriodicIndex$response$historySegment;
            log$num_points      = data$requestHistoryTagAndPeriodicIndex$response$numPoints;
            log$periodic_index  = data$requestHistoryTagAndPeriodicIndex$response$periodicIndex;

            for (index, historicalPoint in data$requestHistoryTagAndPeriodicIndex$response$historicalPoints)
            {
                log$historical_points[index] = historicalPoint$historicalPoint;
            }
            log$tag = data$requestHistoryTagAndPeriodicIndex$response$tag;
        }
        
        ROC_PLUS::emit_roc_plus_data_request_log(c);
        delete c$roc_plus_data_request_log;
    }