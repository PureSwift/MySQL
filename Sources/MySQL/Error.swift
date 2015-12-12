//
//  Error.swift
//  MySQL
//
//  Created by Alsey Coleman Miller on 10/11/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import CMySQL

public extension MySQL {
    
    public enum Error: ErrorType {
        
        /// ```mysql_store_result()``` should have returned data
        case BadResult
        
        /// Could not fetch the entire result. 
        case NotEndOfFile
        
        /// MySQL Server or Client error code and description
        case ErrorCode(UInt32, String)
    }
}


