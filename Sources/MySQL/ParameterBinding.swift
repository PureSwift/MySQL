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
    
    public struct Parameter { }
}

public extension MySQLStatement.Parameter {
    
    public enum Value {
        
        case Tiny
    }
}

public final class MySQLParameterBinding {
    
    // MARK: - Properties
    
    public var parameterData: BindingDataType
    
    // MARK: - Internal Properties
    
    internal let internalPointer = UnsafeMutablePointer<MYSQL_BIND>()
    
    internal let dataPointer: UnsafeMutablePointer<BindingDataType.DataType>
    
    // MARK: - Initialization
    
    deinit {
        
        internalPointer.destroy()
        internalPointer.dealloc(1)
        
        dataPointer.destroy()
        dataPointer.dealloc(1)
    }
    
    public init(parameterData: BindingDataType) {
        
        guard parameterData is InternalMySQLParameterBindingDataType
            else { fatalError("Unsupported MySQLParameterBindingDataType") }
        
        self.parameterData = parameterData
        
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
    
    // MARK: - Methods
}

// MARK: - Supporting Types

// MARK: - Binding

/// Swift / C data types that can be converted from MySQL values.
///
/// - Note: Never conform to this protocol! This is only for type safety.
public protocol MySQLParameterBindingDataType {
    
    typealias DataType
    
    static var fieldType: enum_field_types { get }
    
    var value: DataType { get }
}

public extension MySQLStatement {
    
    public struct Parameter {
        
        public struct TinyInteger: MySQLParameterBindingDataType {
            
            public static let fieldType = MYSQL_TYPE_TINY
            
            public let value: CChar
            
            public init(value: CChar) {
                
                self.value = value
            }
        }
        
        public struct SmallInteger: MySQLParameterBindingDataType {
            
            public static let fieldType = MYSQL_TYPE_SHORT
            
            public let value: CShort
            
            public init(value: CShort) {
                
                self.value = value
            }
        }
        
        public struct Integer: MySQLParameterBindingDataType {
            
            public static let fieldType = MYSQL_TYPE_LONG
            
            public let value: CInt
            
            public init(value: CInt) {
                
                self.value = value
            }
        }
        
        public struct BigInteger: MySQLParameterBindingDataType {
            
            public static let fieldType = MYSQL_TYPE_LONGLONG
            
            public let value: CShort
            
            public init(value: CShort) {
                
                self.value = value
            }
        }
    }
}

// MARK: Internal Binding

internal protocol InternalMySQLParameterBindingDataType: MySQLParameterBindingDataType {
    
    typealias InternalDataType
    
    var internalValue: InternalDataType { get }
}

extension MySQLStatement.Parameter.TinyInteger: InternalMySQLParameterBindingDataType {
    
    var internalValue: CChar { return self.value }
}

extension MySQLStatement.Parameter.SmallInteger: InternalMySQLParameterBindingDataType {
    
    var internalValue: CShort { return self.value }
}

extension MySQLStatement.Parameter.Integer: InternalMySQLParameterBindingDataType {
    
    var internalValue: CInt { return self.value }
}





