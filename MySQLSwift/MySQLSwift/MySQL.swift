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
    
    public var error: String? {
        
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
    public func connect(host: String? = nil, user: String? = nil, password: String? = nil, database: String? = nil, port: UInt = 0, socket: String? = nil, clientFlag: ULONG = 0) {
        
        
    }
}

