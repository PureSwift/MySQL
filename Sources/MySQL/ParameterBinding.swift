//
//  ParameterBinding.swift
//  MySQL
//
//  Created by Alsey Coleman Miller on 12/11/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import SwiftFoundation
import CMySQL

public extension MySQLStatement {
    
    public final class ParameterBinding {
        
        // MARK: - Properties
        
        public let value: Value
        
        // MARK: - Internal Properties
        
        internal let internalPointer = UnsafeMutablePointer<MYSQL_BIND>()
        
        // MARK: - Initialization
        
        public init(value: Value) {
            
            self.value = value
            
            // To use a MYSQL_BIND structure, zero its contents to initialize it.
            memset(self.internalPointer, 0, sizeof(MYSQL_BIND))
            
            switch value {
                
            case .Null:
                
                self.internalPointer.memory.buffer_type = MYSQL_TYPE_NULL
                
            case let .Tiny(numberValue):
                setRawBindingValue(internalPointer, value: numberValue, fieldType: MYSQL_TYPE_TINY)
                
            case let .Short(numberValue):
                setRawBindingValue(internalPointer, value: numberValue, fieldType: MYSQL_TYPE_SHORT)
                
            case let .Long(numberValue):
                setRawBindingValue(internalPointer, value: numberValue, fieldType: MYSQL_TYPE_LONG)
                
            case let .LongLong(numberValue):
                setRawBindingValue(internalPointer, value: numberValue, fieldType: MYSQL_TYPE_LONGLONG)
                
            case let .Float(numberValue):
                setRawBindingValue(internalPointer, value: numberValue, fieldType: MYSQL_TYPE_FLOAT)
                
            case let .Double(numberValue):
                setRawBindingValue(internalPointer, value: numberValue, fieldType: MYSQL_TYPE_DOUBLE)
                
            case let .Time(timeValue):
                setRawBindingValue(internalPointer, value: timeValue, fieldType: MYSQL_TYPE_TIME)
                
            case let .Date(timeValue):
                setRawBindingValue(internalPointer, value: timeValue, fieldType: MYSQL_TYPE_DATE)
                
            case let .DateTime(timeValue):
                setRawBindingValue(internalPointer, value: timeValue, fieldType: MYSQL_TYPE_DATETIME)
                
            case let .TimeStamp(timeValue):
                setRawBindingValue(internalPointer, value: timeValue, fieldType: MYSQL_TYPE_TIMESTAMP)
                
            case let .String(stringValue):
                
                internalPointer.memory.buffer_type = MYSQL_TYPE_STRING
                
                let (stringPointer, _) = convertString(stringValue)
                
                let voidPointer = unsafeBitCast(stringPointer, UnsafeMutablePointer<Void>.self)
                
                internalPointer.memory.buffer = voidPointer
                
            case let .Blob(data):
                
                internalPointer.memory.buffer_type = MYSQL_TYPE_BLOB
                
                let bytePointer = UnsafeMutablePointer<Void>.alloc(data.count)
                
                memcpy(bytePointer, data, data.count)
                
                internalPointer.memory.buffer = bytePointer
            }
        }
        
        deinit {
            
            internalPointer.destroy()
            internalPointer.dealloc(1)
        }
    }
}

public extension MySQLStatement {
    
    public func bind(parameters: [ParameterBinding]) throws {
        
        let bindingsPointer = UnsafeMutablePointer<MYSQL_BIND>.alloc(parameters.count)
        
        for (index, binding) in parameters.enumerate() {
            
            bindingsPointer[index] = binding.internalPointer.memory
        }
        
        guard mysql_stmt_bind_param(internalPointer, bindingsPointer) == 0
            else { throw statusCodeError }
        
        self.parameterBindings = parameters
    }
}

// MARK: - Supporting Types

public extension MySQLStatement.ParameterBinding {
    
    public enum Value {
        
        case Null
        
        case Tiny(CChar)
        case Short(CShort)
        case Long(CInt)
        case LongLong(CLongLong)
        case Float(CFloat)
        case Double(CDouble)
        
        case Time(MYSQL_TIME)
        case Date(MYSQL_TIME)
        case DateTime(MYSQL_TIME)
        case TimeStamp(MYSQL_TIME)
        
        case String(StringValue)
        case Blob(Data)
    }
}

// MARK: - Private Functions

private func setRawBindingValue<DataType: Any>(bindingPointer: UnsafeMutablePointer<MYSQL_BIND>, value: DataType, fieldType: enum_field_types) {
    
    bindingPointer.memory.buffer_type = fieldType
    
    let dataPointer = UnsafeMutablePointer<DataType>.alloc(1)
    
    dataPointer.memory = value
    
    let voidPointer = unsafeBitCast(dataPointer, UnsafeMutablePointer<Void>.self)
    
    bindingPointer.memory.buffer = voidPointer
}

