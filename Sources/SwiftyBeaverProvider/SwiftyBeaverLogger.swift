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

let configFileName = "swiftybeaver"

public final class SwiftyBeaverLogger: LogProtocol {
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
        guard let file = config[configFileName] else {
            throw ConfigError.missingFile(configFileName)
        }
        
        guard file.array != nil else {
            throw ConfigError.unsupported(value: "---", key: ["---"], file: configFileName)
        }
        
        guard let configs: [JSON] = try file.get() else {
            throw ConfigError.unspecified(SwiftyBeaverProviderError.missingDestinations)
        }
        
        var destinations = [BaseDestination]()
        let resolver = Resolver()
        
        for config in configs {
            guard let type = DestinationType(rawValue: try config.get("type")) else {
                throw SwiftyBeaverProviderError.invalidDestinationType
            }
            
            let destination = try resolver.resolveDestination(of: type, using: config)
            
            destinations.append(destination)
        }
        
        guard !destinations.isEmpty else {
            throw SwiftyBeaverProviderError.missingDestinations
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
