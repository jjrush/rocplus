module ROC_PLUS;

    function process_event_data(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {
        c = set_data_request_log(c);
        local log = c$roc_plus_data_request_log;

        log$roc_plus_link_id = link_id;

        if (data$packetType == ROC_PLUS_ENUMS::PacketType_REQUEST)
        {
            log$num_events_req         = data$requestEventData$request$numEventsRequested;
            log$starting_event_log_idx = data$requestEventData$request$startingEventLogIndexReq;
        }
        else if(data$packetType == ROC_PLUS_ENUMS::PacketType_RESPONSE)
        {
            log$num_events_sent        = data$requestEventData$response$numEventsSent;
            log$starting_event_log_idx = data$requestEventData$response$startingEventLogIndexRes;
            log$current_event_log_idx  = data$requestEventData$response$currentEventLogIndex;

            log$event_data = vector();
            for (index in data$requestEventData$response$eventDataRes) {
                log$event_data += data$requestEventData$response$eventDataRes[index]$data;
            }

        }

        ROC_PLUS::emit_roc_plus_data_request_log(c);
        delete c$roc_plus_data_request_log;
    }