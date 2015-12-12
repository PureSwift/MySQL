//
//  Statement.swift
//  MySQL
//
//  Created by Alsey Coleman Miller on 12/11/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import SwiftFoundation
import CMySQL

public extension MySQL {
    
    // Due to compiler error
    public typealias Statement = MySQLStatement
}

public final class MySQLStatement {
    
    // MARK: - Properties
    
    public let connection: MySQL.Connection
    
    // MARK: - Internal Methods
    
    internal let internalPointer: UnsafeMutablePointer<MYSQL_STMT>
    
    // MARK: - Initialization
    
    deinit { mysql_stmt_close(internalPointer) }
    
    public init(connection: MySQL.Connection) throws {
        
        self.connection = connection
        
        self.internalPointer = mysql_stmt_init(connection.internalPointer)
        
        guard self.internalPointer != nil else { throw connection.statusCodeError }
    }
    
    // MARK: - Methods
    
    public func prepare(statement: String) throws {
        
        guard mysql_stmt_prepare(internalPointer, statement, UInt(statement.utf8.count)) == 0
            else { throw statusCodeError }
    }
    
    public func bindResult() {
        
        
    }
    
    // MARK: - Private Methods
    
    internal var statusCodeError: MySQL.Error {
        
        let errorNumber = mysql_stmt_errno(internalPointer)
        
        #if os(OSX)
            let errorString = String.fromCString(mysql_stmt_error(internalPointer))!
        #elseif os(Linux)
            let errorString = ""
        #endif
        
        return MySQL.Error.ErrorCode(errorNumber, errorString)
    }
}

