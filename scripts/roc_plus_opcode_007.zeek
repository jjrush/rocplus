module ROC_PLUS;

    function process_realtime_clock_read(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {
        if (data$packetType  == ROC_PLUS_ENUMS::PacketType_REQUEST) 
        {
            # Request is empty for opcode 7
        }
        else if(data$packetType  == ROC_PLUS_ENUMS::PacketType_RESPONSE)
        {
            c = set_realtime_clock_log(c);
            local log = c$roc_plus_realtime_clock_log;

            log$roc_plus_link_id = link_id;

            log$current_second      = data$readRealtimeClock$response$currentSecond;
            log$current_minute      = data$readRealtimeClock$response$currentMinute;
            log$current_hour        = data$readRealtimeClock$response$currentHour;
            log$current_day         = data$readRealtimeClock$response$currentDay;
            log$current_month       = data$readRealtimeClock$response$currentMonth;
            log$current_year        = data$readRealtimeClock$response$currentYear;
            log$current_day_of_week = ROC_PLUS_ENUMS::DAY_OF_WEEK[data$readRealtimeClock$response$currentDayOfWeek];
            log$timestamp           = data$readRealtimeClock$response$timestamp;
            
            # Fire the event and tidy up
            ROC_PLUS::emit_roc_plus_realtime_clock_log(c);
            delete c$roc_plus_realtime_clock_log;        
        }
    }
    