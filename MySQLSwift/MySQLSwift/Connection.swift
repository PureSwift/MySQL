//
//  Connection.swift
//  MySQLSwift
//
//  Created by Alsey Coleman Miller on 12/4/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import mysqlclient

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
        
        public init() {
            
            guard mysql_init(internalPointer) != nil else { fatalError("Could not initialize MySQL") }
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
        
        public func executeQuery(query: String) throws -> Result? {
            
            guard mysql_exec_sql(internalPointer, query) == 0
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
            
            // Other
            
            var rowResults = [[(Data)]]()
            
            var row: MYSQL_ROW
            
            repeat {
                
                row = mysql_fetch_row(mysqlResult)
                
                let numberOfFields = mysql_num_fields(mysqlResult)
                
                let fieldLengths = mysql_fetch_lengths(mysqlResult)
                
                let lastFieldIndex = Int(numberOfFields - 1)
                
                var fields = [Data]()
                
                for i in 0...lastFieldIndex {
                    
                    let fieldValuePointer = row[i]
                    
                    let fieldLength = fieldLengths[i]
                    
                    let data = DataFromBytePointer(fieldValuePointer, length: Int(fieldLength))
                    
                    fields.append(data)
                }
                
                rowResults.append(fields)
                
            } while row != nil
            
            guard mysql_eof(mysqlResult) != 0
                else { throw Error.NotEndOfFile }
            
            return rowResults
        }
    }
}