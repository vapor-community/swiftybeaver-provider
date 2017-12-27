//
//  SwiftyBeaverLogger.swift
//  SwiftyBeaverProvider
//
//  Created by Gustavo Perdomo on 5/2/17.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

import Logging
@_exported import SwiftyBeaver

public final class SwiftyBeaverLogger: Logger {
    /// The swiftybeaver instance
    private let swiftybeaver: SwiftyBeaver.Type = SwiftyBeaver.self

    /// Create a new swiftybeaver logger
    public init(destinations: [BaseDestination]) {
        for destination in destinations {
            swiftybeaver.addDestination(destination)
        }
    }

    public func log(_ string: String, at level: LogLevel, file: String, function: String, line: UInt, column: UInt) {
        swiftybeaver.custom(level: level.style, message: string, file: file, function: function, line: Int(line))
    }

    //     public static var resolver: ResolverProtocol = Resolver()

    //     public var enabled: [LogLevel] = LogLevel.all

    //     public func log(_ level: LogLevel, message: String, file: String, function: String, line: Int) {
    //         // log to SwiftyBeaver
    //         sb.custom(level: level.sbStyle, message: message, file: file, function: function, line: line)
    //     }
}

// extension SwiftyBeaverLogger: ConfigInitializable {
//     public convenience init(config: Config) throws {
//         guard let file = config[CONFIG_FILE_NAME] else {
//             throw ConfigError.missingFile(CONFIG_FILE_NAME)
//         }

//         guard let configs = file.array else {
//             throw SwiftyBeaverProviderError.missingDestinations
//         }

//         var destinations = [BaseDestination]()

//         for config in configs {
//             guard let type = SBPDestinationType(rawValue: try config.get("type")) else {
//                 throw SwiftyBeaverProviderError.invalidDestinationType
//             }

//             let destination = try SwiftyBeaverLogger.resolver.resolveDestination(of: type, using: JSON(config))

//             destinations.append(destination)
//         }

//         guard !destinations.isEmpty else {
//             throw SwiftyBeaverProviderError.missingDestinations
//         }

//         self.init(destinations: destinations)
//     }
// }

extension LogLevel {
    var style: SwiftyBeaver.Level {
        switch self {
        case .verbose:
            return .verbose
        case .debug, .custom:
            return .debug
        case .info:
            return .info
        case .warning:
            return .warning
        case .error, .fatal:
            return .error
        }
    }
}
