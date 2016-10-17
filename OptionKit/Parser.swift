//
//  Parser.swift
//  OptionKit
//
//  Created by Blake Merryman on 1/25/15.
//  Copyright (c) 2016 Blake Merryman. All rights reserved.
//

import Foundation

// MARK: - Public API

/// Command line option parser.
public struct Parser {
    
    /**
     Designated initializer.
     
     - parameter options: Array of Options to attempting parsing.
     */
    public init(options: [Option]) {
        parserOptions = options
    }
    
    /**
     Parses options and their arguments. This method anticipates being passed an unaltered 
     `Process.arguments` as its arguments parameter. We should always get at least one argument 
     from `Process.arguments` (zeroth argument should be equivalent to `/.../path/to/file/file.swift`).
     
     - parameter processArguments: Should be the standard input from `Process.arguments`.
     - returns: Parsed options and their arguments in the form of Results.
     */
    public func parseProcessArguments(_ processArguments: [String]) -> [Result]? {
        
        if processArguments.count < 1 {
            return nil
        }
        
        var mutableArguments = processArguments
        mutableArguments.remove(at: 0) // Trim Zeroth argument to isolate user's input.
        
        let results = processUserInput(mutableArguments, withParserOptions: parserOptions)
        performCompletionHandlersForOptions(self.parserOptions, withResults: results)
        
        return results
    }
    
    /**
     Constructor method that handles initializing and parsing the process arguments.
     
     - parameter options: Array of Options to attempting parsing.
     - parameter processArguments: Should be the standard input from `Process.arguments`.
     - returns: Parsed options and their arguments in the form of Results.
     */
    public static func parseProcessArguments(_ processArguments: [String], againstOptions options: [Option]) -> [Result]? {
        
        return Parser(options: options).parseProcessArguments(processArguments)
    }
    
    // MARK: Private: Stored Properties
    
    /// Options that have been parsed.
    let parserOptions: [Option]
    
}

// MARK: - Private API

extension Parser {
    
    /**
     Processes the user's input based on the Parser's options.
     
     - Iterate through user's input
     - Look for flags. When found, save flag and any trailing args.
     - Store them in array of Results
     
     - parameter userInput: Array of Strings representing the user's input
     - parameter options: Array of Options that were used to initialize the Parser
     - returns: Array of processed Result objects
     */
    func processUserInput(_ userInput: [String], withParserOptions options: [Option]) -> [Result] {

        // e.g. ["--optA", "one", "two", "three", "--optB", "four", "five", "six"]

        /// Helper block that saves a result and clears the buffers.
        let processBuffers = {
            
            (optionBuffer: inout Option?, argumentBuffer: inout [String], results: inout [Result]) in
            
            if let option = optionBuffer {
                results.append( Result(option: option, arguments: argumentBuffer) )
                argumentBuffer.removeAll(keepingCapacity: false)
                optionBuffer = nil
            }
        }
        
        var processedResults      = [Result]()
        var optionBuffer: Option? = nil
        var argumentBuffer        = [String]()
        
        for input in userInput {
            
            guard let option = checkInput(input, againstOptions: options) else {
                argumentBuffer.append(input)
                continue
            }
            
            processBuffers(&optionBuffer, &argumentBuffer, &processedResults)
            optionBuffer = option
        }
        
        processBuffers(&optionBuffer, &argumentBuffer, &processedResults)
        
        return processedResults
    }
    
    /// Checks if the input string matches any of the options
    func checkInput(_ input: String, againstOptions options: [Option]) -> Option? {
        
        for option in options as [Option]
            where option.checkIfOption(input) {
                return option
        }
        
        return nil
    }
    
    func performCompletionHandlersForOptions(_ options: [Option], withResults results: [Result]) {
        
        for option in options {
            if let matchingResult = results.filter({ $0.option == option }).first {
                option.completionHandler?(matchingResult, nil)
            }
        }
    }

}


