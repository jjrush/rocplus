module ROC_PLUS;

    function process_realtime_clock_set(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {
        c = set_realtime_clock_log(c);
        local log = c$roc_plus_realtime_clock_log;

        log$roc_plus_link_id = link_id;

        if (data$packetType  == ROC_PLUS_ENUMS::PacketType_REQUEST)
        {
            log$current_second    = data$setRealtimeClock$request$currentSecond;
            log$current_minute    = data$setRealtimeClock$request$currentMinute;
            log$current_hour      = data$setRealtimeClock$request$currentHour;
            log$current_day       = data$setRealtimeClock$request$currentDay;
            log$current_month     = data$setRealtimeClock$request$currentMonth;
            log$current_year      = data$setRealtimeClock$request$currentYear;
        }
        else if(data$packetType  == ROC_PLUS_ENUMS::PacketType_RESPONSE)
        {
            # Response is empty for opcode 8
        }

        # Fire the event and tidy up
        ROC_PLUS::emit_roc_plus_realtime_clock_log(c);
        delete c$roc_plus_realtime_clock_log;
    }
    