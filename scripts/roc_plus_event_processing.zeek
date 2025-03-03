module ROC_PLUS;

    event ROC_PLUS::UDP_MessagesEvt(c: connection, is_orig: bool, messages: ROC_PLUS::UDP_Messages) {
        for (i in messages$rocMessage) {
            # Set sesssion rocplus log object
            c = set_roc_plus_log(c);

            # Process the msg
            c = process_message(c, c$roc_plus_log, messages$rocMessage[i]);
        
            # Fire the event and tidy up
            ROC_PLUS::emit_roc_plus_log(c);
            delete c$roc_plus_log;
        }
    }

    event ROC_PLUS::TCP_MessagesEvt(c: connection, is_orig: bool, tcpMessage: ROC_PLUS::ROC_Message_TCP) {
        # Set sesssion rocplus log object
        c = set_roc_plus_log(c);

        # Process the UDP msg
        c = process_message_tcp(c, c$roc_plus_log, tcpMessage);

        # Fire the event and tidy up
        ROC_PLUS::emit_roc_plus_log(c);
        delete c$roc_plus_log;
    }
