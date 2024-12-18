## main.zeek
##
## ICSNPP-ROC_PLUS
##
## Zeek script type/record definitions describing the information
## that will be written to the log files.
##

module ROC_PLUS;

export {
    const roc_plus_ports_udp: set[port] = { 4000/udp } &redef;
    # const roc_plus_ports_tcp: set[port] = { 4000/tcp } &redef;

    redef enum Log::ID += { LOG_ROC_PLUS_LOG, 
                            LOG_ROC_PLUS_SYS_CFG_LOG,
                            LOG_ROC_PLUS_HISTORICAL_MIN_MAX_VALS_LOG,
                            LOG_ROC_PLUS_REALTIME_CLOCK_LOG,
                            LOG_ROC_PLUS_CONFIGURABLE_OPCODE_LOG,
                            LOG_ROC_PLUS_LOGIN_LOG,
                            LOG_ROC_PLUS_STORE_AND_FORWARD_LOG,
                            LOG_ROC_PLUS_DATA_REQUEST_LOG,
                            LOG_ROC_PLUS_USER_DEFINED_INFO_LOG,
                            LOG_ROC_PLUS_SINGLE_POINT_PARAMETERS_LOG,
                            LOG_ROC_PLUS_FILE_TRANSFER_LOG,
                            LOG_ROC_PLUS_TRANSACTION_HISTORY_LOG };

    # Callback event for integrating with the file analysis framework
    global get_file_handle: function(c: connection, is_orig: bool): string;

    # Log policies for log filtering
    global log_policy_roc_plus: Log::PolicyHook;
    global log_policy_roc_plus_sys_cfg: Log::PolicyHook;
    global log_policy_roc_plus_historical_min_max_vals: Log::PolicyHook;
    global log_policy_roc_plus_realtime_clock: Log::PolicyHook;
    global log_policy_roc_plus_configurable_opcode: Log::PolicyHook;
    global log_policy_roc_plus_login: Log::PolicyHook;
    global log_policy_roc_plus_store_and_forward: Log::PolicyHook;
    global log_policy_roc_plus_data_request: Log::PolicyHook;
    global log_policy_roc_plus_user_defined_info: Log::PolicyHook;
    global log_policy_roc_plus_single_point_parameters: Log::PolicyHook;
    global log_policy_roc_plus_file_transfer: Log::PolicyHook;
    global log_policy_roc_plus_transaction_history: Log::PolicyHook;

    global log_roc_plus_log: event(rec: roc_plus_log);
    global log_roc_plus_sys_cfg_log: event(rec: roc_plus_sys_cfg_log);
    global log_roc_plus_historical_min_max_vals_log: event(rec: roc_plus_historical_min_max_vals_log);
    global log_roc_plus_realtime_clock_log: event(rec: roc_plus_realtime_clock_log);
    global log_roc_plus_configurable_opcode_log: event(rec: roc_plus_configurable_opcode_log);
    global log_roc_plus_login_log: event(rec: roc_plus_login_log);
    global log_roc_plus_store_and_forward_log: event(rec: roc_plus_store_and_forward_log);
    global log_roc_plus_data_request_log: event(rec: roc_plus_data_request_log);
    global log_roc_plus_user_defined_info_log: event(rec: roc_plus_user_defined_info_log);
    global log_roc_plus_single_point_parameters_log: event(rec: roc_plus_single_point_parameters_log);
    global log_roc_plus_file_transfer_log: event(rec: roc_plus_file_transfer_log);
    global log_roc_plus_transaction_history_log: event(rec: roc_plus_transaction_history_log);

    global emit_roc_plus_log: function(c: connection);
    global emit_roc_plus_sys_cfg_log: function(c: connection);
    global emit_roc_plus_historical_min_max_vals_log: function(c: connection);
    global emit_roc_plus_realtime_clock_log: function(c: connection);
    global emit_roc_plus_configurable_opcode_log: function(c: connection);
    global emit_roc_plus_login_log: function(c: connection);
    global emit_roc_plus_store_and_forward_log: function(c: connection);
    global emit_roc_plus_data_request_log: function(c: connection);
    global emit_roc_plus_user_defined_info_log: function(c: connection);
    global emit_roc_plus_single_point_parameters_log: function(c: connection);
    global emit_roc_plus_file_transfer_log: function(c: connection);
    global emit_roc_plus_transaction_history_log: function(c: connection); 
}

