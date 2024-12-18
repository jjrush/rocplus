module ROC_PLUS;

function process_transaction_history(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {
    c = set_transaction_history_log(c);
    local log = c$roc_plus_transaction_history_log;

    log$roc_plus_link_id = link_id;

    if (data$packetType == ROC_PLUS_ENUMS::PacketType_REQUEST) {
        log$command = ROC_PLUS_ENUMS::TRANSACTION_HISTORY_COMMAND[data$readTransactionHistory$request$command];

        if (data$readTransactionHistory$request$command == ROC_PLUS_ENUMS::TransactionHistoryCommand_LIST_TRANSACTION) {
            # List Transaction Request
            log$segment            = data$readTransactionHistory$request$listt$segment;
            log$transaction_offset = data$readTransactionHistory$request$listt$transactionOffset;
        } 
        else if (data$readTransactionHistory$request$command == ROC_PLUS_ENUMS::TransactionHistoryCommand_READ_TRANSACTION) {
            # Read Transaction Request
            log$segment            = data$readTransactionHistory$request$read$segment;
            log$transaction_number = data$readTransactionHistory$request$read$transactionNumber;
            log$data_offset        = data$readTransactionHistory$request$read$dataOffset;
        }
    }
    else if (data$packetType == ROC_PLUS_ENUMS::PacketType_RESPONSE) {
        log$command = ROC_PLUS_ENUMS::TRANSACTION_HISTORY_COMMAND[data$readTransactionHistory$response$command];

        if (data$readTransactionHistory$response$command == ROC_PLUS_ENUMS::TransactionHistoryCommand_LIST_TRANSACTION) {
            # List Transaction Response
            log$num_transactions = data$readTransactionHistory$response$listt$numTransactions;
            log$more_data        = (data$readTransactionHistory$response$listt$moreData == 1) ? "Yes" : "No";
            log$description      = data$readTransactionHistory$response$listt$description;

            # if (data$readTransactionHistory$response$listt?$listTransactions) {
            #     for (i, transaction in data$readTransactionHistory$response$listt$listTransactions) {
            #         log$payload_size[i]    = transaction$payloadSize;
            #         log$transaction_num[i] = transaction$transactionNumber;
            #         log$date_created[i]    = transaction$dateCreated;
            #     }
            # }
        }
        else if (data$readTransactionHistory$response$command == ROC_PLUS_ENUMS::TransactionHistoryCommand_READ_TRANSACTION) {
            # Read Transaction Response
            log$msg_data_size = data$readTransactionHistory$response$read$messageDataSize;
            log$more_data     = (data$readTransactionHistory$response$read$moreData == 1) ? "Yes" : "No";

            if (data$readTransactionHistory$response$read?$readTransactions) {
                for (i, transaction in data$readTransactionHistory$response$read$readTransactions) {
                    log$data_type[i] = ROC_PLUS_ENUMS::DATA_TYPE[transaction$dataType];
                    log$data[i]      = transaction$data;
                }
            }
        }
    }

    ROC_PLUS::emit_roc_plus_transaction_history_log(c);
    delete c$roc_plus_transaction_history_log;
}