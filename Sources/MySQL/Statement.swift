//
//  Statement.swift
//  MySQL
//
//  Created by Alsey Coleman Miller on 12/11/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import SwiftFoundation
import CMySQL

public extension MySQL.Connection {
    
    func executeStatement(statement: String, parameters: [MySQL.StatementParameter], results: [MySQL.StatementResultType]) throws {
        
        let statementPointer = mysql_stmt_init(self.internalPointer)
        
        // validate internal handle
        guard statementPointer != nil
            else { throw self.statusCodeError }
        
        defer { mysql_stmt_close(statementPointer) }
        
        // declare nested function for statement errors
        func statementStatusCodeError() -> MySQL.Error {
            
            let errorNumber = mysql_stmt_errno(statementPointer)
            
            #if os(OSX)
                let errorString = String.fromCString(mysql_stmt_error(statementPointer))!
            #elseif os(Linux)
                let errorString = ""
            #endif
            
            return MySQL.Error.ErrorCode(errorNumber, errorString)
        }
        
        let convertedStatement = convertString(statement)
        defer { cleanConvertedString(convertedStatement) }
        
        // prepare statement
        guard mysql_stmt_prepare(statementPointer, convertedStatement.0, UInt(convertedStatement.1)) == 0
            else { throw statementStatusCodeError() }
        
        // bind parameters...
        let parametersPointer = UnsafeMutablePointer<MYSQL_BIND>.alloc(parameters.count)
        defer { parametersPointer.dealloc(parameters.count) }
        
        // To use a MYSQL_BIND structure, zero its contents to initialize it, then set its members appropriately.
        memset(parametersPointer, 0, parameters.count)
        
        for (index, parameter) in parameters.enumerate() {
            
            switch parameter {
                
            case .Null:
                parametersPointer[index].buffer_type = MYSQL_TYPE_NULL
                
            case let .Tiny(value):
                parametersPointer[index].buffer_type = MYSQL_TYPE_TINY
                let buffer = UnsafeMutablePointer<CChar>.alloc(1)
                defer { buffer.dealloc(1) }
                buffer.initialize(value)
                parametersPointer[index].buffer = UnsafeMutablePointer<Void>(buffer)
                
            case let .Short(value):
                parametersPointer[index].buffer_type = MYSQL_TYPE_SHORT
                let buffer = UnsafeMutablePointer<CShort>.alloc(1)
                defer { buffer.dealloc(1) }
                buffer.initialize(value)
                parametersPointer[index].buffer = UnsafeMutablePointer<Void>(buffer)
                
            case let .Long(value):
                parametersPointer[index].buffer_type = MYSQL_TYPE_LONG
                let buffer = UnsafeMutablePointer<CInt>.alloc(1)
                defer { buffer.dealloc(1) }
                buffer.initialize(value)
                parametersPointer[index].buffer = UnsafeMutablePointer<Void>(buffer)
                
            case let .LongLong(value):
                parametersPointer[index].buffer_type = MYSQL_TYPE_LONGLONG
                let buffer = UnsafeMutablePointer<CLongLong>.alloc(1)
                defer { buffer.dealloc(1) }
                buffer.initialize(value)
                parametersPointer[index].buffer = UnsafeMutablePointer<Void>(buffer)
                
            case let .Float(value):
                parametersPointer[index].buffer_type = MYSQL_TYPE_FLOAT
                let buffer = UnsafeMutablePointer<CFloat>.alloc(1)
                defer { buffer.dealloc(1) }
                buffer.initialize(value)
                parametersPointer[index].buffer = UnsafeMutablePointer<Void>(buffer)
                
            case let .Double(value):
                parametersPointer[index].buffer_type = MYSQL_TYPE_DOUBLE
                let buffer = UnsafeMutablePointer<CDouble>.alloc(1)
                defer { buffer.dealloc(1) }
                buffer.initialize(value)
                parametersPointer[index].buffer = UnsafeMutablePointer<Void>(buffer)
            }
            
            let internalBinding = binding.internalBinding
            
            internalParametersPointer[index].buffer_type = internalBinding.dynamicType.fieldType
            
            internalParametersPointer[index].buffer = internalBinding.buffer
            
            internalParametersPointer[index].buffer_length = internalBinding.bufferLength
        }
        
        guard mysql_stmt_bind_param(internalPointer, internalParametersPointer) == 0
            else { throw statementStatusCodeError() }
        
        // bind results...
        guard mysql_stmt_bind_result(<#T##stmt: UnsafeMutablePointer<MYSQL_STMT>##UnsafeMutablePointer<MYSQL_STMT>#>, <#T##bnd: UnsafeMutablePointer<MYSQL_BIND>##UnsafeMutablePointer<MYSQL_BIND>#>)
        
        // execute statement
        guard mysql_stmt_execute(internalPointer) == 0
            else { throw statementStatusCodeError() }
    }
}

