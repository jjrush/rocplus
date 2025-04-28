module ROC_PLUS;

    function process_file_transfer(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {
        c = set_file_transfer_log(c);
        local log = c$roc_plus_file_transfer_log;

        log$roc_plus_link_id = link_id;

        if (data$packetType == ROC_PLUS_ENUMS::PacketType_REQUEST) {
            log$command = ROC_PLUS_ENUMS::FILE_TRANSFER[data$generalFileTransfer$command];

            switch (data$generalFileTransfer$command) {
                case ROC_PLUS_ENUMS::FileTransfer_OPEN:
                    log$open_options = ROC_PLUS_ENUMS::FILE_OPEN_OPTIONS[data$generalFileTransfer$request$open$options];
                    log$path         = data$generalFileTransfer$request$open$path;
                    log$filename     = data$generalFileTransfer$request$open$filename;
                    break;

                case ROC_PLUS_ENUMS::FileTransfer_READ:
                    log$file_descriptor = data$generalFileTransfer$request$read$fileDescriptor;
                    log$offset          = data$generalFileTransfer$request$read$offset;
                    break;

                case ROC_PLUS_ENUMS::FileTransfer_WRITE:
                    log$file_descriptor = data$generalFileTransfer$request$write$fileDescriptor;
                    log$file_size       = data$generalFileTransfer$request$write$fileSize;
                    log$offset          = data$generalFileTransfer$request$write$offset;
                    log$num_bytes       = data$generalFileTransfer$request$write$numBytes;
                    log$data            = data$generalFileTransfer$request$write$data;
                    break;

                case ROC_PLUS_ENUMS::FileTransfer_CLOSE:
                    log$file_descriptor = data$generalFileTransfer$request$close$fileDescriptor;
                    break;

                case ROC_PLUS_ENUMS::FileTransfer_DELETE:
                    log$path     = data$generalFileTransfer$request$del$path;
                    log$filename = data$generalFileTransfer$request$del$filename;
                    break;

                case ROC_PLUS_ENUMS::FileTransfer_READ_DIRECTORY:
                    log$path = data$generalFileTransfer$request$readDir$path;
                    log$total_num_files = data$generalFileTransfer$request$readDir$totalNumFiles;
                    break;

                case ROC_PLUS_ENUMS::FileTransfer_READ_DIRECTORY_64:
                    log$path = data$generalFileTransfer$request$readDir64$path;
                    log$total_num_files = data$generalFileTransfer$request$readDir64$totalNumFiles;
                    break;
            }
        }
        else if (data$packetType == ROC_PLUS_ENUMS::PacketType_RESPONSE) {
            log$command = ROC_PLUS_ENUMS::FILE_TRANSFER[data$generalFileTransfer$command];

            switch (data$generalFileTransfer$command) {
                case ROC_PLUS_ENUMS::FileTransfer_OPEN:
                    log$file_descriptor = data$generalFileTransfer$response$openResp$fileDescriptor;
                    break;

                case ROC_PLUS_ENUMS::FileTransfer_READ:
                    log$file_descriptor = data$generalFileTransfer$response$readResp$fileDescriptor;
                    log$file_size       = data$generalFileTransfer$response$readResp$fileSize;
                    log$offset          = data$generalFileTransfer$response$readResp$offset;
                    log$num_bytes       = data$generalFileTransfer$response$readResp$numBytes;
                    log$data            = data$generalFileTransfer$response$readResp$data;
                    break;

                case ROC_PLUS_ENUMS::FileTransfer_WRITE:
                    log$file_descriptor = data$generalFileTransfer$response$writeResp$fileDescriptor;
                    log$offset          = data$generalFileTransfer$response$writeResp$offset;
                    break;

                case ROC_PLUS_ENUMS::FileTransfer_READ_DIRECTORY:
                    fallthrough;
                case ROC_PLUS_ENUMS::FileTransfer_READ_DIRECTORY_64:
                    log$additional_files = data$generalFileTransfer$response$readDirResp$additionalFiles;
                    log$total_num_files  = data$generalFileTransfer$response$readDirResp$totalNumFiles;
                    log$file_names       = data$generalFileTransfer$response$readDirResp$fileNames;
                    break;
            }
        }

        # Fire the event and tidy up
        ROC_PLUS::emit_roc_plus_file_transfer_log(c);
        delete c$roc_plus_file_transfer_log;
    }