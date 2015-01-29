//
//  Option.swift
//  BMParse
//
//  Created by Blake Merryman on 1/25/15.
//  Copyright (c) 2015 Blake Merryman. All rights reserved.
//

import Foundation

public struct Option: Equatable {

    public let longFlag: String?
    public let shortFlag: String?
    
    // TODO: Add Error to closure input tuple!!!
    public let completionHandler: (Result!, NSError!) -> ()
    
    public init(longFlag: String?, shortFlag: String?, completionHandler: (Result!, NSError!) -> ()) {
        self.longFlag = longFlag
        self.shortFlag = shortFlag
        self.completionHandler = completionHandler
    }
    
    public func checkIfOption(x: String) -> Bool {
        return (x == longFlag) || (x == shortFlag)
    }

}

public func ==(lhs: Option, rhs: Option) -> Bool {
    return (lhs.longFlag == rhs.longFlag) || (lhs.shortFlag == rhs.shortFlag)
}