# redefine connection record to contain one of each of the ROC_PLUS records
redef record connection += {
    roc_plus_protocol: string &optional;
    roc_plus_log: roc_plus_log &optional;
    roc_plus_sys_cfg_log: roc_plus_sys_cfg_log  &optional;
    roc_plus_historical_min_max_vals_log: roc_plus_historical_min_max_vals_log  &optional;
    roc_plus_realtime_clock_log: roc_plus_realtime_clock_log  &optional;
    roc_plus_configurable_opcode_log: roc_plus_configurable_opcode_log &optional;
    roc_plus_login_log: roc_plus_login_log &optional;
    roc_plus_store_and_forward_log: roc_plus_store_and_forward_log &optional;
    roc_plus_data_request_log: roc_plus_data_request_log &optional;
    roc_plus_user_defined_info_log: roc_plus_user_defined_info_log &optional;
    roc_plus_single_point_parameters_log: roc_plus_single_point_parameters_log &optional;
    roc_plus_file_transfer_log: roc_plus_file_transfer_log &optional;
    roc_plus_transaction_history_log: roc_plus_transaction_history_log &optional;
};

redef likely_server_ports += { roc_plus_ports_udp };

#Put protocol detection information here
event zeek_init() &priority=5 {

    # register with the file analysis framework
    Files::register_protocol(Analyzer::ANALYZER_ROC_PLUS_UDP,
                            [$get_file_handle = ROC_PLUS::get_file_handle]);
    # Files::register_protocol(Analyzer::ANALYZER_ROC_PLUS_TCP,
    #                         [$get_file_handle = ROC_PLUS::get_file_handle]);

    Analyzer::register_for_ports(Analyzer::ANALYZER_ROC_PLUS_UDP, roc_plus_ports_udp);
    # Analyzer::register_for_ports(Analyzer::ANALYZER_ROC_PLUS_TCP, roc_plus_ports_tcp);

    # initialize logging streams for all ROC_PLUS logs
    Log::create_stream(ROC_PLUS::LOG_ROC_PLUS_LOG,
                      [$columns=roc_plus_log,
                      $ev=log_roc_plus_log,
                      $path="roc_plus",
                      $policy=log_policy_roc_plus]);

    Log::create_stream(ROC_PLUS::LOG_ROC_PLUS_SYS_CFG_LOG,
                      [$columns=roc_plus_sys_cfg_log,
                      $ev=log_roc_plus_sys_cfg_log,
                      $path="roc_plus_sys_cfg",
                      $policy=log_policy_roc_plus_sys_cfg]);

    Log::create_stream(ROC_PLUS::LOG_ROC_PLUS_HISTORICAL_MIN_MAX_VALS_LOG,
                      [$columns=roc_plus_historical_min_max_vals_log,
                      $ev=log_roc_plus_historical_min_max_vals_log,
                      $path="roc_plus_historical_min_max_vals",
                      $policy=log_policy_roc_plus_historical_min_max_vals]);

    Log::create_stream(ROC_PLUS::LOG_ROC_PLUS_REALTIME_CLOCK_LOG,
                      [$columns=roc_plus_realtime_clock_log,
                      $ev=log_roc_plus_realtime_clock_log,
                      $path="roc_plus_realtime_clock",
                      $policy=log_policy_roc_plus_realtime_clock]);

    Log::create_stream(ROC_PLUS::LOG_ROC_PLUS_CONFIGURABLE_OPCODE_LOG,
                      [$columns=roc_plus_configurable_opcode_log,
                      $ev=log_roc_plus_configurable_opcode_log,
                      $path="roc_plus_configurable_opcode",
                      $policy=log_policy_roc_plus_configurable_opcode]);

    Log::create_stream(ROC_PLUS::LOG_ROC_PLUS_LOGIN_LOG,
                      [$columns=roc_plus_login_log,
                      $ev=log_roc_plus_login_log,
                      $path="roc_plus_login",
                      $policy=log_policy_roc_plus_login]);

    Log::create_stream(ROC_PLUS::LOG_ROC_PLUS_STORE_AND_FORWARD_LOG,
                      [$columns=roc_plus_store_and_forward_log,
                      $ev=log_roc_plus_store_and_forward_log,
                      $path="roc_plus_store_and_forward",
                      $policy=log_policy_roc_plus_store_and_forward]);

    Log::create_stream(ROC_PLUS::LOG_ROC_PLUS_DATA_REQUEST_LOG,
                      [$columns=roc_plus_data_request_log,
                      $ev=log_roc_plus_data_request_log,
                      $path="roc_plus_data_request",
                      $policy=log_policy_roc_plus_data_request]);

    Log::create_stream(ROC_PLUS::LOG_ROC_PLUS_USER_DEFINED_INFO_LOG,
                      [$columns=roc_plus_user_defined_info_log,
                      $ev=log_roc_plus_user_defined_info_log,
                      $path="roc_plus_user_defined_info",
                      $policy=log_policy_roc_plus_user_defined_info]);

    Log::create_stream(ROC_PLUS::LOG_ROC_PLUS_SINGLE_POINT_PARAMETERS_LOG,
                      [$columns=roc_plus_single_point_parameters_log,
                      $ev=log_roc_plus_single_point_parameters_log,
                      $path="roc_plus_single_point_parameters",
                      $policy=log_policy_roc_plus_single_point_parameters]);

    Log::create_stream(ROC_PLUS::LOG_ROC_PLUS_FILE_TRANSFER_LOG,
                      [$columns=roc_plus_file_transfer_log,
                      $ev=log_roc_plus_file_transfer_log,
                      $path="roc_plus_file_transfer",
                      $policy=log_policy_roc_plus_file_transfer]);

    Log::create_stream(ROC_PLUS::LOG_ROC_PLUS_TRANSACTION_HISTORY_LOG,
                      [$columns=roc_plus_transaction_history_log,
                      $ev=log_roc_plus_transaction_history_log,
                      $path="roc_plus_transaction_history",
                      $policy=log_policy_roc_plus_transaction_history]);
}

