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
    
    public enum ParameterBinding {
        
        case Tiny(TinyParameterBinding)
        
        internal var internalBinding: InternalParameterBinding {
            
            switch self {
                
            case let .Tiny(binding): return binding
            }
        }
    }
}

public extension MySQLStatement {
    
    /// Binds parameters to the statement. 
    public func bind(parameters: [ParameterBinding]) throws {
        
        let bindingsPointer = UnsafeMutablePointer<MYSQL_BIND>.alloc(parameters.count)
        
        // To use a MYSQL_BIND structure, zero its contents to initialize it, then set its members appropriately.
        memset(bindingsPointer, 0, parameters.count)
        
        for (index, binding) in parameters.enumerate() {
            
            let internalBinding = binding.internalBinding
            
            bindingsPointer[index].buffer_type = internalBinding.dynamicType.fieldType
            
            bindingsPointer[index].buffer = internalBinding.buffer
            
            bindingsPointer[index].buffer_length = internalBinding.bufferLength
        }
        
        guard mysql_stmt_bind_param(internalPointer, bindingsPointer) == 0 else {
            
            bindingsPointer.dealloc(parameters.count)
            
            throw statusCodeError
        }
        
        
        
        if let previousBindingsPointer = self.internalParametersPointer {
            
            let previousParameters
        }
        
        self.internalParametersPointer = bindingsPointer
        self.parameterBindings = parameters
    }
}

// MARK: - Supporting Types

internal protocol InternalParameterBinding: class {
    
    static var fieldType: enum_field_types { get }
    
    var buffer: UnsafeMutablePointer<Void> { get }
    
    var bufferLength: UInt { get }
}

extension InternalParameterBinding {
    
    var bufferLength: UInt { return 0 }
}

public extension MySQLStatement {
    
    public final class TinyParameterBinding {
        
        public var value: CShort {
            
            get { return internalPointer.memory }
            
            set { internalPointer.memory = newValue }
        }
        
        // MARK: - Internal Properties
        
        internal static let fieldType = MYSQL_TYPE_TINY
        
        internal let internalPointer: UnsafeMutablePointer<CShort>
        
        internal var buffer: UnsafeMutablePointer<Void> {
            
            return unsafeBitCast(internalPointer, UnsafeMutablePointer<Void>.self)
        }
        
        // MARK: - Initialization
        
        deinit {
            
            internalPointer.dealloc(1)
        }
        
        public init(value: CShort = 0) {
            
            self.internalPointer = UnsafeMutablePointer<CShort>.alloc(1)
            
            self.value = value
        }
    }
}

extension MySQLStatement.TinyParameterBinding: InternalParameterBinding { }

