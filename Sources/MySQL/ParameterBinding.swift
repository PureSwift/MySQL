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
        
        public var value: Value
        
        // MARK: - Internal Properties
        
        internal let internalPointer = UnsafeMutablePointer<MYSQL_BIND>()
        
        internal let dataPointer: UnsafeMutablePointer<Void>
        
        // MARK: - Initialization
        
        deinit {
            
            internalPointer.destroy()
            internalPointer.dealloc(1)
            
            dataPointer.destroy()
            dataPointer.dealloc(1)
        }
        
        public init(value: Value) {
            
            self.value = value
            
            // To use a MYSQL_BIND structure, zero its contents to initialize it.
            memset(self.internalPointer, 0, sizeof(MYSQL_BIND))
            
            // initialize data pointer
            self.dataPointer = UnsafeMutablePointer<BindingDataType.DataType>.alloc(1)
            
            self.dataPointer.memory = parameterData.value
            
            // set data type
            self.internalPointer.memory.buffer_type = BindingDataType.fieldType
            
            // set data pointer
            self.internalPointer.memory.buffer = unsafeBitCast(self.internalPointer, UnsafeMutablePointer<Void>.self)
        }
    }
}

public extension MySQLStatement {
    
    public func bind(parameter: ParameterBinding) {
        
        
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
        case DateStamp(MYSQL_TIME)
        case TimeStamp(MYSQL_TIME)
        case String(StringValue)
        case Blob(Data)
    }
}




