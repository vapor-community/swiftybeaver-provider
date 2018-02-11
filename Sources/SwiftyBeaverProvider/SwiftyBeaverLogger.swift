//
//  SwiftyBeaverLogger.swift
//  SwiftyBeaverProvider
//
//  Created by Gustavo Perdomo on 5/2/17.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

import Logging
import Foundation
import Service
@_exported import SwiftyBeaver

public final class SwiftyBeaverLogger: Logger {
    /// The swiftybeaver instance
    private let swiftybeaver: SwiftyBeaver.Type = SwiftyBeaver.self

    /// The config resolver
    public static var resolver: ResolverProtocol = Resolver()

    /// Create a new swiftybeaver logger from Destinations
    public init(destinations: [BaseDestination]) {
        for destination in destinations {
            swiftybeaver.addDestination(destination)
        }
    }

    /// Create a new swiftybeaver logger from Data
    public convenience init(data: Data) throws {
        let configs: [DestinationConfig] = try JSONDecoder().decode([DestinationConfig].self, from: data)
        try self.init(configs: configs)
    }

    /// Create a new swiftybeaver logger from Destination Configs
    public convenience init(configs: [DestinationConfig]) throws {
        var destinations = [BaseDestination]()

        for config in configs {
            let destination = try SwiftyBeaverLogger.resolver.resolve(from:config)

            destinations.append(destination)
        }

        guard !destinations.isEmpty else {
            throw SwiftyBeaverProviderError.missingDestinations
        }

        self.init(destinations: destinations)
    }

    public func log(_ string: String, at level: LogLevel, file: String, function: String, line: UInt, column: UInt) {
        swiftybeaver.custom(level: level.style, message: string, file: file, function: function, line: Int(line))
    }
}

extension SwiftyBeaverLogger: Service { }

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
