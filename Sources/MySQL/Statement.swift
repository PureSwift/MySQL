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
    
    public final class Statement {
        
        // MARK: - Private Methods
        
        private let internalPointer: UnsafeMutablePointer<MYSQL_STMT>
        
        // MARK: - Initialization
        
        deinit { mysql_stmt_close(internalPointer) }
        
        public init() {
            
            self.internalPointer = mysql_stmt_init(nil)
        }
        
        // MARK: - Properties
    }
}

