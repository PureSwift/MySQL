//
//  MySQL.swift
//  MySQLSwift
//
//  Created by Alsey Coleman Miller on 10/10/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import mysql
import SwiftFoundation

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
        
        let clientFlags: UInt = 0
        
        if let database = database {
            
            guard mysql_real_connect(internalPointer, host, user, password, database, port, nil, clientFlags) != nil
                else { throw ClientError(rawValue: mysql_errno(internalPointer))! }
        }
        else {
            
            guard mysql_real_connect(internalPointer, host, user, password, nil, port, nil, clientFlags) != nil
                else { throw ClientError(rawValue: mysql_errno(internalPointer))! }
        }
    }
    
    // MARK: Database Operations
    
    public func selectDatabase(database: String) throws {
        
        guard mysql_select_db(internalPointer, database) == 0
            else { throw ClientError(rawValue: mysql_errno(internalPointer))! }
    }
    
    public func createDatabase(database: String) throws {
        
        guard mysql_create_db(internalPointer, database) == 0
            else { throw ClientError(rawValue: mysql_errno(internalPointer))! }
    }
    
    public func deleteDatabase(database: String) throws {
        
        guard mysql_drop_db(internalPointer, database) == 0
            else { throw ClientError(rawValue: mysql_errno(internalPointer))! }
    }
    
    // MARK: Query
    
    public func executeQuery(query: String) throws {
        
        guard mysql_exec_sql(internalPointer, query) == 0
            else { throw ClientError(rawValue: mysql_errno(internalPointer))! }
    }
    
    public func getResults() throws -> [[Data]]? {
        
        let mysqlResult = mysql_store_result(internalPointer)
        
        guard mysqlResult != nil else {
            
            guard mysql_field_count(internalPointer) == 0
                else { throw Error.BadResult }
            
            return nil
        }
        
        defer { mysql_free_result(mysqlResult) }
        
        var rowResults = [[Data]]()
        
        var row: MYSQL_ROW
        
        repeat {
            
            row = mysql_fetch_row(mysqlResult)
            
            let numberOfFields = mysql_num_fields(mysqlResult)
            
            let lastIndex = Int(numberOfFields - 1)
            
            var fieldsData = [Data]()
            
            for i in 0...lastIndex {
                
                let value = row[i]
                
                var data = Data()
                
                // get data from char array
                
                
                fieldsData.append(data)
            }
            
            rowResults.append(fieldsData)
            
        } while row != nil
        
        return rowResults
    }
}

// MARK: - Function Definitions

@asmname("mysql_create_db") func mysql_create_db(mysql: UnsafeMutablePointer<MYSQL>, _ database: UnsafePointer<CChar>) -> Int32

@asmname("mysql_drop_db") func mysql_drop_db(mysql: UnsafeMutablePointer<MYSQL>, _ database: UnsafePointer<CChar>) -> Int32

@asmname("mysql_exec_sql") func mysql_exec_sql(mysql: UnsafeMutablePointer<MYSQL>, _ SQL: UnsafePointer<CChar>) -> Int32

