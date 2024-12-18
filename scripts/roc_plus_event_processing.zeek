module ROC_PLUS;

event ROC_PLUS::UDP_MessagesEvt(c: connection, is_orig: bool, udpMessages: ROC_PLUS::UDP_Messages) {
    for (i in udpMessages$rocMessage) {
        # Set sesssion rocplus log object
        c = set_roc_plus_log(c);

        # Process the UDP msg
        c = process_message_udp(c, c$roc_plus_log, udpMessages$rocMessage[i]);
    
        # Fire the event and tidy up
        ROC_PLUS::emit_roc_plus_log(c);
        delete c$roc_plus_log;
    }
}

# event ROC_PLUS::TCP_MessagesEvt(c: connection, is_orig: bool, tcpMessages: ROC_PLUS::TCP_Messages) {
#     for (i in tcpMessages$rocMessageTCP) {
#         # Set sesssion rocplus log object
#         c = set_roc_plus_log(c);

#         # Process the UDP msg
#         # c = process_message_tcp(c, c$roc_plus_log, tcpMessages$rocMessageTCP[i]);
    
#         # Fire the event and tidy up
#         ROC_PLUS::emit_roc_plus_log(c);
#         delete c$roc_plus_log;
#     }
# }
