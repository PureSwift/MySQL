//
//  Connection.swift
//  MySQL
//
//  Created by Alsey Coleman Miller on 12/4/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import Cmysqlclient

public extension MySQL {
    
    public final class Connection {
        
        // MARK: - Properties
        
        public var hostInfo: String? {
            
            return String.fromCString(mysql_get_host_info(internalPointer))
        }
        
        /// Human readable error string for the last error produced (if any).
        public var lastErrorString: String?  {
            
            return String.fromCString(mysql_error(internalPointer))
        }
        
        // MARK: - Private Properties
        
        private let internalPointer = UnsafeMutablePointer<MYSQL>()
        
        // MARK: - Initialization
        
        deinit {
            
            mysql_close(internalPointer)
        }
        
        /// Attempts to establish a connection to a MySQL database engine.
        public init(host: String? = nil, user: String? = nil, password: String? = nil, db: String? = nil, port: UInt32 = 0, socket: String? = nil, flag: UInt = 0) throws {
            
            guard mysql_init(internalPointer) != nil else { fatalError("Could not initialize MySQL handler") }
            
            let hostOrBlank = convertString(host)
            let userOrBlank = convertString(user)
            let passwordOrBlank = convertString(password)
            let dbOrBlank = convertString(db)
            let socketOrBlank = convertString(socket)
            
            defer {
                cleanConvertedString(hostOrBlank)
                cleanConvertedString(userOrBlank)
                cleanConvertedString(passwordOrBlank)
                cleanConvertedString(dbOrBlank)
                cleanConvertedString(socketOrBlank)
            }
            
            guard mysql_real_connect(internalPointer, hostOrBlank.0, userOrBlank.0, passwordOrBlank.0, dbOrBlank.0, port, socketOrBlank.0, flag) != nil else { throw ClientError(rawValue: mysql_errno(internalPointer))! }
        }
                
        // MARK: - Methods
    
        // MARK: Database Operations
        
        public func selectDatabase(database: String) throws {
            
            guard mysql_select_db(internalPointer, database) == 0
                else { throw ClientError(rawValue: mysql_errno(internalPointer))! }
        }
        
        public func createDatabase(databaseName: String) throws {
            
            let statement = "CREATE DATABASE " + databaseName
            
            try self.query(statement)
        }
        
        public func deleteDatabase(databaseName: String) throws {
            
            let statement = "DROP DATABASE " + databaseName
            
            try self.query(statement)
        }
        
        public func listTables(wild: String? = nil) throws -> [String] {
            
            var names = [String]()
            
            let resultPointer = (wild == nil ? mysql_list_tables(internalPointer, nil) : mysql_list_tables(internalPointer, wild!))
            
            guard resultPointer != nil else { throw ClientError(rawValue: mysql_errno(internalPointer))! }
            
            defer { mysql_free_result(resultPointer) }
            
            var rowPointer = mysql_fetch_row(resultPointer)
            
            while rowPointer != nil {
                
                let name = String.fromCString(rowPointer[0])!
                
                names.append(name)
                
                // fetch next row
                rowPointer = mysql_fetch_row(resultPointer)
            }
            
            return names
        }
        
        public func listDatabases(wild: String? = nil) throws -> [String] {
            
            var names = [String]()
            
            let resultPointer = (wild == nil ? mysql_list_dbs(internalPointer, nil) : mysql_list_dbs(internalPointer, wild!))
            
            guard resultPointer != nil else { throw ClientError(rawValue: mysql_errno(internalPointer))! }
            
            defer { mysql_free_result(resultPointer) }
            
            var rowPointer = mysql_fetch_row(resultPointer)
            
            while rowPointer != nil {
                
                let name = String.fromCString(rowPointer[0])!
                
                names.append(name)
                
                // fetch next row
                rowPointer = mysql_fetch_row(resultPointer)
            }
            
            return names
        }
        
        // MARK: Query
        
        public func query(query: String) throws -> Result? {
            
            let convertedQueryString = convertString(query)
            
            defer { cleanConvertedString(convertedQueryString) }
            
            guard mysql_real_query(internalPointer, query, UInt(convertedQueryString.1)) == 0
                else { throw ClientError(rawValue: mysql_errno(internalPointer))! }
            
            // get result...
            let mysqlResult = mysql_store_result(internalPointer)
            
            guard mysqlResult != nil else {
                
                // make sure it was really an empty result
                // http://dev.mysql.com/doc/refman/5.0/en/null-mysql-store-result.html
                
                guard mysql_field_count(internalPointer) == 0
                    else { throw MySQL.Error.BadResult }
                
                return nil
            }
            
            return Result(internalPointer: mysqlResult)
        }
    }
}

