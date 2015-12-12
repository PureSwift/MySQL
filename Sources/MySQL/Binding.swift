//
//  Binding.swift
//  MySQL
//
//  Created by Alsey Coleman Miller on 12/11/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import SwiftFoundation
import CMySQL

public final class Binding<DataType: MySQLNativeDataType> {
    
    // MARK: - Properties
    
    public var value: DataType {
        
        get { return self.dataPointer.memory }
        
        set { self.dataPointer.memory = newValue }
    }
    
    // MARK: - Internal Properties
    
    internal let internalPointer = UnsafeMutablePointer<MYSQL_BIND>()
    
    internal let dataPointer: UnsafeMutablePointer<DataType>
    
    // MARK: - Initialization
    
    deinit {
        
        internalPointer.destroy()
        internalPointer.dealloc(1)
        
        dataPointer.destroy()
        dataPointer.dealloc(1)
    }
    
    public init(value: DataType) {
        
        // To use a MYSQL_BIND structure, zero its contents to initialize it.
        memset(self.internalPointer, 0, sizeof(MYSQL_BIND))
        
        // initialize data pointer
        self.dataPointer = UnsafeMutablePointer<DataType>.alloc(1)
        
        // set data type
        self.internalPointer.memory.buffer_type = DataType.fieldType
        
        // set data pointer
        self.internalPointer.memory.buffer = unsafeBitCast(self.internalPointer, UnsafeMutablePointer<Void>.self)
        
        
    }
    
    // MARK: - Methods
}

// MARK: - Supporting Types

/// All Swift / C data types that can be converted from MySQL values.
///
/// - Note: Never conform to this protocol! This is only for type safety.
public protocol MySQLNativeDataType {
    
    static var fieldType: enum_field_types { get }
}

extension CChar: MySQLNativeDataType {
    
    public static let fieldType = MYSQL_TYPE_TINY
}

extension enum_field_types {
    
    
}

extension CShort: MySQLNativeDataType {
    
    public static let fieldType = MYSQL_TYPE_SHORT
}

extension CInt: MySQLNativeDataType {
    
    public static let fieldType = MYSQL_TYPE_LONG
}

extension CLongLong: MySQLNativeDataType {
    
    public static let fieldType = MYSQL_TYPE_LONGLONG
}

extension CFloat: MySQLNativeDataType {
    
    public static let fieldType = MYSQL_TYPE_FLOAT
}

extension CDouble: MySQLNativeDataType {
    
    public static let fieldType = MYSQL_TYPE_DOUBLE
}

extension MYSQL_TIME: MySQLNativeDataType {
    
    public static let fieldType = MYSQL_TYPE_TIME
}



