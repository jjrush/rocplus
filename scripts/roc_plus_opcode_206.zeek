module ROC_PLUS;

    # Note: https://github.com/zeek/zeek/issues/4250
    # spicy doesn't support vectors of enums as of the time of this comment
    # as a result we have to collect the data as-is and convert it manually when needed
    function get_data_type(dataType: count): string {
        if( dataType == 1 ) {
            return "U8";
        }
        else if( dataType == 2 ) {
            return "S8";
        }   
        else if( dataType == 3 ) {
            return "U16";
        }
        else if( dataType == 4 ) {
            return "S16";
        }
        else if( dataType == 5 ) {
            return "U32";
        }
        else if( dataType == 6 ) {
            return "S32";
        }
        else if( dataType == 7 ) {
            return "FLOAT";
        }
        else if( dataType == 8 ) {
            return "DOUBLE";
        }
        else if( dataType == 9 ) {
            return "STRING3";
        }
        else if( dataType == 10 ) {
            return "STRING7";
        } 
        else if( dataType == 11 ) {
            return "STRING10";
        }
        else if( dataType == 12 ) {
            return "STRING20";
        } 
        # skip 13
        else if( dataType == 14 ) {
            return "STRING30";
        }
        else if( dataType == 15 ) {
            return "T_STRING40";
        } 
        # skip 16
        else if( dataType == 17 ) {
            return "BINARY";
        }
        else if( dataType == 18 ) {
            return "TLP";
        } 
        # skip 19
        else if( dataType == 20 ) {
            return "TIME";
        }
        else {
            return "Unknown";
        }
    }

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
                log_response$more_data        = (data$readTransactionHistory$response$listt$moreData == T) ? "Yes" : "No";
                log_response$description      = data$readTransactionHistory$response$listt$description;
                log_response$payload_size     = data$readTransactionHistory$response$listt$payloadSize;

                log_response$transaction_num = vector();
                log_response$date_created = vector();

                if (data$readTransactionHistory$response$listt?$listTransactions) {
                    for (listIndex, listTran in data$readTransactionHistory$response$listt$listTransactions) {
                        log_response$transaction_num += listTran$transactionNumber;
                        log_response$date_created    += listTran$dateCreated;
                    }
                }
            }
            else if (data$readTransactionHistory$command == ROC_PLUS_ENUMS::TransactionHistoryCommand_READ_TRANSACTION) {
                # Read Transaction Response
                log_response$msg_data_size = data$readTransactionHistory$response$read$messageDataSize;
                log_response$more_data     = (data$readTransactionHistory$response$read$moreData == T) ? "Yes" : "No";

                log_response$data_type = vector();
                log_response$data = vector();
                if (data$readTransactionHistory$response$read?$types) {
                    for (_, dataType in data$readTransactionHistory$response$read$types) {
                        log_response$data_type += get_data_type(dataType);
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
            if ( data$readTransactionHistory$unknown?$data && data$readTransactionHistory$unknown$data != "" ) {
                local conn_unknown = set_unknown_data_log(c);
                local unknown_log = conn_unknown$roc_plus_unknown_data_log;

                unknown_log$roc_plus_link_id = link_id;
                unknown_log$data = data$readTransactionHistory$unknown$data;

                ROC_PLUS::emit_roc_plus_unknown_data_log(conn_unknown);
                delete conn_unknown$roc_plus_unknown_data_log;
            }
        }
    }