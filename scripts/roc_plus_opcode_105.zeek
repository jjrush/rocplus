module ROC_PLUS;

    function process_historical_min_max_vals(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {
        c = set_historical_min_max_vals_log(c);
        local log = c$roc_plus_historical_min_max_vals_log;

        log$roc_plus_link_id = link_id;

        if (data$packetType  == ROC_PLUS_ENUMS::PacketType_REQUEST)
        {
            log$history_segment         = data$requestTodayYesterdayMinMaxVals$request$historySegment;
            log$historical_point_number = data$requestTodayYesterdayMinMaxVals$request$historicalPointNumber;
        }
        else if(data$packetType  == ROC_PLUS_ENUMS::PacketType_RESPONSE)
        {
            log$history_segment                    = data$requestTodayYesterdayMinMaxVals$response$historySegment;
            log$historical_point_number            = data$requestTodayYesterdayMinMaxVals$response$historicalPointNumber;
            log$historical_archival_method         = data$requestTodayYesterdayMinMaxVals$response$historicalArchivalMethod;
            log$point_type                         = data$requestTodayYesterdayMinMaxVals$response$pointType;
            log$point_logic_number                 = data$requestTodayYesterdayMinMaxVals$response$pointLogicNumber;
            log$parameter_number                   = data$requestTodayYesterdayMinMaxVals$response$parameterNumber;
            log$current_value                      = data$requestTodayYesterdayMinMaxVals$response$currentValue;
            log$minimum_value_since_contract       = data$requestTodayYesterdayMinMaxVals$response$minimumValueSinceContract;
            log$maximum_value_since_contract       = data$requestTodayYesterdayMinMaxVals$response$maximumValueSinceContract;
            log$time_of_min_value_occurrence       = data$requestTodayYesterdayMinMaxVals$response$timeOfMinValueOccurrence;
            log$time_of_max_value_occurrence       = data$requestTodayYesterdayMinMaxVals$response$timeOfMaxValueOccurrence;
            log$minimum_value_yesterday            = data$requestTodayYesterdayMinMaxVals$response$minimumValueYesterday;
            log$maximum_value_yesterday            = data$requestTodayYesterdayMinMaxVals$response$maximumValueYesterday;
            log$time_of_yesterday_min_value        = data$requestTodayYesterdayMinMaxVals$response$timeOfYesterdayMinValue;
            log$time_of_yesterday_max_value        = data$requestTodayYesterdayMinMaxVals$response$timeOfYesterdayMaxValue;
            log$value_during_last_completed_period = data$requestTodayYesterdayMinMaxVals$response$valueDuringLastCompletedPeriod;
        }

        # Fire the event and tidy up
        ROC_PLUS::emit_roc_plus_historical_min_max_vals_log(c);
        delete c$roc_plus_historical_min_max_vals_log;
    }
    