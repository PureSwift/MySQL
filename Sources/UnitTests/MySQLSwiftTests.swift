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
        
        // create DB
        do {
            
            try connection.createDatabase(databaseName)
            
            try connection.selectDatabase(databaseName)
            
            try connection.query("CREATE TABLE family (Name char(20),Room char(8),Phone char(24))")
            
            try connection.query("INSERT INTO family VALUES ('Gomez Adams', 'master', '1-555-1212')")
        }
        
        catch { XCTFail("Error: \(error))") }
    }
    
}
