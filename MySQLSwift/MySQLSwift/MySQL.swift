//
//  MySQL.swift
//  MySQLSwift
//
//  Created by Alsey Coleman Miller on 10/10/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import mysqlclient

public final class MySQL {
    
    // Client Info
    
    public static var clientInfo: String {
        
        guard let version = String.fromCString(mysql_get_client_info())
            else { fatalError("Could not get MySQL client version") }
        
        return version
    }
    
    public static var clientVersion: UInt {
        
        return mysql_get_client_version()
    }
}

// MARK: - Definitions

@asmname("mysql_create_db") func mysql_create_db(mysql: UnsafeMutablePointer<MYSQL>, _ database: UnsafePointer<CChar>) -> Int32

@asmname("mysql_drop_db") func mysql_drop_db(mysql: UnsafeMutablePointer<MYSQL>, _ database: UnsafePointer<CChar>) -> Int32

@asmname("mysql_exec_sql") func mysql_exec_sql(mysql: UnsafeMutablePointer<MYSQL>, _ SQL: UnsafePointer<CChar>) -> Int32
