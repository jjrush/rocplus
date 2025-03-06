module ROC_PLUS;


    function process_srbx_signal(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {

        if (data$packetType == ROC_PLUS_ENUMS::PacketType_REQUEST) {
                local conn_request = set_data_request_log(c);
                local log_request = conn_request$roc_plus_data_request_log;

                log_request$roc_plus_link_id = link_id;

                log_request$current_alarm_log_idx = data$srbxSignal$request$alarmIndex;
                # print(data);

                ROC_PLUS::emit_roc_plus_data_request_log(conn_request);
                delete conn_request$roc_plus_data_request_log;
            }

    }