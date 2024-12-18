module ROC_PLUS;

    function process_alarm_data(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {
        c = set_data_request_log(c);
        local log = c$roc_plus_data_request_log;

        log$roc_plus_link_id = link_id;

        if (data$packetType == ROC_PLUS_ENUMS::PacketType_REQUEST)
        {
            log$num_alarms             = data$requestAlarmData$request$numAlarmsRequested;
            log$starting_alarm_log_idx = data$requestAlarmData$request$startingAlarmIndexReq;
        }
        else if(data$packetType == ROC_PLUS_ENUMS::PacketType_RESPONSE)
        {
            log$num_alarms             = data$requestAlarmData$response$numAlarmsSent;
            log$starting_alarm_log_idx = data$requestAlarmData$response$startingAlarmIndexRes;
            log$current_alarm_log_idx  = data$requestAlarmData$response$currentAlarmIndex;

            for (index in data$requestAlarmData$response$alarmData)
            {
                log$alarm_data[index] = data$requestAlarmData$response$alarmData[index]$data;
            }
        }

        ROC_PLUS::emit_roc_plus_data_request_log(c);
        delete c$roc_plus_data_request_log;
    }