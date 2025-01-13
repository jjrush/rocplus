module ROC_PLUS;

function process_transaction_history(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {
    c = set_transaction_history_log(c);
    local log = c$roc_plus_transaction_history_log;

    log$roc_plus_link_id = link_id;

    log$command = ROC_PLUS_ENUMS::TRANSACTION_HISTORY_COMMAND[data$readTransactionHistory$command];

    if (data$packetType == ROC_PLUS_ENUMS::PacketType_REQUEST) {
        if (data$readTransactionHistory$command == ROC_PLUS_ENUMS::TransactionHistoryCommand_LIST_TRANSACTION) {
            # List Transaction Request
            log$segment            = data$readTransactionHistory$request$listt$segment;
            log$transaction_offset = data$readTransactionHistory$request$listt$transactionOffset;
        } 
        else if (data$readTransactionHistory$command == ROC_PLUS_ENUMS::TransactionHistoryCommand_READ_TRANSACTION) {
            # Read Transaction Request
            log$segment            = data$readTransactionHistory$request$read$segment;
            log$transaction_number = data$readTransactionHistory$request$read$transactionNumber;
            log$data_offset        = data$readTransactionHistory$request$read$dataOffset;
        }
    }
    else if (data$packetType == ROC_PLUS_ENUMS::PacketType_RESPONSE) {
        if (data$readTransactionHistory$command == ROC_PLUS_ENUMS::TransactionHistoryCommand_LIST_TRANSACTION) {
            # List Transaction Response
            log$num_transactions = data$readTransactionHistory$response$listt$numTransactions;
            log$more_data        = (data$readTransactionHistory$response$listt$moreData == 1) ? "Yes" : "No";
            log$description      = data$readTransactionHistory$response$listt$description;

            if (data$readTransactionHistory$response$listt?$listTransactions) {
                for (listIndex, listTran in data$readTransactionHistory$response$listt$listTransactions) {
                    log$payload_size[listIndex]    = listTran$payloadSize;
                    log$transaction_num[listIndex] = listTran$transactionNumber;
                    log$date_created[listIndex]    = listTran$dateCreated;
                }
            }
        }
        else if (data$readTransactionHistory$command == ROC_PLUS_ENUMS::TransactionHistoryCommand_READ_TRANSACTION) {
            # Read Transaction Response
            log$msg_data_size = data$readTransactionHistory$response$read$messageDataSize;
            log$more_data     = (data$readTransactionHistory$response$read$moreData == 1) ? "Yes" : "No";

            if (data$readTransactionHistory$response$read?$readTransactions) {
                for (readIndex, readTran in data$readTransactionHistory$response$read$readTransactions) {
                    log$data_type[readIndex] = ROC_PLUS_ENUMS::DATA_TYPE[readTran$dataType];
                    log$data[readIndex]      = readTran$data;
                }
            }
        }
    }

    ROC_PLUS::emit_roc_plus_transaction_history_log(c);
    delete c$roc_plus_transaction_history_log;
}