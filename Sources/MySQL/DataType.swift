//
//  DataType.swift
//  MySQL
//
//  Created by Alsey Coleman Miller on 12/4/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

public extension MySQL {
    
    public enum DataType: String {
        
        case TinyInt            = "TINYINT"
        case SmallInt           = "SMALLINT"
        case MediumInt          = "MEDIUMINT"
        case Int                = "INT"
        case BigInt             = "BIGINT"
        case Float              = "FLOAT"
        case Double             = "DOUBLE"
        case DoublePrecision    = "DOUBLE PRECISION"
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
        case JSON               = "JSON"
    }
}
