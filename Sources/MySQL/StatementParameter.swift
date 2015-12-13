//
//  StatementParameter.swift
//  MySQL
//
//  Created by Alsey Coleman Miller on 12/11/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import SwiftFoundation
import CMySQL

public extension MySQL {
    
    public enum StatementParameter {
        
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

