module ROC_PLUS;

    function process_history_index(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {
        c = set_data_request_log(c);
        local log = c$roc_plus_data_request_log;

        log$roc_plus_link_id = link_id;

        if (data$packetType == ROC_PLUS_ENUMS::PacketType_REQUEST)
        {
            log$history_segment = data$requestHistoryIndex$request$historySegment;
            log$day_requested   = data$requestHistoryIndex$request$dayRequested;
            log$month_requested = data$requestHistoryIndex$request$monthRequested;
        }
        else if(data$packetType == ROC_PLUS_ENUMS::PacketType_RESPONSE)
        {
            log$history_segment       = data$requestHistoryIndex$response$historySegment;
            log$starting_periodic_idx = data$requestHistoryIndex$response$startingPeriodicIdx;
            log$num_periodic_entries  = data$requestHistoryIndex$response$numPeriodicEntries;
            log$daily_index           = data$requestHistoryIndex$response$dailyIndex;
            log$num_daily_entries     = data$requestHistoryIndex$response$numDailyEntries;
        }

        ROC_PLUS::emit_roc_plus_data_request_log(c);
        delete c$roc_plus_data_request_log;
    }