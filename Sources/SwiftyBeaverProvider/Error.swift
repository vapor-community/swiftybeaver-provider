//
//  Error.swift
//  SwiftyBeaverProvider
//
//  Created by Gustavo Perdomo on 5/2/17.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

import Debugging

public enum SwiftyBeaverProviderError: Error {
    case missingDestinations
    case invalidDestinationType
    case invalidMinLevel
    case invalidPath
}

extension SwiftyBeaverProviderError: Debuggable {
    public var reason: String {
        switch self {
        case .missingDestinations:
            return "At least one destination type is required."
        case .invalidDestinationType:
            return "Invalid destination type."
        case .invalidMinLevel:
            return "Invalid min level."
        case .invalidPath:
            return "invalid path."
        }
    }

    public var identifier: String {
        switch self {
        case .missingDestinations:
            return "SBP-MISSING_DEST"
        case .invalidDestinationType:
            return "SBP-INVALID_DEST_TYPE"
        case .invalidMinLevel:
            return "SBP-INVALID_MINLVL"
        case .invalidPath:
            return "SBP-INVALID_PATH"
        }
    }

    public var possibleCauses: [String] {
        switch self {
        case .missingDestinations:
            return ["You have not specified proper destinations in the `swiftybeaver` file."]
        case .invalidDestinationType:
            return ["You have not specified a valid destination type: `console`, `file` or `platform`."]
        case .invalidMinLevel:
            return ["You have not specified a valid minLevel: `verbose`, `debug`, `info`, `warning` or `error`."]
        case .invalidPath:
            return ["You have not specified a valid path, ensure is not an empty string"]
        }
    }

    public var suggestedFixes: [String] {
        return [
            "Ensure you have properly configured the SwiftyBeaverProvider package according to the documentation"
        ]
    }

    public var documentationLinks: [String] {
        return [
            "https://github.com/vapor-community/swiftybeaver-provider/"
        ]
    }
}
