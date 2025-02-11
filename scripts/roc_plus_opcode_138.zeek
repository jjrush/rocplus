module ROC_PLUS;

    function process_periodic_history(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {
        c = set_data_request_log(c);
        local log = c$roc_plus_data_request_log;

        if (data$packetType == ROC_PLUS_ENUMS::PacketType_REQUEST)
        {
            log$history_segment = data$requestDailyAndPeriodicHistory$request$historySegment;
            log$history_point   = data$requestDailyAndPeriodicHistory$request$historyPoint;
            log$day_requested   = data$requestDailyAndPeriodicHistory$request$dayRequested;
            log$month_requested = data$requestDailyAndPeriodicHistory$request$monthRequested;
        }
        else if(data$packetType == ROC_PLUS_ENUMS::PacketType_RESPONSE) 
        {
            log$history_segment     = data$requestDailyAndPeriodicHistory$response$historySegment;
            log$history_point       = data$requestDailyAndPeriodicHistory$response$historyPoint;
            log$day_requested       = data$requestDailyAndPeriodicHistory$response$dayRequested;
            log$month_requested     = data$requestDailyAndPeriodicHistory$response$monthRequested;
            log$num_periodic_entries = data$requestDailyAndPeriodicHistory$response$numPeriodicEntries;
            log$num_daily_entries    = data$requestDailyAndPeriodicHistory$response$numDailyEntries;

            log$periodic_values = vector();
            for (_, value in data$requestDailyAndPeriodicHistory$response$periodicValues) {
                log$periodic_values += value;
            }
            log$daily_values = vector();
            for (_, value in data$requestDailyAndPeriodicHistory$response$dailyValues) {
                log$daily_values += value;
            }
        }

        ROC_PLUS::emit_roc_plus_data_request_log(c);
        delete c$roc_plus_data_request_log;
    }