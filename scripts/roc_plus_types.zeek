module ROC_PLUS;

export {
        type roc_plus_log: record {
        ts                : time    &log;
        uid               : string  &log;
        id                : conn_id &log;
        protocol          : string  &log;
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

        point_type_060 : count &log &optional;
        point_type_061 : count &log &optional;
        point_type_062 : count &log &optional;
        point_type_063 : count &log &optional;
        point_type_064 : count &log &optional;
        point_type_065 : count &log &optional;
        point_type_066 : count &log &optional;
        point_type_067 : count &log &optional;
        point_type_068 : count &log &optional;
        point_type_069 : count &log &optional;

        point_type_070 : count &log &optional;
        point_type_071 : count &log &optional;
        point_type_072 : count &log &optional;
        point_type_073 : count &log &optional;
        point_type_074 : count &log &optional;
        point_type_075 : count &log &optional;
        point_type_076 : count &log &optional;
        point_type_077 : count &log &optional;
        point_type_078 : count &log &optional;
        point_type_079 : count &log &optional;

        point_type_080 : count &log &optional;
        point_type_081 : count &log &optional;
        point_type_082 : count &log &optional;
        point_type_083 : count &log &optional;
        point_type_084 : count &log &optional;
        point_type_085 : count &log &optional;
        point_type_086 : count &log &optional;
        point_type_087 : count &log &optional;
        point_type_088 : count &log &optional;
        point_type_089 : count &log &optional;

        point_type_090 : count &log &optional;
        point_type_091 : count &log &optional;
        point_type_092 : count &log &optional;
        point_type_093 : count &log &optional;
        point_type_094 : count &log &optional;
        point_type_095 : count &log &optional;
        point_type_096 : count &log &optional;
        point_type_097 : count &log &optional;
        point_type_098 : count &log &optional;
        point_type_099 : count &log &optional;

        point_type_100 : count &log &optional;
        point_type_101 : count &log &optional;
        point_type_102 : count &log &optional;
        point_type_103 : count &log &optional;
        point_type_104 : count &log &optional;
        point_type_105 : count &log &optional;
        point_type_106 : count &log &optional;
        point_type_107 : count &log &optional;
        point_type_108 : count &log &optional;
        point_type_109 : count &log &optional;

        point_type_110 : count &log &optional;
        point_type_111 : count &log &optional;
        point_type_112 : count &log &optional;
        point_type_113 : count &log &optional;
        point_type_114 : count &log &optional;
        point_type_115 : count &log &optional;
        point_type_116 : count &log &optional;
        point_type_117 : count &log &optional;
        point_type_118 : count &log &optional;
        point_type_119 : count &log &optional;

        point_type_120 : count &log &optional;
        point_type_121 : count &log &optional;
        point_type_122 : count &log &optional;
        point_type_123 : count &log &optional;
        point_type_124 : count &log &optional;
        point_type_125 : count &log &optional;
        point_type_126 : count &log &optional;
        point_type_127 : count &log &optional;
        point_type_128 : count &log &optional;
        point_type_129 : count &log &optional;

        point_type_130 : count &log &optional;
        point_type_131 : count &log &optional;
        point_type_132 : count &log &optional;
        point_type_133 : count &log &optional;
        point_type_134 : count &log &optional;
        point_type_135 : count &log &optional;
        point_type_136 : count &log &optional;
        point_type_137 : count &log &optional;
        point_type_138 : count &log &optional;
        point_type_139 : count &log &optional;

        point_type_140 : count &log &optional;
        point_type_141 : count &log &optional;
        point_type_142 : count &log &optional;
        point_type_143 : count &log &optional;
        point_type_144 : count &log &optional;
        point_type_145 : count &log &optional;
        point_type_146 : count &log &optional;
        point_type_147 : count &log &optional;
        point_type_148 : count &log &optional;
        point_type_149 : count &log &optional;

        point_type_150 : count &log &optional;
        point_type_151 : count &log &optional;
        point_type_152 : count &log &optional;
        point_type_153 : count &log &optional;
        point_type_154 : count &log &optional;
        point_type_155 : count &log &optional;
        point_type_156 : count &log &optional;
        point_type_157 : count &log &optional;
        point_type_158 : count &log &optional;
        point_type_159 : count &log &optional;

        point_type_160 : count &log &optional;
        point_type_161 : count &log &optional;
        point_type_162 : count &log &optional;
        point_type_163 : count &log &optional;
        point_type_164 : count &log &optional;
        point_type_165 : count &log &optional;
        point_type_166 : count &log &optional;
        point_type_167 : count &log &optional;
        point_type_168 : count &log &optional;
        point_type_169 : count &log &optional;

        point_type_170 : count &log &optional;
        point_type_171 : count &log &optional;
        point_type_172 : count &log &optional;
        point_type_173 : count &log &optional;
        point_type_174 : count &log &optional;
        point_type_175 : count &log &optional;
        point_type_176 : count &log &optional;
        point_type_177 : count &log &optional;
        point_type_178 : count &log &optional;
        point_type_179 : count &log &optional;

        point_type_180 : count &log &optional;
        point_type_181 : count &log &optional;
        point_type_182 : count &log &optional;
        point_type_183 : count &log &optional;
        point_type_184 : count &log &optional;
        point_type_185 : count &log &optional;
        point_type_186 : count &log &optional;
        point_type_187 : count &log &optional;
        point_type_188 : count &log &optional;
        point_type_189 : count &log &optional;

        point_type_190 : count &log &optional;
        point_type_191 : count &log &optional;
        point_type_192 : count &log &optional;
        point_type_193 : count &log &optional;
        point_type_194 : count &log &optional;
        point_type_195 : count &log &optional;
        point_type_196 : count &log &optional;
        point_type_197 : count &log &optional;
        point_type_198 : count &log &optional;
        point_type_199 : count &log &optional;

        point_type_200 : count &log &optional;
        point_type_201 : count &log &optional;
        point_type_202 : count &log &optional;
        point_type_203 : count &log &optional;
        point_type_204 : count &log &optional;
        point_type_205 : count &log &optional;
        point_type_206 : count &log &optional;
        point_type_207 : count &log &optional;
        point_type_208 : count &log &optional;
        point_type_209 : count &log &optional;

        point_type_210 : count &log &optional;
        point_type_211 : count &log &optional;
        point_type_212 : count &log &optional;
        point_type_213 : count &log &optional;
        point_type_214 : count &log &optional;
        point_type_215 : count &log &optional;
        point_type_216 : count &log &optional;
        point_type_217 : count &log &optional;
        point_type_218 : count &log &optional;
        point_type_219 : count &log &optional;

        point_type_220 : count &log &optional;
        point_type_221 : count &log &optional;
        point_type_222 : count &log &optional;
        point_type_223 : count &log &optional;
        point_type_224 : count &log &optional;
        point_type_225 : count &log &optional;
        point_type_226 : count &log &optional;
        point_type_227 : count &log &optional;
        point_type_228 : count &log &optional;
        point_type_229 : count &log &optional;

        point_type_230 : count &log &optional;
        point_type_231 : count &log &optional;
        point_type_232 : count &log &optional;
        point_type_233 : count &log &optional;
        point_type_234 : count &log &optional;
        point_type_235 : count &log &optional;
        point_type_236 : count &log &optional;
        point_type_237 : count &log &optional;
        point_type_238 : count &log &optional;
        point_type_239 : count &log &optional;

        point_type_240 : count &log &optional;
        point_type_241 : count &log &optional;
        point_type_242 : count &log &optional;
        point_type_243 : count &log &optional;
        point_type_244 : count &log &optional;
        point_type_245 : count &log &optional;
        point_type_246 : count &log &optional;
        point_type_247 : count &log &optional;
        point_type_248 : count &log &optional;
        point_type_249 : count &log &optional;

        point_type_250 : count &log &optional;
        point_type_251 : count &log &optional;
        point_type_252 : count &log &optional;
        point_type_253 : count &log &optional;
        point_type_254 : count &log &optional;
        point_type_255 : count &log &optional;
    };

    type roc_plus_historical_min_max_vals_log: record {
        ts                             : time    &log;
        uid                            : string  &log;
        id                             : conn_id &log;
        roc_plus_link_id               : string  &log &optional;

        # request
        history_segment               : count &log &optional; # Re-used for response
        historical_point_number       : count &log &optional; # Re-used for response

        # Response
        # history_segment                    : count  &log &optional;
        # historical_point_number            : count  &log &optional;
        historical_archival_method         : count  &log &optional;
        point_type                         : count  &log &optional;
        point_logic_number                 : count  &log &optional;
        parameter_number                   : count  &log &optional;
        current_value                      : count  &log &optional;
        minimum_value_since_contract       : count  &log &optional;
        maximum_value_since_contract       : count  &log &optional;
        time_of_min_value_occurrence       : string &log &optional;
        time_of_max_value_occurrence       : string &log &optional;
        minimum_value_yesterday            : count  &log &optional;
        maximum_value_yesterday            : count  &log &optional;
        time_of_yesterday_min_value        : string &log &optional;
        time_of_yesterday_max_value        : string &log &optional;
        value_during_last_completed_period : count  &log &optional;
    };

    type roc_plus_realtime_clock_log: record {
        ts                  : time    &log;
        uid                 : string  &log;
        id                  : conn_id &log;
        roc_plus_link_id    : string  &log &optional;

        ######### Opcode 7 - Read Real-time Clock

        # Response (request is empty)
        current_second      : count  &log &optional; # Re-use for opcode 8
        current_minute      : count  &log &optional; # Re-use for opcode 8
        current_hour        : count  &log &optional; # Re-use for opcode 8
        current_day         : count  &log &optional; # Re-use for opcode 8
        current_month       : count  &log &optional; # Re-use for opcode 8
        current_year        : count  &log &optional; # Re-use for opcode 8
        current_day_of_week : string &log &optional;

        ######### Opcode 8 - Set Real-time Clock

        # Request (response is empty)
        # current_second    : count &log &optional;
        # current_minute    : count &log &optional;
        # current_hour      : count &log &optional;
        # current_day       : count &log &optional;
        # current_month     : count &log &optional;
        # current_year      : count &log &optional;
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
        # table_number            : count  &log &optional;
        # starting_table_location : count  &log &optional;
        # num_table_locations     : count  &log &optional;
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
        access_level     : string &log &optional;
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
        # history_segment : count &log &optional;
        # num_points      : count &log &optional;
        periodic_index    : count &log &optional;
        # historical_points : vector of string &log &optional;
        tag               : string &log &optional;
        ##################

        ### Opcode 118 ###
        # Request
        num_alarms             : count &log &optional; # Re-used for response
        starting_alarm_log_idx : count &log &optional; # Re-used for response

        # Response
        # num_alarms             : count &log &optional;
        # starting_alarm_log_idx : count &log &optional;
        current_alarm_log_idx    : count &log &optional;  # Re-used for opcode 119 response
        alarm_data               : vector of string &log &optional;
        ##################

        ### Opcode 119 ###
        # Request
        num_events_req         : count &log &optional;
        starting_event_log_idx : count &log &optional;  # Re-used for response

        # Response
        num_events_sent          : count &log &optional;
        # starting_event_log_idx : count &log &optional;
        current_event_log_idx    : count &log &optional;
        event_data               : vector of string &log &optional;
        ##################

        ### Opcode 137 ###
        # Request
        # history_segment : count &log &optional;
        day_requested        : count &log &optional; # Re-use for opcode 138
        month_requested      : count &log &optional; # Re-use for opcode 138

        # Response
        # history_segment : count &log &optional;
        starting_periodic_idx : count &log &optional; # Re-use for opcode 138
        num_periodic_entries  : count &log &optional; # Re-use for opcode 138
        daily_index           : count &log &optional; # Re-use for opcode 138
        num_daily_entries     : count &log &optional; # Re-use for opcode 138
        ##################

        ### Opcode 138 ###
        # Request
        # history_segment : count &log &optional;
        history_point     : count &log &optional; # Re-use for response
        # day_requested   : count &log &optional;
        # month_requested : count &log &optional;

        # Response
        # history_segment      : count &log &optional;
        # history_point         : count &log &optional;
        # day_requested        : count &log &optional;
        # month_requested      : count &log &optional;
        # num_periodic_entries : count &log &optional;
        # num_daily_entries    : count &log &optional;
        periodic_values      : vector of count &log &optional;
        daily_values         : vector of count &log &optional;  
        ##################
    };

    type roc_plus_user_defined_info_log: record {
        ts               : time    &log;
        uid              : string  &log;
        id               : conn_id &log;
        roc_plus_link_id : string  &log &optional;

        # Request
        command     : count  &log &optional; # Re-use for response
        start_point : count  &log &optional; # Re-use for response
        num_points  : count  &log &optional; # Re-use for response

        # Response
        # command     : count  &log &optional;
        # start_point : count  &log &optional;
        # num_points  : count  &log &optional;
        point_types : vector of string &log &optional;
    };

    type roc_plus_single_point_parameters_log: record {
        ts               : time    &log;
        uid              : string  &log;
        id               : conn_id &log;
        roc_plus_link_id : string  &log &optional;

        ### Opcode 166 ###
        # Request
        point_type          : count  &log &optional; # Re-use all of these for Opcode 167
        point_logic_number  : count  &log &optional;
        num_parameters      : count  &log &optional;
        start_parameter_num : count  &log &optional;
        parameter_data      : string &log &optional;

        # No response
        ##################
        ##################

        ### Opcode 167 ###
        # Request
        # point_type          : count  &log &optional; 
        # point_logic_number  : count  &log &optional;
        # num_parameters      : count  &log &optional;
        # start_parameter_num : count  &log &optional;

        # Response
        # point_typeReq       : count  &log &optional;
        # point_logic_number  : count  &log &optional;
        # num_parameters      : count  &log &optional;
        # start_parameter_num : count  &log &optional;
        # parameter_data      : string &log &optional;
    };

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
        file_names       : string &log &optional;
    };

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
        num_transactions   : count &log &optional; # Re-use
        data_offset        : count &log &optional;

        # List Response
        # command            : string &log &optional; 
        # num_transactions   : count  &log &optional;
        more_data          : string &log &optional; # Re-use
        description        : string &log &optional;
        payload_size       : vector of count &log &optional;
        transaction_num    : vector of count &log &optional;
        date_created       : vector of count &log &optional;

        # Read Response
        # command            : string &log &optional; 
        msg_data_size      : count &log &optional;
        # more_data          : string &log &optional;
        data_type          : vector of string &log &optional;
        data               : vector of count &log &optional;
    };

    type roc_plus_unknown_opcode_data_log: record {
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
        history_timestamps                  : vector of count &log &optional;
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
        timestamp_for_index                 : count &log &optional;
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