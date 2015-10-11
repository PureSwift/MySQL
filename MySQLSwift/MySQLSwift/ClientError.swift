//
//  ClientError.swift
//  MySQLSwift
//
//  Created by Alsey Coleman Miller on 10/11/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import mysql

public extension MySQL {
    
    public enum ClientError: ErrorType {
        
        /// Unknown MySQL error
        case Unknown
        
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
        
        public var rawValue: Int {
            
            switch self {
                
            case .Unknown:              return 2000
            case .SocketCreate:         return 2001
            case .Connection:           return 2002
            case .ConnectionHostError:  return 2003
            case .IPSocket:             return 2004
            case .UnknownHost:          return 2005
            case .ServerGone:           return 2006
            case .VersionMismatch:      return 2007
            case .OutOfMemory:          return 2008
            case .WrongHostInfo:        return 2009
            case .LocalhostConnection:  return 2010
            case .TCPConnection:        return 2011
            case .ServerHandshake:      return 2012
            case .ServerLost:           return 2013
            
            }
        }
    }
}
