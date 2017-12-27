////
////  Error.swift
////  SwiftyBeaverProvider
////
////  Created by Gustavo Perdomo on 5/2/17.
////  Copyright © 2017 Gustavo Perdomo. All rights reserved.
////
//
//import Debugging
//
//public enum SwiftyBeaverProviderError: Error {
//    case noArrayConfig
//    case missingDestinations
//    case invalidDestinationType
//    case invalidMinLevel
//    case thresholdOutOfRange
//}
//
//extension SwiftyBeaverProviderError: Debuggable {
//    public var reason: String {
//        switch self {
//        case .noArrayConfig:
//            return "The \(CONFIG_FILE_NAME) shoud contains an array of configs."
//        case .missingDestinations:
//            return "At least one destination type is required."
//        case .invalidDestinationType:
//            return "Invalid destination type."
//        case .invalidMinLevel:
//            return "Invalid min level."
//        case .thresholdOutOfRange:
//            return "Threshold out of range."
//        }
//    }
//
//    public var identifier: String {
//        switch self {
//        case .missingDestinations:
//            return "SBP-MISSING_DEST"
//        case .invalidDestinationType:
//            return "SBP-INVALID_DEST_TYPE"
//        case .invalidMinLevel:
//            return "SBP-INVALID_MINLVL"
//        case .thresholdOutOfRange:
//            return "SBP-THRESHOLD_OUT_OF_RANGE"
//        case .noArrayConfig:
//            return "SBP-NO_ARRAY_CONFIG"
//        }
//    }
//
//    public var possibleCauses: [String] {
//        switch self {
//        case .noArrayConfig:
//            return ["The `\(CONFIG_FILE_NAME)` can't be parsed as array file."]
//        case .missingDestinations:
//            return ["You have not specified proper destinations in the `\(CONFIG_FILE_NAME)` file."]
//        case .invalidDestinationType:
//            return ["You have not specified a valid destination type: `console`, `file` or `platform`."]
//        case .invalidMinLevel:
//            return ["You have not specified a valid minLevel: `verbose`, `debug`, `info`, `warning` or `error`."]
//        case .thresholdOutOfRange:
//            return ["You have not specified a valid threshold, ensure is between 1 and 1000"]
//        }
//    }
//
//    public var suggestedFixes: [String] {
//        return [
//            "Ensure you have properly configured the SwiftyBeaverProvider package according to the documentation"
//        ]
//    }
//
//    public var documentationLinks: [String] {
//        return [
//            "https://github.com/vapor-community/swiftybeaver-provider/"
//        ]
//    }
//}
