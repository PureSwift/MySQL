//
//  DataType.swift
//  MySQL
//
//  Created by Alsey Coleman Miller on 12/4/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import CMySQL

public extension MySQL {
    
    public enum DataType: String {
        
        case TinyInt            = "TINYINT"
        case SmallInt           = "SMALLINT"
        case Int                = "INT"
        case MediumInt          = "MEDIUMINT"
        case BigInt             = "BIGINT"
        case Float              = "FLOAT"
        case Double             = "DOUBLE"
        case Real               = "REAL"
        case Decimal            = "DECIMAL"
        case Bit                = "BIT"
        case Serial             = "SERIAL"
        case Bool               = "BOOL"
        case Boolean            = "BOOLEAN"
        case Dec                = "DEC"
        case Fixed              = "FIXED"
        case Numeric            = "NUMERIC"
        case Char               = "CHAR"
        case VarChar            = "VARCHAR"
        case TinyText           = "TINYTEXT"
        case Text               = "TEXT"
        case MediumText         = "MEDIUMTEXT"
        case LongText           = "LONGTEXT"
        case TinyBlob           = "TINYBLOB"
        case MediumBlob         = "MEDIUMBLOB"
        case Blob               = "BLOB"
        case LongBlob           = "LONGBLOB"
        case Binary             = "BINARY"
        case VarBinary          = "VARBINARY"
        case Enum               = "ENUM"
        case Set                = "SET"
        case Date               = "DATE"
        case Datetime           = "DATETIME"
        case Timestamp          = "TIMESTAMP"
        case Time               = "TIME"
        case Year               = "YEAR"
        case Geometry           = "GEOMETRY"
        case Point              = "POINT"
        case LineString         = "LINESTRING"
        case Polygon            = "POLYGON"
        case MultiPoint         = "MULTIPOINT"
        case MultiLineString    = "MULTILINESTRING"
        case MultiPolygon       = "MULTIPOLYGON"
        case GeometryCollection = "GEOMETRYCOLLECTION"
        case Json               = "JSON"
        
        internal var bufferType: enum_field_types {
            
            switch self {
                
            case .TinyInt: return MYSQL_TYPE_TINY
            case .SmallInt: return MYSQL_TYPE_SHORT
            case .MediumInt: return MYSQL_TYPE_INT24
            case .Int: return MYSQL_TYPE_LONG
            case .BigInt: return MYSQL_TYPE_LONGLONG
            case .Float: return MYSQL_TYPE_FLOAT
            case .Double: return MYSQL_TYPE_DOUBLE
            case .Time: return MYSQL_TYPE_TIME
            case .tim
            }
        }
    }
}