module ROC_PLUS;

    function process_acknowledge_srbx(c: connection, data: ROC_PLUS::DataBytes, link_id: string){
        if (data$packetType == ROC_PLUS_ENUMS::PacketType_REQUEST) {
            local conn_request = set_data_request_log(c);
            local log_request = conn_request$roc_plus_data_request_log;

            log_request$roc_plus_link_id = link_id;

            log_request$current_alarm_log_idx = data$ackSRBX$request$currentAlarmLogIndex;
            # print(data);

            ROC_PLUS::emit_roc_plus_data_request_log(conn_request);
            delete conn_request$roc_plus_data_request_log;
        }
        else # either response or unknown 
        { 
            local conn_res_unknown = set_unknown_data_log(c);
            local log_res_unknown = conn_res_unknown$roc_plus_unknown_data_log;

            log_res_unknown$roc_plus_link_id = link_id;

            log_res_unknown$data = data$ackSRBX$unknown$data;
            # print(data);
            
            # Fire the event and tidy up
            ROC_PLUS::emit_roc_plus_unknown_data_log(conn_res_unknown);
            delete conn_res_unknown$roc_plus_unknown_data_log;
        }
        
    }

    