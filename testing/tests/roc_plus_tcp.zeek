# @TEST-EXEC: touch roc_plus.log
# @TEST-EXEC: touch roc_plus_sys_cfg.log
# @TEST-EXEC: touch roc_plus_historical_min_max_vals.log
# @TEST-EXEC: touch roc_plus_realtime_clock.log
# @TEST-EXEC: touch roc_plus_configurable_opcode.log
# @TEST-EXEC: touch roc_plus_login.log
# @TEST-EXEC: touch roc_plus_store_and_forward.log
# @TEST-EXEC: touch roc_plus_data_request.log
# @TEST-EXEC: touch roc_plus_user_defined_info.log
# @TEST-EXEC: touch roc_plus_single_point_parameters.log
# @TEST-EXEC: touch roc_plus_file_transfer.log
# @TEST-EXEC: touch roc_plus_transaction_history.log
# @TEST-EXEC: touch roc_plus_unknown_data.log
# @TEST-EXEC: touch roc_plus_history_point_data.log
# @TEST-EXEC: touch roc_plus_history_information.log
# @TEST-EXEC: touch roc_plus_time_period_history_points.log
# @TEST-EXEC: touch roc_plus_peer_to_peer_network_messages.log
#
# @TEST-EXEC: zeek -C -r ${TRACES}/all_opcodes_tcp.pcap ${PACKAGE} %INPUT
#
# @TEST-EXEC: zeek-cut -n uid ts roc_plus_link_id < roc_plus.log > log.tmp && mv log.tmp roc_plus.log
# @TEST-EXEC: zeek-cut -n uid ts roc_plus_link_id < roc_plus_sys_cfg.log > log.tmp && mv log.tmp roc_plus_sys_cfg.log
# @TEST-EXEC: zeek-cut -n uid ts roc_plus_link_id < roc_plus_historical_min_max_vals.log > log.tmp && mv log.tmp roc_plus_historical_min_max_vals.log
# @TEST-EXEC: zeek-cut -n uid ts roc_plus_link_id < roc_plus_realtime_clock.log > log.tmp && mv log.tmp roc_plus_realtime_clock.log
# @TEST-EXEC: zeek-cut -n uid ts roc_plus_link_id < roc_plus_configurable_opcode.log > log.tmp && mv log.tmp roc_plus_configurable_opcode.log
# @TEST-EXEC: zeek-cut -n uid ts roc_plus_link_id < roc_plus_login.log > log.tmp && mv log.tmp roc_plus_login.log
# @TEST-EXEC: zeek-cut -n uid ts roc_plus_link_id < roc_plus_store_and_forward.log > log.tmp && mv log.tmp roc_plus_store_and_forward.log
# @TEST-EXEC: zeek-cut -n uid ts roc_plus_link_id < roc_plus_data_request.log > log.tmp && mv log.tmp roc_plus_data_request.log
# @TEST-EXEC: zeek-cut -n uid ts roc_plus_link_id < roc_plus_user_defined_info.log > log.tmp && mv log.tmp roc_plus_user_defined_info.log
# @TEST-EXEC: zeek-cut -n uid ts roc_plus_link_id < roc_plus_single_point_parameters.log > log.tmp && mv log.tmp roc_plus_single_point_parameters.log
# @TEST-EXEC: zeek-cut -n uid ts roc_plus_link_id < roc_plus_file_transfer.log > log.tmp && mv log.tmp roc_plus_file_transfer.log
# @TEST-EXEC: zeek-cut -n uid ts roc_plus_link_id < roc_plus_transaction_history.log > log.tmp && mv log.tmp roc_plus_transaction_history.log
# @TEST-EXEC: zeek-cut -n uid ts roc_plus_link_id < roc_plus_unknown_data.log > log.tmp && mv log.tmp roc_plus_unknown_data.log
# @TEST-EXEC: zeek-cut -n uid ts roc_plus_link_id < roc_plus_history_point_data.log > log.tmp && mv log.tmp roc_plus_history_point_data.log
# @TEST-EXEC: zeek-cut -n uid ts roc_plus_link_id < roc_plus_history_information.log > log.tmp && mv log.tmp roc_plus_history_information.log
# @TEST-EXEC: zeek-cut -n uid ts roc_plus_link_id < roc_plus_time_period_history_points.log > log.tmp && mv log.tmp roc_plus_time_period_history_points.log
# @TEST-EXEC: zeek-cut -n uid ts roc_plus_link_id < roc_plus_peer_to_peer_network_messages.log > log.tmp && mv log.tmp roc_plus_peer_to_peer_network_messages.log
#
# @TEST-EXEC: btest-diff roc_plus_sys_cfg.log
# @TEST-EXEC: btest-diff roc_plus_historical_min_max_vals.log
# @TEST-EXEC: btest-diff roc_plus_realtime_clock.log
# @TEST-EXEC: btest-diff roc_plus_configurable_opcode.log
# @TEST-EXEC: btest-diff roc_plus_login.log
# @TEST-EXEC: btest-diff roc_plus_store_and_forward.log
# @TEST-EXEC: btest-diff roc_plus_data_request.log
# @TEST-EXEC: btest-diff roc_plus_user_defined_info.log
# @TEST-EXEC: btest-diff roc_plus_single_point_parameters.log
# @TEST-EXEC: btest-diff roc_plus_file_transfer.log
# @TEST-EXEC: btest-diff roc_plus_transaction_history.log
# @TEST-EXEC: btest-diff roc_plus_unknown_data.log
# @TEST-EXEC: btest-diff roc_plus_history_point_data.log
# @TEST-EXEC: btest-diff roc_plus_history_information.log
# @TEST-EXEC: btest-diff roc_plus_time_period_history_points.log
# @TEST-EXEC: btest-diff roc_plus_peer_to_peer_network_messages.log
#
# @TEST-DOC: Test rocplus analyzer with all_opcodes_tcp.pcap