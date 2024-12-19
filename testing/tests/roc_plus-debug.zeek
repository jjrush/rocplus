# @TEST-EXEC: touch roc_plus_log.log
# @TEST-EXEC: touch roc_plus_configurable_opcode_log.log

# @TEST-EXEC: zeek -C -r ${TRACES}/rocplus_traffic_test_opcode_10.pcap local Reporter::debug=T ${PACKAGE} %INPUT > debug.log 2>&1

# @TEST-EXEC: test -e roc_plus_log.log || echo "roc_plus_log.log was not created" > debug.log
# @TEST-EXEC: test -e roc_plus_configurable_opcode_log.log || echo "roc_plus_configurable_opcode_log.log was not created" >> debug.log
# @TEST-EXEC: test -s roc_plus_log.log || echo "roc_plus_log.log is empty" >> debug.log
# @TEST-EXEC: test -s roc_plus_configurable_opcode_log.log || echo "roc_plus_configurable_opcode_log.log is empty" >> debug.log

# @TEST-EXEC: zeek-cut -n uid roc_plus_link_id < roc_plus_configurable_opcode_log.log > log.tmp && mv log.tmp roc_plus_configurable_opcode_log.log
# @TEST-EXEC: zeek-cut -n uid roc_plus_link_id < roc_plus_log.log > log.tmp && mv log.tmp roc_plus_log.log

# @TEST-EXEC: btest-diff roc_plus_log.log
# @TEST-EXEC: btest-diff roc_plus_configurable_opcode_log.log
# @TEST-EXEC: btest-diff debug.log

# @TEST-DOC: Test rocplus analyzer with rocplus_traffic_test_opcode_10.pcap