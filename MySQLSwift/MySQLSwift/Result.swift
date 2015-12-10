//
//  Result.swift
//  MySQLSwift
//
//  Created by Alsey Coleman Miller on 10/11/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import Cmysqlclient

public extension MySQL {
    
    /// **MySQL** Query Result
    public final class Result {
        
        // MARK: - Properties
        
        public lazy var rowCount: Int = {
            
            return Int(mysql_num_rows(self.internalPointer))
        }()
        
        public lazy var fieldCount: Int = {
            
            return Int(mysql_num_fields(self.internalPointer))
        }()
        
        public lazy var fieldLengths: [UInt] = {
            
            let fieldLengths = mysql_fetch_lengths(self.internalPointer)
            
            let lastFieldIndex = self.fieldCount - 1
            
            var lengths = [UInt]()
            
            for i in 0...lastFieldIndex {
                
                let fieldLength = fieldLengths[i]
                
                lengths.append(fieldLength)
            }
            
            return lengths
        }()
        
        public var rows: Rows {
            
            return Rows(result: self)
        }
        
        public var fields: Fields {
            
            return Fields(result: self)
        }
        
        // MARK: - Private Properties
        
        private var internalPointer: UnsafeMutablePointer<MYSQL_RES>
        
        // MARK: - Initialization
        
        deinit {
            
            mysql_free_result(internalPointer)
        }
        
        internal init(internalPointer: UnsafeMutablePointer<MYSQL_RES>) {
            
            self.internalPointer = internalPointer
        }
        
        // MARK: - Methods
        
        public func nextRow() throws -> MySQL.Row? {
            
            // returns pointer to char pointer
            let rowPointer = mysql_fetch_row(internalPointer)
            
            // will be nil with no more rows are availible
            guard rowPointer != nil else {
                
                // rows are still left
                guard mysql_eof(internalPointer) != 0 else { throw Error.NotEndOfFile }
                
                return nil
            }
            
            return MySQL.Row(internalPointer: rowPointer, fieldCount: self.fieldCount, fieldLengths: self.fieldLengths)
        }
        
        public func fieldAtIndex(index: Int) -> Field {
            
            let fieldPointer = mysql_fetch_field_direct(self.internalPointer, UInt32(index))
            
            return MySQL.Field(internalPointer: fieldPointer)
        }
    }
}

// MARK: - Collections

public extension MySQL.Result {
    
    /// Sequence of rows. (Enumeration interface)
    public struct Rows: GeneratorType {
        
        public let result: MySQL.Result
        
        private init(result: MySQL.Result) {
            
            self.result = result
        }
        
        public func next() -> MySQL.Row? {
            
            let nextRow: MySQL.Row?
            
            do { nextRow = try result.nextRow() }
            
            catch { return nil } // EOF error
            
            return nextRow // next row, or none 
        }
    }
}

public extension MySQL.Result {
    
    /// Sequence of fields. (Enumeration interface)
    public struct Fields: CollectionType {
        
        public typealias Index = Int
        
        public let result: MySQL.Result
        
        public var count: Int {
            
            return result.fieldCount
        }
        
        public var startIndex: Int {
            
            return 0
        }
        
        public var endIndex: Int {
            
            return count + 1
        }
        
        private init(result: MySQL.Result) {
            
            self.result = result
        }
        
        public subscript(position: Int) -> MySQL.Field {
            
            return self.result.fieldAtIndex(position)
        }
    }
}

