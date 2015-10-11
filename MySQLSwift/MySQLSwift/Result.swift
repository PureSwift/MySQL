//
//  Result.swift
//  MySQLSwift
//
//  Created by Alsey Coleman Miller on 10/11/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import SwiftFoundation
import mysql

public extension MySQL {
    
    public struct Result {
        
        public var rowCount: Int = 0
        
        public var fields: [Field]
        
        public var
        
        // MARK: - Initialization
        
        /// Extracts values
        init?(internalPointer: UnsafeMutablePointer<MYSQL>) throws {
            
            
        }
    }
}