//
//  ClientError.swift
//  MySQLSwift
//
//  Created by Alsey Coleman Miller on 10/11/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import mysqlclient

public extension MySQL {
    
    public enum ClientError: UInt32, ErrorType, RawRepresentable {
        
        /// Unknown MySQL error
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


