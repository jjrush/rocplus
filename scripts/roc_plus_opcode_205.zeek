module ROC_PLUS;

    function process_peer_to_peer_network_messages(c: connection, data: ROC_PLUS::DataBytes, link_id: string){
        c = set_peer_to_peer_network_messages_log(c);
        local log = c$roc_plus_peer_to_peer_network_messages_log;

        log$roc_plus_link_id = link_id;

        if (data$packetType == ROC_PLUS_ENUMS::PacketType_REQUEST)
        {
            log$network_id                      = data$peerToPeerNetworkMessages$peerToPeerNetworkMessagesRequest$networkID;
            log$commissioned_index_one_based    = data$peerToPeerNetworkMessages$peerToPeerNetworkMessagesRequest$commissionedIndexOneBased;
            log$embedded_roc_opcode             = data$peerToPeerNetworkMessages$peerToPeerNetworkMessagesRequest$embeddedRocOpcode;
            log$embedded_request_length         = data$peerToPeerNetworkMessages$peerToPeerNetworkMessagesRequest$embeddedRequestLength;
            log$embedded_request_data           = data$peerToPeerNetworkMessages$peerToPeerNetworkMessagesRequest$embeddedRequestData;
        }
        else if (data$packetType == ROC_PLUS_ENUMS::PacketType_RESPONSE)
        {
            log$network_id                      = data$peerToPeerNetworkMessages$peerToPeerNetworkMessagesResponse$networkID;
            log$commissioned_index_one_based    = data$peerToPeerNetworkMessages$peerToPeerNetworkMessagesResponse$commissionedIndexOneBased;
            log$embedded_roc_opcode             = data$peerToPeerNetworkMessages$peerToPeerNetworkMessagesResponse$embeddedRocOpcode;
            log$embedded_response_length        = data$peerToPeerNetworkMessages$peerToPeerNetworkMessagesResponse$embeddedResponseLength;
            log$embedded_request_data_response  = data$peerToPeerNetworkMessages$peerToPeerNetworkMessagesResponse$embeddedRequestDataResponse;
        }

        ROC_PLUS::emit_roc_plus_peer_to_peer_network_messages_log(c);
        delete c$roc_plus_peer_to_peer_network_messages_log;
    }