//
//  MySQLTests.swift
//  MySQLTests
//
//  Created by Alsey Coleman Miller on 10/10/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import XCTest
import MySQL
import Cmysqlclient
import SwiftFoundation

class MySQLTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNewDB() {
        
        let connection = MySQL.Connection()
        
        do { try connection.connect(hostname, user: user, password: password, databaseName: nil, port: port, socket: socket) }
            
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
            
            XCTAssert(stringResults == [["Gomez Adams", "master", "1-555-1212"]], "Results must match inserted data")
        }
        
        catch { XCTFail("Error: \(error))") }
    }
    
}
