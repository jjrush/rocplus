module ROC_PLUS;

    function process_acknowledge_srbx(c: connection, data: ROC_PLUS::DataBytes, link_id: string){
        c = set_acknowledge_srbx_log(c);
        local log = c$roc_plus_acknowledge_srbx_log;

        log$roc_plus_link_id = link_id;

        # log$current_alarm_log_index = data$ackSRBX$request$currentAlarmLogIndex;
        print(data);

        # Fire the event and tidy up
        ROC_PLUS::emit_roc_plus_acknowledge_srbx_log(c);
        delete c$roc_plus_acknowledge_srbx_log;
    }

    