function emit_roc_plus_log(c: connection) {
    if (! c?$roc_plus_log )
        return;
    if ( c?$roc_plus_protocol )
        c$roc_plus_log$protocol = c$roc_plus_protocol;
    Log::write(ROC_PLUS::LOG_ROC_PLUS_LOG, c$roc_plus_log);
}

function emit_roc_plus_sys_cfg_log(c: connection) {
    if (! c?$roc_plus_sys_cfg_log )
        return;
    if ( c?$roc_plus_protocol )
        c$roc_plus_log$protocol = c$roc_plus_protocol;
    Log::write(ROC_PLUS::LOG_ROC_PLUS_SYS_CFG_LOG, c$roc_plus_sys_cfg_log);
}

function emit_roc_plus_historical_min_max_vals_log(c: connection) {
    if (! c?$roc_plus_historical_min_max_vals_log )
        return;
    if ( c?$roc_plus_protocol )
        c$roc_plus_log$protocol = c$roc_plus_protocol;
    Log::write(ROC_PLUS::LOG_ROC_PLUS_HISTORICAL_MIN_MAX_VALS_LOG, c$roc_plus_historical_min_max_vals_log);
}

function emit_roc_plus_realtime_clock_log(c: connection) {
    if (! c?$roc_plus_realtime_clock_log )
        return;
    if ( c?$roc_plus_protocol )
        c$roc_plus_log$protocol = c$roc_plus_protocol;
    Log::write(ROC_PLUS::LOG_ROC_PLUS_REALTIME_CLOCK_LOG, c$roc_plus_realtime_clock_log);
}

