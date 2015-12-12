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

// MARK: - Supporting Types

internal protocol InternalParameterBinding: class {
    
    static var fieldType: enum_field_types { get }
    
    var buffer: UnsafeMutablePointer<Void> { get }
    
    var bufferLength: UInt { get }
}

extension InternalParameterBinding {
    
    var bufferLength: UInt { return 0 }
}

// MARK: Tiny

public extension MySQLStatement {
    
    public final class TinyParameterBinding {
        
        public var value: CShort {
            
            get { return internalPointer.memory }
            
            set { internalPointer.memory = newValue }
        }
        
        // MARK: Internal Properties
        
        internal static let fieldType = MYSQL_TYPE_TINY
        
        internal let internalPointer: UnsafeMutablePointer<CShort>
        
        internal lazy var buffer: UnsafeMutablePointer<Void> = {
            
            return UnsafeMutablePointer<Void>(self.internalPointer)
        }()
        
        // MARK:Initialization
        
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

