module ROC_PLUS;

    export {
        ## This setting changes if passwords in opcode 17 are captured or not.
        option default_capture_password = F;
    }

    function process_login(c: connection, data: ROC_PLUS::DataBytes, link_id: string) {
        c = set_login_log(c);
        local log = c$roc_plus_login_log;
        
        log$roc_plus_link_id = link_id;

        if (data$packetType == ROC_PLUS_ENUMS::PacketType_REQUEST) 
        {
            if (data$login$request?$sessionKeyReq) 
            {
                log$session_key_string = data$login$request$sessionKeyReq$sessionKeyString;
            } 
            else if(data$login$request?$standardLogin)
            {
                log$operator_id  = data$login$request$standardLogin$operatorId;
                if (!default_capture_password) {
                    log$password     = "";
                }
                else {
                    log$password     = cat(data$login$request$standardLogin$password);
                }
                log$access_level = data$login$request$standardLogin$accessLevel;
            }
            else if(data$login$request?$enhancedLogin) 
            {
                log$operator_id  = data$login$request$enhancedLogin$operatorId;
                if (!default_capture_password) {
                    log$password     = "";
                }
                else {
                    log$password     = data$login$request$enhancedLogin$password;
                }
                log$access_level = data$login$request$enhancedLogin$accessLevel;
            }
            else if(data$login$request?$standardLogout)
            {
                log$operator_id   = data$login$request$standardLogout$operatorId;
                if (!default_capture_password) {
                    log$password      = ""; 
                }
                else {
                    log$password      = cat(data$login$request$standardLogout$password);
                }
                log$logout_string = data$login$request$standardLogout$logoutString;
            }
            else if(data$login$request?$enhancedLogout)
            {
                log$operator_id   = data$login$request$enhancedLogout$operatorId;
                if (!default_capture_password) {
                    log$password      = "";
                }
                else {
                    log$password      = data$login$request$enhancedLogout$password;
                }
                log$logout_string = data$login$request$enhancedLogout$logoutString;
            }
            ROC_PLUS::emit_roc_plus_login_log(c);
            delete c$roc_plus_login_log;
        } 
        else if(data$packetType == ROC_PLUS_ENUMS::PacketType_RESPONSE) 
        {
            if (data$login$response?$wrappedSessionKey) 
            {
                log$wrapped_session_key = data$login$response$wrappedSessionKey$wrappedSessionKey;

                ROC_PLUS::emit_roc_plus_login_log(c);
                delete c$roc_plus_login_log;
            }
        }
    }