//
//  ClientError.swift
//  MySQL
//
//  Created by Alsey Coleman Miller on 10/11/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import Cmysqlclient

public extension MySQL {
    
    /// [Client Error Codes](http://dev.mysql.com/doc/refman/5.7/en/error-messages-client.html#error_cr_commands_out_of_sync)
    ///
    /// Client error information comes from the following source files:
    ///
    /// The Error values and the symbols in parentheses correspond to definitions in the ```include/errmsg.h``` MySQL source file.
    ///
    /// The Message values correspond to the error messages that are listed in the ```libmysql/errmsg.c``` file.
    /// ```%d``` and ```%s``` represent numbers and strings, respectively, that are substituted into the messages when
    /// they are displayed.
    public enum ClientError: UInt32, ErrorType, RawRepresentable {
        
        /// Unknown MySQL error
        ///
        /// [CR_UNKNOWN_ERROR](http://dev.mysql.com/doc/refman/5.7/en/error-messages-client.html#error_cr_unknown_error)
        case Unknown = 2000
        
        /// Can't create UNIX socket (%d)
        case SocketCreate
        
        /// Can't connect to local MySQL server through socket '%s' (%d)
        case Connection
        
        /// Can't connect to MySQL server on '%s' (%d)
        case ConnectionHostError
        
        /// Can't create TCP/IP socket (%d)
        case IPSocket
        
        /// Unknown MySQL server host '%s' (%d)
        case UnknownHost
        
        /// MySQL server has gone away
        case ServerGone
        
        /// Protocol mismatch; server version = %d, client version = %d
        case VersionMismatch
        
        /// MySQL client ran out of memory
        case OutOfMemory
        
        /// Wrong host info
        case WrongHostInfo
        
        /// Localhost via UNIX socket
        case LocalhostConnection
        
        /// %s via TCP/IP
        case TCPConnection
        
        /// Error in server handshake
        case ServerHandshake
        
        /// Lost connection to MySQL server during query
        case ServerLost
    }
}



