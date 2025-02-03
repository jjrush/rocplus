module ROC_PLUS;

function process_transaction_history(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {
    if (data$packetType == ROC_PLUS_ENUMS::PacketType_REQUEST) {
        local conn_request = set_transaction_history_log(c);
        local log_request = conn_request$roc_plus_transaction_history_log;

        log_request$roc_plus_link_id = link_id;

        log_request$command = ROC_PLUS_ENUMS::TRANSACTION_HISTORY_COMMAND[data$readTransactionHistory$command];

        if (data$readTransactionHistory$command == ROC_PLUS_ENUMS::TransactionHistoryCommand_LIST_TRANSACTION) {
            # List Transaction Request
            log_request$segment            = data$readTransactionHistory$request$listt$segment;
            log_request$transaction_offset = data$readTransactionHistory$request$listt$transactionOffset;
        } 
        else if (data$readTransactionHistory$command == ROC_PLUS_ENUMS::TransactionHistoryCommand_READ_TRANSACTION) {
            # Read Transaction Request
            log_request$segment            = data$readTransactionHistory$request$read$segment;
            log_request$transaction_number = data$readTransactionHistory$request$read$transactionNumber;
            log_request$data_offset        = data$readTransactionHistory$request$read$dataOffset;
        }

        ROC_PLUS::emit_roc_plus_transaction_history_log(conn_request);
        delete conn_request$roc_plus_transaction_history_log;
    }
    else if (data$packetType == ROC_PLUS_ENUMS::PacketType_RESPONSE) {
        local conn_response = set_transaction_history_log(c);
        local log_response = conn_response$roc_plus_transaction_history_log;

        log_response$roc_plus_link_id = link_id;

        log_response$command = ROC_PLUS_ENUMS::TRANSACTION_HISTORY_COMMAND[data$readTransactionHistory$command];

        if (data$readTransactionHistory$command == ROC_PLUS_ENUMS::TransactionHistoryCommand_LIST_TRANSACTION) {
            # List Transaction Response
            log_response$num_transactions = data$readTransactionHistory$response$listt$numTransactions;
            log_response$more_data        = (data$readTransactionHistory$response$listt$moreData == 1) ? "Yes" : "No";
            log_response$description      = data$readTransactionHistory$response$listt$description;

            log_response$payload_size = vector();
            log_response$transaction_num = vector();
            log_response$date_created = vector();

            if (data$readTransactionHistory$response$listt?$listTransactions) {
                for (listIndex, listTran in data$readTransactionHistory$response$listt$listTransactions) {
                    log_response$payload_size    += listTran$payloadSize;
                    log_response$transaction_num += listTran$transactionNumber;
                    log_response$date_created    += listTran$dateCreated;
                }
            }
        }
        else if (data$readTransactionHistory$command == ROC_PLUS_ENUMS::TransactionHistoryCommand_READ_TRANSACTION) {
            # Read Transaction Response
            log_response$msg_data_size = data$readTransactionHistory$response$read$messageDataSize;
            log_response$more_data     = (data$readTransactionHistory$response$read$moreData == 1) ? "Yes" : "No";

            log_response$data_type = vector();
            log_response$data = vector();
            print "here 1";
            if (data$readTransactionHistory$response$read?$types) {
                print "here 2";
                for (_, data_type in data$readTransactionHistory$response$read$types) {
                    print "data_type: ", data_type;
                    print "here 3";
                    # log_response$data_type += ROC_PLUS_ENUMS::DATA_TYPE[data_type];
                }
            }
            if (data$readTransactionHistory$response$read?$values) {
                for (_, data_value in data$readTransactionHistory$response$read$values) {
                    log_response$data += data_value;
                }
            }
        }

        ROC_PLUS::emit_roc_plus_transaction_history_log(conn_response);
        delete conn_response$roc_plus_transaction_history_log;
    }
    else if(data$packetType == ROC_PLUS_ENUMS::PacketType_UNKNOWN) {
        local conn_unknown = set_unknown_opcode_data_log(c);
        local unknown_log = conn_unknown$roc_plus_unknown_opcode_data_log;

        unknown_log$roc_plus_link_id = link_id;
        unknown_log$data = data$readTransactionHistory$unknown$data;

        ROC_PLUS::emit_roc_plus_unknown_opcode_data_log(conn_unknown);
        delete conn_unknown$roc_plus_unknown_opcode_data_log;
    }
}