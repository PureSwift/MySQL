//
//  ClientOption.swift
//  MySQLSwift
//
//  Created by Alsey Coleman Miller on 10/11/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

//import SwiftFoundation
import mysql

public enum ClientOption/*: OptionsBitmask*/ {
    
    /// Use compression protocol.
    case Compress
    
    /// Return the number of found (matched) rows, not the number of changed rows.
    case FoundRows
    
    /// Prevents the client library from installing a ```SIGPIPE``` signal handler. 
    /// This can be used to avoid conflicts with a handler that the application has already installed.
    case IgnoreSigpipe
    
    /// Permit spaces after function names. Makes all functions names reserved words.
    case IgnoreSpace
    
    /// Permit ```interactive_timeout``` seconds (instead of ```wait_timeout seconds```) of inactivity before
    /// closing the connection. The client's session ```wait_timeout``` variable is set to the value of the 
    /// session ```interactive_timeout``` variable.
    case Interactive
    
    /// Enable [```LOAD DATA LOCAL```](https://dev.mysql.com/doc/refman/5.1/en/load-data.html) handling.
    case LocalFiles
    
    /// Tell the server that the client can handle multiple result sets from multiple-statement executions 
    /// or stored procedures. This flag is automatically enabled if ```CLIENT_MULTI_STATEMENTS``` is enabled.
    ///
    /// - SeeAlso: ```ClientOption.MutliStatements```
    case MultiResults
    
    /// Tell the server that the client may send multiple statements in a single string (separated by
    /// “```;```”). If this flag is not set, multiple-statement execution is disabled.
    case MutliStatements
    
    /// Do not permit the ```db_name.tbl_name.col_name syntax```. This is for ODBC.
    /// It causes the parser to generate an error if you use that syntax, 
    /// which is useful for trapping bugs in some ODBC programs.
    case NoSchema
    
    /// Unused
    case ODBC
    
    /// Use SSL (encrypted protocol).
    ///
    /// - Note: Do not set this option within an application program;
    /// it is set internally in the client library. 
    /// Instead, use ```mysql_ssl_set()``` before calling ```mysql_real_connect()```.
    case SSL
    
    /// Remember options specified by calls to ```mysql_options()```. 
    ///
    /// Without this option, if ```mysql_real_connect()``` fails, you must repeat the ```mysql_options()```
    /// calls before trying to connect again. 
    /// With this option, the ```mysql_options()``` calls need not be repeated.
    case RememberOptions
    
    public var rawValue: Int32 {
        
        switch self {
            
        case .Compress:     return CLIENT_COMPRESS
        case .FoundRows:    return CLIENT_FOUND_ROWS
        
        }
    }
}
