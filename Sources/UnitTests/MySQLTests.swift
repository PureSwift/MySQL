//
//  MySQLTests.swift
//  MySQLTests
//
//  Created by Alsey Coleman Miller on 10/10/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import XCTest
import MySQL
import SwiftFoundation

class MySQLTests: XCTestCase {
    
    var allTests : [(String, () -> Void)] {
        return [
            ("testNewDB", testNewDB)
        ]
    }
    
    func testNewDB() {
        
        let connection = MySQL.Connection()
        
        do { try connection.connect(user: user, password: password, socket: "/var/run/mysqld/mysqld.sock") }
            
        catch { XCTFail("Could not connect: \(error)"); return }
        
        let secondsSinceReferenceDate = Int(Date().timeIntervalSinceReferenceDate)
        
        let databaseName = "TestDatabase\(secondsSinceReferenceDate)"
        
        print("Creating test database: " + databaseName)
        
        // create DB, insert data, and then fetch
        do {
            
            try connection.createDatabase(databaseName)
            
            try connection.selectDatabase(databaseName)
            
            try connection.query("CREATE TABLE family (Name char(20),Room char(8),Phone char(24))")
            
            try connection.query("INSERT INTO family VALUES ('Gomez Adams', 'master', '1-555-1212')")
            
            guard let result = try connection.query("SELECT * FROM family") where result.rowCount == 1
                else { XCTFail("No results returned"); return }
            
            var stringResults = [[String]]()
            
            for (_, row) in EnumerateGenerator(result.rows) {
                
                let stringValues = row.values.map { (data) in String(UTF8Data: data)! }
                
                stringResults.append(stringValues)
            }
            
            // print
            print("Results: ")
            for (index, row) in stringResults.enumerate() { print("\(index) = \(row)") }
            
            #if os(OSX)
                XCTAssert(stringResults == [["Gomez Adams", "master", "1-555-1212"]], "Results must match inserted data")
            #else
                XCTAssert(stringResults.count == 1)
                XCTAssert(stringResults[0][0] == "Gomez Adams")
                XCTAssert(stringResults[0][1] == "master")
                XCTAssert(stringResults[0][2] == "1-555-1212")
            #endif
            
        }
        
        catch { XCTFail("Error: \(error))") }
    }
    
}
