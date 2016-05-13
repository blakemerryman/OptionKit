//
//  Result.swift
//  OptionKit
//
//  Created by Blake Merryman on 1/25/15.
//  Copyright (c) 2016 Blake Merryman. All rights reserved.
//

/// The result of parsing a command line option.
public struct Result {
    
    /// The Option that was parsed.
    public let option: Option
    
    /// The arguments that were parsed along with the Option, if any.
    public let arguments: [String]?
    
}