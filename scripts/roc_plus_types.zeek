module ROC_PLUS;

export {
        type roc_plus_log: record {
        ts                : time    &log;
        uid               : string  &log;
        id                : conn_id &log;
        protocol          : transport_proto &log;
        roc_plus_link_id  : string  &log &optional;

        packet_type       : string  &log &optional;

        # ROC Plus Header ############################
        destination_unit  : count   &log &optional;
        destination_group : count   &log &optional;
        source_unit       : count   &log &optional;
        source_group      : count   &log &optional;
        opcode            : string  &log &optional;
        data_length       : count   &log &optional;

        lsb_crc           : count   &log &optional; # least significant byte
        msb_crc           : count   &log &optional; # most signfiicant byte
        ##############################################

        error_code        : vector of string &log &optional;
        error_offset      : vector of count  &log &optional;
    };

    type roc_plus_sys_cfg_log: record {
        ts                         : time    &log;
        uid                        : string  &log;
        id                         : conn_id &log;
        roc_plus_link_id           : string  &log &optional;

        system_mode                  : string &log &optional;
        port_number                  : count  &log &optional;
        security_access_mode         : count  &log &optional;
        logical_compatability_status : string &log &optional;
        opcode_revision              : string &log &optional;
        subtype                      : string &log &optional;
        type_of_roc                  : string &log &optional;

        point_types                  : vector of count &log &optional;
    };

    # Opcode 105
    type roc_plus_historical_min_max_vals_log: record {
        ts                             : time    &log;
        uid                            : string  &log;
        id                             : conn_id &log;
        roc_plus_link_id               : string  &log &optional;

        # request
        history_segment               : count &log &optional; # Re-use for response
        historical_point_number       : count &log &optional; # Re-use for response

        # Response
        historical_archival_method         : count  &log &optional;
        point_type                         : count  &log &optional;
        point_logic_number                 : count  &log &optional;
        parameter_number                   : count  &log &optional;
        current_value                      : count  &log &optional;
        minimum_value_since_contract       : count  &log &optional;
        maximum_value_since_contract       : count  &log &optional;
        time_of_min_value_occurrence       : time   &log &optional;
        time_of_max_value_occurrence       : time   &log &optional;
        minimum_value_yesterday            : count  &log &optional;
        maximum_value_yesterday            : count  &log &optional;
        time_of_yesterday_min_value        : time   &log &optional;
        time_of_yesterday_max_value        : time   &log &optional;
        value_during_last_completed_period : count  &log &optional;
    };

    type roc_plus_realtime_clock_log: record {
        ts                  : time    &log;
        uid                 : string  &log;
        id                  : conn_id &log;
        roc_plus_link_id    : string  &log &optional;

        ######### Opcode 7 - Read Real-time Clock
        ######### Opcode 8 - Set Real-time Clock

        # Response (request is empty)
        current_second      : count  &log &optional; # Re-use for opcode 8
        current_minute      : count  &log &optional; # Re-use for opcode 8
        current_hour        : count  &log &optional; # Re-use for opcode 8
        current_day         : count  &log &optional; # Re-use for opcode 8
        current_month       : count  &log &optional; # Re-use for opcode 8
        current_year        : count  &log &optional; # Re-use for opcode 8
        current_day_of_week : string &log &optional;
        timestamp           : time &log &optional;
    };

    type roc_plus_configurable_opcode_log: record {
        ts               : time    &log;
        uid              : string  &log;
        id               : conn_id &log;
        roc_plus_link_id : string  &log &optional;

        ######### Opcode 10 - Read Configurable Opcode Point Data

        # Request
        table_number            : count &log &optional; # Re-use for response and opcode 11
        starting_table_location : count &log &optional; # Re-use for response and opcode 11
        num_table_locations     : count &log &optional; # Re-use for response and opcode 11

        # Response
        table_version_number    : count  &log &optional;
        data                    : string &log &optional; # Re-use for opcode 11

        ######### Opcode 11 - Write Configurable Opcode Point Data

        # Request (response has no data)
        # table_number            : count  &log &optional;
        # starting_table_location : count  &log &optional;
        # num_table_locations     : count  &log &optional;
        # data                    : string &log &optional;
    };

    type roc_plus_login_log: record {
        ts               : time    &log;
        uid              : string  &log;
        id               : conn_id &log;
        roc_plus_link_id : string  &log &optional;

        operator_id      : string &log &optional;
        password         : string &log &optional;
        access_level     : count &log &optional;
        logout_string    : string &log &optional;

        # Session Key
        session_key_string  : string &log &optional;
        wrapped_session_key : string &log &optional;
    };

    type roc_plus_store_and_forward_log: record {
        ts               : time    &log;
        uid              : string  &log;
        id               : conn_id &log;
        roc_plus_link_id : string  &log &optional;

        # Request fields
        host_address     : count  &log &optional;
        host_group       : count  &log &optional;
        dest1_address    : count  &log &optional;
        dest1_group      : count  &log &optional;
        dest2_address    : count  &log &optional;
        dest2_group      : count  &log &optional;
        dest3_address    : count  &log &optional;
        dest3_group      : count  &log &optional;
        dest4_address    : count  &log &optional;
        dest4_group      : count  &log &optional;
        desired_opcode   : count  &log &optional;
        num_data_bytes   : count  &log &optional;
        opcode_data      : string &log &optional;
    };

    type roc_plus_data_request_log: record {
        ts               : time    &log;
        uid              : string  &log;
        id               : conn_id &log;
        roc_plus_link_id : string  &log &optional;

        ### Opcode 050 ### 
        # Request
        io_data_req      : string &log &optional;

        # Response
        io_data          : string &log &optional;
        ##################

        ### Opcode 108 ###
        # Request
        history_segment   : count &log &optional; # Re-used for response and opcodes 137 and 138 
        num_points        : count &log &optional; # Re-used for response
        historical_points : vector of string &log &optional; # Re-used for response

        # Response
        periodic_index    : count &log &optional;
        tag               : string &log &optional;
        ##################

        ### Opcode 118 ###
        # Request
        num_alarms             : count &log &optional; # Re-used for response
        starting_alarm_log_idx : count &log &optional; # Re-used for response

        # Response
        current_alarm_log_idx  : count &log &optional;  # Re-used for opcode 119 response
        alarm_data             : vector of string &log &optional;
        ##################

        ### Opcode 119 ###
        # Request
        num_events_req         : count &log &optional;
        starting_event_log_idx : count &log &optional;  # Re-used for response

        # Response
        num_events_sent        : count &log &optional;
        current_event_log_idx  : count &log &optional;
        event_data             : vector of string &log &optional;
        ##################

        ### Opcode 137 ###
        # Request
        day_requested         : count &log &optional; # Re-use for opcode 138
        month_requested       : count &log &optional; # Re-use for opcode 138

        # Response
        starting_periodic_idx : count &log &optional; # Re-use for opcode 138
        num_periodic_entries  : count &log &optional; # Re-use for opcode 138
        daily_index           : count &log &optional; # Re-use for opcode 138
        num_daily_entries     : count &log &optional; # Re-use for opcode 138
        ##################

        ### Opcode 138 ###
        # Request
        history_point     : count &log &optional; # Re-use for response

        # Response
        periodic_values      : vector of count &log &optional;
        daily_values         : vector of count &log &optional;  
        ##################
    };

    # Opcode 100
    type roc_plus_user_defined_info_log: record {
        ts               : time    &log;
        uid              : string  &log;
        id               : conn_id &log;
        roc_plus_link_id : string  &log &optional;

        # Request
        command     : count  &log &optional; # Re-use for response
        start_point : count  &log &optional; # Re-use for response
        num_points  : count  &log &optional; # Re-use for response

        point_types : vector of string &log &optional;
    };

    type roc_plus_single_point_parameters_log: record {
        ts               : time    &log;
        uid              : string  &log;
        id               : conn_id &log;
        roc_plus_link_id : string  &log &optional;

        ### Opcode 166 & 167 ###
        # Request
        point_type          : count  &log &optional; # Re-use all of these for Opcode 167
        point_logic_number  : count  &log &optional;
        num_parameters      : count  &log &optional;
        start_parameter_num : count  &log &optional;
        parameter_data      : string &log &optional;
    };

    # Opcode 203
    type roc_plus_file_transfer_log: record {
        ts               : time    &log;
        uid              : string  &log;
        id               : conn_id &log;
        roc_plus_link_id : string  &log &optional;

        command          : string &log &optional; # The command type (OPEN, READ, etc)
        
        # Open Command fields
        open_options    : string &log &optional;
        path            : string &log &optional;
        filename        : string &log &optional;
        file_descriptor : count  &log &optional;

        # Read/Write fields
        offset          : count  &log &optional;
        file_size       : count  &log &optional;
        num_bytes       : count  &log &optional;
        data            : string &log &optional;

        # Read Directory fields
        additional_files : count  &log &optional;
        total_num_files  : count  &log &optional;
        file_names       : vector of string &log &optional;
    };

    # Opcode 206
    type roc_plus_transaction_history_log: record {
        ts               : time    &log;
        uid              : string  &log;
        id               : conn_id &log;
        roc_plus_link_id : string  &log &optional;

        # List Request
        command            : string &log &optional; # Re-use
        segment            : count  &log &optional; # Re-use
        transaction_offset : count  &log &optional;

        # Read Request
        # command            : string &log &optional; 
        # segment            : count  &log &optional;
        transaction_number : count &log &optional;
        data_offset        : count &log &optional;

        # List Response
        # command            : string &log &optional;
        num_transactions   : count &log &optional;
        more_data          : bool &log &optional; # Re-use
        description        : string &log &optional;
        payload_size       : count &log &optional;
        transaction_num    : vector of count &log &optional;
        date_created       : vector of count &log &optional;

        # Read Response
        # command            : string &log &optional; 
        msg_data_size      : count &log &optional;
        # more_data          : string &log &optional;
        data_type          : vector of string &log &optional;
        data               : vector of count &log &optional;
    };

    type roc_plus_unknown_data_log: record {
        ts               : time    &log;
        uid              : string  &log;
        id               : conn_id &log;
        roc_plus_link_id : string  &log &optional;

        # Raw data bytes for opcodes that are unparse-able
        data             : string &log &optional;
    };

    #Opcodes 135 & 136
    type roc_plus_history_point_data_log: record {
        ts                                  : time &log;
        uid                                 : string &log;
        id                                  : conn_id &log;
        roc_plus_link_id                    : string  &log &optional;

        history_segment                     : count &log &optional;
        point_number                        : count &log &optional;

        type_of_history                     : string &log &optional;
        history_segment_index               : count &log &optional;
        num_values_requested                : count &log &optional;
        current_history_segment_index       : count &log &optional;
        num_values_sent                     : count &log &optional;
        starting_history_point              : count &log &optional;
        num_history_points                  : count &log &optional;
        num_time_periods                    : count &log &optional;
        num_data_elements_sent              : count &log &optional;
        history_timestamps                  : vector of time &log &optional;
        history_values                      : vector of count &log &optional;
    };

    # Opcode 139
    type roc_plus_history_information_log: record {
        ts                              : time &log;
        uid                             : string &log;
        id                              : conn_id &log;
        roc_plus_link_id                : string  &log &optional;

        # Common
        command                         : string &log &optional;
        history_segment                 : count &log &optional;
        history_segment_index           : count &log &optional;

        # Specified Point Data Request
        current_index                   : count &log &optional;
        type_of_history                 : string &log &optional;
        num_time_periods                : count &log &optional;
        request_timestamps              : count &log &optional;
        num_points                      : count &log &optional;
        requested_history_points        : vector of count &log &optional;

        # Configured Points Response
        num_configured_points           : count &log &optional;
        configured_points               : vector of count &log &optional;
    };

    #Opcode 139
    type roc_plus_time_period_history_points_log: record {
        ts                                  : time &log;
        uid                                 : string &log;
        id                                  : conn_id &log;

        roc_plus_link_id                    : string  &log &optional;
        timestamp_for_index                 : time &log &optional;
        history_point_values                : vector of count &log &optional;
    };


    #Opcode 205
    type roc_plus_peer_to_peer_network_messages_log: record {
        ts                                  : time &log;
        uid                                 : string &log;
        id                                  : conn_id &log;
        roc_plus_link_id                    : string  &log &optional;

        network_id                          : count &log &optional;
        commissioned_index_one_based        : count &log &optional;
        embedded_roc_opcode                 : count &log &optional;
        embedded_request_length             : count &log &optional;
        embedded_request_data               : string &log &optional;
        embedded_response_length            : count &log &optional;
        embedded_request_data_response      : string &log &optional;
    };
}