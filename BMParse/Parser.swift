//
//  Parser.swift
//  BMParse
//
//  Created by Blake Merryman on 1/25/15.
//  Copyright (c) 2015 Blake Merryman. All rights reserved.
//

import Foundation

public class Parser {

    // MARK: - Public API
    
    public init(options: [Option]!) {
        parserOptions = options
    }
    
    
    /// Parses the arguments. This method anticipates being passed an unaltered Process.arguments as
    /// its arguments parameter. We should always get at least one argument from Process.arguments
    /// (zeroth argument should be equivalent to /.../path/to/file/file.swift).
    ///
    /// :param:   arguments Array of Strings that contain the arguments to be parsed
    /// :returns: Parsed results as an array of Result objects
    
    public func parseArguments(var arguments: [String]!) -> [Result]? {

        var results: [Result]?
        
        if arguments.count > 1 {
            arguments.removeAtIndex(0) // Trim Zeroth argument to isolate user's input.
            results = processUserInput(arguments, withParserOptions: parserOptions)
            performCompletionHandlersForOptions(self.parserOptions, withResults: results)
        }
        
        return results
    }
    
    // MARK: - Private API
    
    private let parserOptions: [Option]!
    
    
    /// Processes the user's input based on the Parser's options.
    ///
    /// - Iterate through user's input
    /// - Look for flags. When found, save flag and any trailing args.
    /// - Store them in array of Results
    ///
    /// :param: userInput  Array of Strings representing the user's input
    /// :param: options    Array of Options that were used to initialize the Parser
    /// :returns: Array of processed Result objects
    
    private func processUserInput(userInput: [String]!, withParserOptions options: [Option]!) -> [Result] {
        
        var processedResults = [Result]()
        var optionBuffer: Option? = nil
        var argumentBuffer = [String]()
        
        for input in userInput as [String] {
            
            if let foundOption = checkInput(input, againstOptions: options) {
                if optionBuffer != nil {
                    let processedResult = Result(flag: optionBuffer!, arguments: argumentBuffer)
                    processedResults.append(processedResult)
                    optionBuffer = nil
                    argumentBuffer.removeAll(keepCapacity: false)
                }
                optionBuffer = foundOption
            }
            else {
                argumentBuffer.append(input)
            }
        }
        
        // Make sure the buffers have been cleared...
        if optionBuffer != nil || argumentBuffer.isEmpty == false {
            
            let aResult = Result(flag: optionBuffer, arguments: argumentBuffer)
            processedResults.append(aResult)
        }
        
        return processedResults
    }
    
    private func checkInput(input: String!, againstOptions options: [Option]!) -> Option? {
        
        for option in options as [Option] {
            let isFlag = option.checkIfOption(input)
            
            if isFlag {
                return option
            }
        }
        return nil
    }
    
    private func performCompletionHandlersForOptions(options: [Option]!, withResults results: [Result]!) {
        for result in results {
            for option in options {
                if result.flag == option {
                    option.completionHandler(result, nil)
                }
            }
        }
    }
    
}


