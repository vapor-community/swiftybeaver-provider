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

private let configFileName = "swiftybeaver"

public final class SwiftyBeaverLogger: LogProtocol {
    public var enabled: [LogLevel]
    private var sb: SwiftyBeaver.Type = SwiftyBeaver.self

    public init(destinations: [BaseDestination]) {
        for destination in destinations {
            sb.addDestination(destination)
        }
        enabled = LogLevel.all
    }

    public func log(_ level: LogLevel, message: String, file: String, function: String, line: Int) {
        if enabled.contains(level) {
            // log to SwiftyBeaver
            sb.custom(level: level.sbStyle, message: message, file: file, function: function, line: line)
        }
    }
}

private enum DestinationType: String {
    case console
    case file
    case platform
}

private func getMinLevel(from config: JSON) throws -> SwiftyBeaver.Level? {
    if let level = config["minLevel"]?.string?.trim().lowercased() {
        switch level {
        case "verbose":
            return SwiftyBeaver.Level.verbose
        case "debug":
            return SwiftyBeaver.Level.debug
        case "info":
            return SwiftyBeaver.Level.info
        case "warning":
            return SwiftyBeaver.Level.warning
        case "error":
            return SwiftyBeaver.Level.error
        default:
            throw SwiftyBeaverProviderError.invalidMinLevel
        }
    }

    return nil
}

private func configureCommonsProperties<T>(_ destination: T, using config: JSON) throws -> T where T: BaseDestination {
    if let format: String = try config.get("format") {
        destination.format = format
    }

    if let a = config["async"] {
        guard let async = a.bool else {
            throw ConfigError.unsupported(value: a.string ?? "-", key: ["async"], file: configFileName)
        }

        destination.asynchronously = async
    }

    if let minLevel = try getMinLevel(from: config) {
        destination.minLevel = minLevel
    }

    return destination
}

private func resolveConsoleDestination(using config: JSON) throws -> ConsoleDestination {
    let destination = ConsoleDestination()
    return try configureCommonsProperties(destination, using: config)
}

private func resolveFileDestination(using config: JSON) throws -> FileDestination {
    let destination = FileDestination()

    if let path = config["path"]?.string {
        guard !path.trim().isEmpty else {
            throw SwiftyBeaverProviderError.invalidPath
        }

        let file = URL(fileURLWithPath: path)
        destination.logFileURL = file
    }

    return try configureCommonsProperties(destination, using: config)
}

private func resolvePlatformDestination(using config: JSON) throws -> SBPlatformDestination {
    guard let app = config["app"]?.string, !app.trim().isEmpty else {
        throw ConfigError.missing(key: ["app"], file: configFileName, desiredType: String.self)
    }

    guard let secret = config["secret"]?.string, !secret.trim().isEmpty else {
        throw ConfigError.missing(key: ["secret"], file: configFileName, desiredType: String.self)
    }

    guard let key = config["key"]?.string, !key.trim().isEmpty else {
        throw ConfigError.missing(key: ["key"], file: configFileName, desiredType: String.self)
    }

    let destination = SBPlatformDestination(appID: app, appSecret: secret, encryptionKey: key)

    if let t = config["threshold"] {
        guard let threshold = t.int else {
            throw ConfigError.unsupported(value: t.string ?? "-", key: ["threshold"], file: configFileName)
        }

        guard threshold >= 1 && threshold <= 1000  else {
            throw ConfigError.unsupported(value: String(describing: threshold), key: ["threshold"], file: configFileName)
        }

        destination.sendingPoints.threshold = threshold
    }

    if let minLevel = try getMinLevel(from: config) {
        destination.minLevel = minLevel
    }

    return destination
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

        for config in configs {
            guard let type = DestinationType(rawValue: try config.get("type")) else {
                throw SwiftyBeaverProviderError.invalidDestinationType
            }

            let destination: BaseDestination

            switch type {
            case .console:
                destination = try resolveConsoleDestination(using: config)

            case .file:
                destination = try resolveFileDestination(using: config)

            case .platform:
                destination = try resolvePlatformDestination(using: config)
                break
            }

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
