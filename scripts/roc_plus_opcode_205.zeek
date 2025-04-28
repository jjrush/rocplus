module ROC_PLUS;

    function process_peer_to_peer_network_messages(c: connection, data: ROC_PLUS::DataBytes, link_id: string){
        if (data$packetType == ROC_PLUS_ENUMS::PacketType_REQUEST)
        {
            local conn_request = set_peer_to_peer_network_messages_log(c);
            local log_request = conn_request$roc_plus_peer_to_peer_network_messages_log;
            log_request$roc_plus_link_id = link_id;

            log_request$network_id                      = data$peerToPeerNetworkMessages$request$networkID;
            log_request$commissioned_index_one_based    = data$peerToPeerNetworkMessages$request$commissionedIndexOneBased;
            log_request$embedded_roc_opcode             = data$peerToPeerNetworkMessages$request$embeddedRocOpcode;
            log_request$embedded_request_length         = data$peerToPeerNetworkMessages$request$embeddedRequestLength;
            log_request$embedded_request_data           = data$peerToPeerNetworkMessages$request$embeddedRequestData;

            ROC_PLUS::emit_roc_plus_peer_to_peer_network_messages_log(conn_request);
            delete conn_request$roc_plus_peer_to_peer_network_messages_log;
        }
        else if (data$packetType == ROC_PLUS_ENUMS::PacketType_RESPONSE)
        {
            local conn_response = set_peer_to_peer_network_messages_log(c);
            local log_response = conn_response$roc_plus_peer_to_peer_network_messages_log;
            log_response$roc_plus_link_id = link_id;

            log_response$network_id                      = data$peerToPeerNetworkMessages$response$networkID;
            log_response$commissioned_index_one_based    = data$peerToPeerNetworkMessages$response$commissionedIndexOneBased;
            log_response$embedded_roc_opcode             = data$peerToPeerNetworkMessages$response$embeddedRocOpcode;
            log_response$embedded_response_length        = data$peerToPeerNetworkMessages$response$embeddedResponseLength;
            log_response$embedded_request_data_response  = data$peerToPeerNetworkMessages$response$embeddedRequestDataResponse;

            ROC_PLUS::emit_roc_plus_peer_to_peer_network_messages_log(conn_response);
            delete conn_response$roc_plus_peer_to_peer_network_messages_log;
        }
        else if (data$packetType == ROC_PLUS_ENUMS::PacketType_UNKNOWN)
        {
            if ( data$peerToPeerNetworkMessages$unknown?$data && data$peerToPeerNetworkMessages$unknown$data != "" ) {
                local conn_unknown = set_unknown_data_log(c);
                local log_unknown = conn_unknown$roc_plus_unknown_data_log;
                log_unknown$roc_plus_link_id = link_id;

                log_unknown$data = data$peerToPeerNetworkMessages$unknown$data;
            
                ROC_PLUS::emit_roc_plus_unknown_data_log(conn_unknown);
                delete conn_unknown$roc_plus_unknown_data_log;
            }
        }
    }