//
//  Field.swift
//  MySQL
//
//  Created by Alsey Coleman Miller on 10/11/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import Cmysqlclient

public extension MySQL {
    
    public struct Field {
        
        /// Name of column
        ///
        /// The name of the field, as a null-terminated string. 
        /// If the field was given an alias with an ```AS``` clause, the value of ```name``` is the alias.
        /// For a procedure parameter, the parameter name.
        public var name: String
        
        /// Original column name, if an alias.
        ///
        /// The name of the field, as a null-terminated string. 
        /// Aliases are ignored. For expressions, the value is an empty string. 
        /// For a procedure parameter, the parameter name.
        public var originalName: String
        
        /// Table of column if column was a field.
        ///
        /// The name of the table containing this field, if it is not a calculated field. 
        /// For calculated fields, the table value is an empty string. 
        /// If the column is selected from a view, table names the view. 
        /// If the table or view was given an alias with an ```AS``` clause, the value of table is the alias.
        /// For a ```UNION```, the value is the empty string. For a procedure parameter, the procedure name.
        public var table: String
        
        /// Original table name, if table was an alias.
        public var originalTable: String
        
        /// Database for table. 
        public var database: String
        
        /// Catalog for table. 
        public var catalog: String
        
        /// The default value of this field, as a null-terminated string. This is set only if you use ```mysql_list_fields()```.
        //public var defaultValue: String
        
        /// The width of the field. This corresponds to the display length, in bytes.
        ///
        /// The server determines the length value before it generates the result set, 
        /// so this is the minimum length required for a data type capable of holding the largest possible value 
        /// from the result column, without knowing in advance the actual values that will be produced by the query 
        /// for the result set.
        public var length: UInt
        
        /// The maximum width of the field for the result set 
        /// (the length in bytes of the longest field value for the rows actually in the result set).
        ///
        /// - Note: The value of ```max_length``` is the length of the string representation of the values in the result set.
        /// For example, if you retrieve a ```FLOAT``` column and the “widest” value is ```-12.345```,
        /// ```max_length``` is 7 (the length of '```-12.345```').
        public var maxLength: UInt
        
        //public var flags: [Flag]
    }
}

// MARK: - Initialization

internal extension MySQL.Field {
    
    internal init(internalPointer: UnsafeMutablePointer<MYSQL_FIELD>) {
        
        self.name = String.fromCString(internalPointer.memory.name)!
        self.originalName = String.fromCString(internalPointer.memory.org_name)!
        self.table = String.fromCString(internalPointer.memory.table)!
        self.originalTable = String.fromCString(internalPointer.memory.org_table)!
        self.database = String.fromCString(internalPointer.memory.db)!
        self.catalog = String.fromCString(internalPointer.memory.catalog)!
        self.length = internalPointer.memory.length
        self.maxLength = internalPointer.memory.max_length
    }
}