function emit_roc_plus_configurable_opcode_log(c: connection) {
    if (! c?$roc_plus_configurable_opcode_log )
        return;
    if ( c?$roc_plus_protocol )
        c$roc_plus_log$protocol = c$roc_plus_protocol;
    Log::write(ROC_PLUS::LOG_ROC_PLUS_CONFIGURABLE_OPCODE_LOG, c$roc_plus_configurable_opcode_log);
}

function emit_roc_plus_login_log(c: connection) {
    if (! c?$roc_plus_login_log )
        return;
    if ( c?$roc_plus_protocol )
        c$roc_plus_log$protocol = c$roc_plus_protocol;
    Log::write(ROC_PLUS::LOG_ROC_PLUS_LOGIN_LOG, c$roc_plus_login_log);
}

function emit_roc_plus_store_and_forward_log(c: connection) {
    if (! c?$roc_plus_store_and_forward_log )
        return;
    if ( c?$roc_plus_protocol )
        c$roc_plus_log$protocol = c$roc_plus_protocol;
    Log::write(ROC_PLUS::LOG_ROC_PLUS_STORE_AND_FORWARD_LOG, c$roc_plus_store_and_forward_log);
}

function emit_roc_plus_data_request_log(c: connection) {
    if (! c?$roc_plus_data_request_log )
        return;
    if ( c?$roc_plus_protocol )
        c$roc_plus_log$protocol = c$roc_plus_protocol;
    Log::write(ROC_PLUS::LOG_ROC_PLUS_DATA_REQUEST_LOG, c$roc_plus_data_request_log);
}

function emit_roc_plus_user_defined_info_log(c: connection) {
    if (! c?$roc_plus_user_defined_info_log )
        return;
    if ( c?$roc_plus_protocol )
        c$roc_plus_log$protocol = c$roc_plus_protocol;
    Log::write(ROC_PLUS::LOG_ROC_PLUS_USER_DEFINED_INFO_LOG, c$roc_plus_user_defined_info_log);
}

function emit_roc_plus_single_point_parameters_log(c: connection) {
    if (! c?$roc_plus_single_point_parameters_log )
        return;
    if ( c?$roc_plus_protocol )
        c$roc_plus_log$protocol = c$roc_plus_protocol;
    Log::write(ROC_PLUS::LOG_ROC_PLUS_SINGLE_POINT_PARAMETERS_LOG, c$roc_plus_single_point_parameters_log);
}

function emit_roc_plus_file_transfer_log(c: connection) {
    if (! c?$roc_plus_file_transfer_log )
        return;
    if ( c?$roc_plus_protocol )
        c$roc_plus_log$protocol = c$roc_plus_protocol;
    Log::write(ROC_PLUS::LOG_ROC_PLUS_FILE_TRANSFER_LOG, c$roc_plus_file_transfer_log);
}

function emit_roc_plus_transaction_history_log(c: connection) {
    if (! c?$roc_plus_transaction_history_log )
        return;
    if ( c?$roc_plus_protocol )
        c$roc_plus_log$protocol = c$roc_plus_protocol;
    Log::write(ROC_PLUS::LOG_ROC_PLUS_TRANSACTION_HISTORY_LOG, c$roc_plus_transaction_history_log);
}

# 
# A simple get_file_handle implementation taken from the main.zeek script
# generated using command:
#     zkg create --feature spicy-protocol-analyzer --packagedir my_protocol
#
function get_file_handle(c: connection, is_orig: bool): string {
    return cat(Analyzer::ANALYZER_ROC_PLUS_UDP, c$start_time, c$id, is_orig, c$orig);
}
