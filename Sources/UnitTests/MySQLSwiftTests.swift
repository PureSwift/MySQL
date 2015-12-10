//
//  MySQLTests.swift
//  MySQLTests
//
//  Created by Alsey Coleman Miller on 10/10/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import XCTest
import MySQL

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
        
        let connection: MySQL.Connection
        
        do { try connection = MySQL.Connection(host: hostname, user: user, password: password, db: nil, port: port) }
            
        catch { XCTFail("Could not connect: \(error)"); return }
        
        
    }
    
}
