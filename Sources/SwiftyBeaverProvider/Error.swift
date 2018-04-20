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
    case missingKey(key: String)
    case thresholdOutOfRange
}

extension SwiftyBeaverProviderError: Debuggable {
    public var identifier: String {
        switch self {
        case .missingDestinations:
            return "SBP-MISSING_DEST"
        case .missingKey:
            return "SBP-MISSING_KEY"
        case .thresholdOutOfRange:
            return "SBP-THRESHOLD_OUT_OF_RANGE"
        }
    }
    public var reason: String {
        switch self {
        case .missingDestinations:
            return "At least one destination type is required."
        case .missingKey(let key):
            return "The key '\(key)' in missing or empty."
        case .thresholdOutOfRange:
            return "Threshold out of range."
        }
    }
}
