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
    
    public let statement: String
    
    public let parameters: [ParameterBinding]
    
    public let results: [ResultBinding]
    
    // MARK: - Internal Methods
    
    internal let convertedStatement: (UnsafeMutablePointer<CChar>, Int)
    
    internal let internalPointer: UnsafeMutablePointer<MYSQL_STMT>
    
    internal let internalParametersPointer: UnsafeMutablePointer<MYSQL_BIND>
    
    // MARK: - Initialization
    
    public init(statement: String, parameters: [ParameterBinding], results: [ResultBinding], connection: MySQL.Connection) throws {
        
        // set properties...
        self.statement = statement
        self.connection = connection
        self.parameters = parameters
        self.results = results
        
        self.convertedStatement = convertString(statement)
        self.internalParametersPointer = UnsafeMutablePointer<MYSQL_BIND>.alloc(parameters.count)
        self.internalPointer = mysql_stmt_init(connection.internalPointer)
        
        // validate internal handle
        guard self.internalPointer != nil
            else { throw connection.statusCodeError }
        
        // prepare statement
        guard mysql_stmt_prepare(internalPointer, convertedStatement.0, UInt(convertedStatement.1)) == 0
            else { throw statusCodeError }
        
        // bind parameters...
        
        // To use a MYSQL_BIND structure, zero its contents to initialize it, then set its members appropriately.
        memset(internalParametersPointer, 0, parameters.count)
        
        for (index, binding) in parameters.enumerate() {
            
            let internalBinding = binding.internalBinding
            
            internalParametersPointer[index].buffer_type = internalBinding.dynamicType.fieldType
            
            internalParametersPointer[index].buffer = internalBinding.buffer
            
            internalParametersPointer[index].buffer_length = internalBinding.bufferLength
        }
        
        guard mysql_stmt_bind_param(internalPointer, internalParametersPointer) == 0
            else { throw statusCodeError }
        
        // bind results... 
        guard mysql_stmt_bind_result(<#T##stmt: UnsafeMutablePointer<MYSQL_STMT>##UnsafeMutablePointer<MYSQL_STMT>#>, <#T##bnd: UnsafeMutablePointer<MYSQL_BIND>##UnsafeMutablePointer<MYSQL_BIND>#>)
    }
    
    deinit {
        
        mysql_stmt_close(internalPointer)
        
        internalParametersPointer.dealloc(parameters.count)
        cleanConvertedString(convertedStatement)
    }
    
    // MARK: - Methods
    
    public func execute() throws {
        
        guard mysql_stmt_execute(internalPointer) == 0
            else { throw statusCodeError }
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

