//
//  Option.swift
//  OptionKit
//
//  Created by Blake Merryman on 1/25/15.
//  Copyright (c) 2016 Blake Merryman. All rights reserved.
//

/** 
 Block type used for an Option's completion handler.
 
 - parameter result: The calculated result that contains an Option and any found argument strings.
 - parameter error: Passes along any parsing error information.
*/
public typealias OptionCompletionBlock = (_ result: Result?, _ error: NSError?) -> ()

/// A command line option.
public struct Option: Equatable {

    /// The option's long flag variation, typically of the form `--flag`.
    public let longFlag: String?
    
    /// The option's short flag variation, typically of the form `-f`.
    public let shortFlag: String?
    
    /// The completion handler that is called when an option has been successfully parsed.
    public let completionHandler: OptionCompletionBlock?
    
    /**
     Helper method that checks whether a string is actually an option flag or not.
     
     - parameter string: A possible option that was found.
     - returns: Boolean value indicating whether a possible option is actually an option or not.
     */
    public func checkIfOption(_ possibleFlag: String) -> Bool {
        
        return (possibleFlag == longFlag) || (possibleFlag == shortFlag)
    }

}

// MARK: - + Equatable

public func ==(lhs: Option, rhs: Option) -> Bool {
    
    return (lhs.longFlag == rhs.longFlag) && (lhs.shortFlag == rhs.shortFlag)
}
