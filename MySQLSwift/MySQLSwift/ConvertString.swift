//
//  ConvertString.swift
//  MySQLSwift
//
//  Created by Alsey Coleman Miller on 12/4/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

// returns an allocated buffer holding the string's contents and the full size in bytes which was allocated
// An empty (but not nil) string would have a count of 1
func convertString(s: String?) -> (UnsafeMutablePointer<Int8>, Int) {
    var ret: (UnsafeMutablePointer<Int8>, Int) = (UnsafeMutablePointer<Int8>(), 0)
    guard let notNilString = s else {
        return ret
    }
    notNilString.withCString { p in
        var c = 0
        while p[c] != 0 {
            c += 1
        }
        c += 1
        let alloced = UnsafeMutablePointer<Int8>.alloc(c)
        alloced.initialize(0)
        for i in 0..<c {
            alloced[i] = p[i]
        }
        alloced[c-1] = 0
        ret = (alloced, c)
    }
    return ret
}

func cleanConvertedString(pair: (UnsafeMutablePointer<Int8>, Int)) {
    if pair.1 > 0 {
        pair.0.destroy()
        pair.0.dealloc(pair.1)
    }
}