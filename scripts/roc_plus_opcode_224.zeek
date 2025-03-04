module ROC_PLUS;

    function process_srbx_signal(c: connection, data: ROC_PLUS::DataBytes, link_id: string){
        if (data$packetType == ROC_PLUS_ENUMS::PacketType_REQUEST) {

            if( data$srbxSignal$request$alarmIndexValid ) {
                local conn_request = set_data_request_log(c);
                local log_request = conn_request$roc_plus_data_request_log;

                log_request$roc_plus_link_id = link_id;
                log_request$current_alarm_log_idx = data$srbxSignal$request$currentAlarmLogIndex;

                ROC_PLUS::emit_roc_plus_data_request_log(conn_request);
                delete conn_request$roc_plus_data_request_log;
            } 
            else 
            {
                local conn_req_unknown = set_unknown_data_log(c);
                local log_req_unknown = conn_req_unknown$roc_plus_unknown_data_log;
                
                log_req_unknown$roc_plus_link_id = link_id;
                log_req_unknown$data = data$srbxSignal$request$unknown;
                
                ROC_PLUS::emit_roc_plus_unknown_data_log(conn_req_unknown);
                delete conn_req_unknown$roc_plus_unknown_data_log;
            }
        }
        else
        { 
            local conn_res_unknown = set_unknown_data_log(c);
            local log_res_unknown = conn_res_unknown$roc_plus_unknown_data_log;

            log_res_unknown$roc_plus_link_id = link_id;

            log_res_unknown$data = data$srbxSignal$unknown$data;
            # print(data);
            
            # Fire the event and tidy up
            ROC_PLUS::emit_roc_plus_unknown_data_log(conn_res_unknown);
            delete conn_res_unknown$roc_plus_unknown_data_log;
        }
        
    }

    