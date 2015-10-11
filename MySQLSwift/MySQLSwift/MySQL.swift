//
//  MySQL.swift
//  MySQLSwift
//
//  Created by Alsey Coleman Miller on 10/10/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import mysql

public final class MySQL {
    
    // MARK: - Class Methods
    
    public static var clientInfo: String {
        
        guard let version = String.fromCString(mysql_get_client_info())
            else { fatalError("Could not get MySQL client version") }
        
        return version
    }
    
    public static var clientVersion: UInt {
        
        return mysql_get_client_version()
    }
    
    // MARK: - Properties
    
    /// Human readable error string for the last error produced (if any).
    public var errorString: String? {
        
        return String.fromCString(mysql_error(internalPointer))
    }
    
    // MARK: - Private Properties
    
    private let internalPointer = UnsafeMutablePointer<MYSQL>()
    
    // MARK: - Initialization
    
    deinit {
        
        mysql_close(internalPointer)
    }
    
    public init?() {
        
        guard mysql_init(internalPointer) != nil else { return nil }
    }
    
    // MARK: - Methods
    
    /// Attempts to establish a connection to a MySQL database engine.
    public func connect(host: String, user: String, password: String, database: String? = nil, port: UInt32 = 0, options: [ClientOption] = []) throws {
        
        let clientFlags: UInt32 = 0
        
        if let database = database {
            
            guard mysql_real_connect(internalPointer, host, user, password, database, port, nil, clientFlags) != nil
                else { throw ClientError(rawValue: mysql_errno(internalPointer))! }
        }
        else {
            
            guard mysql_real_connect(internalPointer, host, user, password, nil, port, nil, clientFlags) != nil
                else { throw ClientError(rawValue: mysql_errno(internalPointer))! }
        }
    }
    
    public func selectDatabase(database: String) throws {
        
        guard mysql_select_db(internalPointer, database) == 0
            else { throw ClientError(rawValue: mysql_errno(internalPointer))! }
    }
}

