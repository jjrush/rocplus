module ROC_PLUS;

function process_srbx_signal(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {
    c = set_srbx_signal_log(c);
    local log = c$roc_plus_srbx_signal_log;

    log$roc_plus_link_id = link_id;

}