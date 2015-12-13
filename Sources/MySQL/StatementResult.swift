//
//  StatementResult.swift
//  MySQL
//
//  Created by Alsey Coleman Miller on 12/11/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import SwiftFoundation
import CMySQL

public extension MySQL {
    
    public enum StatementResultType {
        
        case Null
        
        case Tiny
        case Short
        case Long
        case LongLong
        case Float
        case Double
        
        case Time
        case Date
        case DateTime
        case TimeStamp
        
        case String
        case Blob
    }
}


