module ROC_PLUS;

    function process_history_tag_periodic_index(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {
        if (data$packetType == ROC_PLUS_ENUMS::PacketType_REQUEST) {
            local conn_request = set_data_request_log(c);
            local log_request = conn_request$roc_plus_data_request_log;

            log_request$roc_plus_link_id = link_id;

            log_request$history_segment = data$requestHistoryTagAndPeriodicIndex$request$historySegment;
            log_request$num_points      = data$requestHistoryTagAndPeriodicIndex$request$numPoints;

            log_request$historical_points = vector();
            for (index in data$requestHistoryTagAndPeriodicIndex$request$historicalPoints) {
                log_request$historical_points += data$requestHistoryTagAndPeriodicIndex$request$historicalPoints[index]$historicalPoint;
            }

            ROC_PLUS::emit_roc_plus_data_request_log(conn_request);
            delete conn_request$roc_plus_data_request_log;
        }
        else if(data$packetType == ROC_PLUS_ENUMS::PacketType_RESPONSE) {
            local conn_response = set_data_request_log(c);
            local log_response = conn_response$roc_plus_data_request_log;

            log_response$roc_plus_link_id = link_id;

            log_response$history_segment = data$requestHistoryTagAndPeriodicIndex$response$historySegment;
            log_response$num_points      = data$requestHistoryTagAndPeriodicIndex$response$numPoints;
            log_response$periodic_index  = data$requestHistoryTagAndPeriodicIndex$response$periodicIndex;

            log_response$historical_points = vector();
            for (index in data$requestHistoryTagAndPeriodicIndex$response$historicalPoints) {
                log_response$historical_points += data$requestHistoryTagAndPeriodicIndex$response$historicalPoints[index]$historicalPoint;
            }

            log_response$tag = data$requestHistoryTagAndPeriodicIndex$response$tag;
            
            ROC_PLUS::emit_roc_plus_data_request_log(conn_response);
            delete conn_response$roc_plus_data_request_log;
        }
        else {
            local unknown_connection = set_unknown_opcode_data_log(c);
            local unknown_opcode_data_log = unknown_connection$roc_plus_unknown_opcode_data_log;

            unknown_opcode_data_log$roc_plus_link_id = link_id;

            unknown_opcode_data_log$data = data$requestHistoryTagAndPeriodicIndex$unknown$data;
            ROC_PLUS::emit_roc_plus_unknown_opcode_data_log(unknown_connection);
            delete unknown_connection$roc_plus_unknown_opcode_data_log;
        }
    }