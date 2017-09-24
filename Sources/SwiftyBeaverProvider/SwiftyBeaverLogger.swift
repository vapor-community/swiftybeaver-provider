//
//  SwiftyBeaverLogger.swift
//  SwiftyBeaverProvider
//
//  Created by Gustavo Perdomo on 5/2/17.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

import Vapor
import SwiftyBeaver
import Foundation

let CONFIG_FILE_NAME = "swiftybeaver"

public final class SwiftyBeaverLogger: LogProtocol {
    public static var resolver: ResolverProtocol = Resolver()

    public var enabled: [LogLevel] = LogLevel.all

    private var sb: SwiftyBeaver.Type = SwiftyBeaver.self

    public init(destinations: [BaseDestination]) {
        for destination in destinations {
            sb.addDestination(destination)
        }
    }

    public func log(_ level: LogLevel, message: String, file: String, function: String, line: Int) {
        // log to SwiftyBeaver
        sb.custom(level: level.sbStyle, message: message, file: file, function: function, line: line)
    }
}

extension SwiftyBeaverLogger: ConfigInitializable {
    public convenience init(config: Config) throws {
        guard let file = config[CONFIG_FILE_NAME] else {
            throw ConfigError.missingFile(CONFIG_FILE_NAME)
        }

        guard let configs: [JSON] = try file.get() else {
            throw ConfigError.unspecified(SwiftyBeaverProviderError.missingDestinations)
        }

        var destinations = [BaseDestination]()

        for config in configs {
            guard let type = SBPDestinationType(rawValue: try config.get("type")) else {
                throw ConfigError.unspecified(SwiftyBeaverProviderError.invalidDestinationType)
            }

            let destination = try SwiftyBeaverLogger.resolver.resolveDestination(of: type, using: config)

            destinations.append(destination)
        }

        guard !destinations.isEmpty else {
            throw ConfigError.unspecified(SwiftyBeaverProviderError.missingDestinations)
        }

        self.init(destinations: destinations)
    }
}

extension LogLevel {
    var sbStyle: SwiftyBeaver.Level {
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
