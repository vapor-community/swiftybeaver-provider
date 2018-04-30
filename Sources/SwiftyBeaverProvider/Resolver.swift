//
//  Resolver.swift
//  SwiftyBeaverProvider
//
//  Created by Gustavo Perdomo on 9/12/17.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

import SwiftyBeaver
import Foundation

public protocol ResolverProtocol {
    func resolve(from config: DestinationConfig) throws -> BaseDestination
    func resolveConsoleDestination(from config: DestinationConfig) throws -> ConsoleDestination
    func resolveFileDestination(from config: DestinationConfig) throws -> FileDestination
    func resolvePlatformDestination(from config: DestinationConfig) throws -> SBPlatformDestination
}

extension ResolverProtocol {
    func resolve(from config: DestinationConfig) throws -> BaseDestination {
        switch config.type {
        case .console:
            return try resolveConsoleDestination(from: config)

        case .file:
            return try resolveFileDestination(from: config)

        case .platform:
            return try resolvePlatformDestination(from: config)
        }
    }
}

class Resolver: ResolverProtocol {
    func resolveConsoleDestination(from config: DestinationConfig) throws -> ConsoleDestination {
        let destination = ConsoleDestination()
        return try configureCommonsProperties(destination, using: config)
    }

    func resolveFileDestination(from config: DestinationConfig) throws -> FileDestination {
        let destination = FileDestination()

        if let path = config.path {
            guard !path.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                throw SwiftyBeaverProviderError.missingKey(key: "path")
            }

            let file = URL(fileURLWithPath: path)
            destination.logFileURL = file
        }

        return try configureCommonsProperties(destination, using: config)
    }

    func resolvePlatformDestination(from config: DestinationConfig) throws -> SBPlatformDestination {
        guard let app = config.app, !app.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw SwiftyBeaverProviderError.missingKey(key: "app")
        }

        guard let secret = config.secret, !secret.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw SwiftyBeaverProviderError.missingKey(key: "secret")
        }

        guard let key = config.key, !key.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw SwiftyBeaverProviderError.missingKey(key: "key")
        }

        let destination = SBPlatformDestination(appID: app, appSecret: secret, encryptionKey: key, serverURL: config.serverURL)

        if let analyticsUserName = config.analyticsUserName {
            destination.analyticsUserName = analyticsUserName
        }

        if let threshold = config.threshold {
            guard threshold >= 1 && threshold <= 1000  else {
                throw SwiftyBeaverProviderError.thresholdOutOfRange
            }

            destination.sendingPoints.threshold = threshold
        }

        if let minLevel = config.minLevel {
            destination.minLevel = minLevel.sbLevel()
        }

        return destination
    }

    func configureCommonsProperties<T>(_ destination: T, using config: DestinationConfig) throws -> T where T: BaseDestination {
        if let format = config.format {
            destination.format = format
        }

        if let async = config.async {
            destination.asynchronously = async
        }

        if let debugString = config.levelString?.debug {
            destination.levelString.debug = debugString
        }

        if let errorString = config.levelString?.error {
            destination.levelString.error = errorString
        }

        if let infoString = config.levelString?.info {
            destination.levelString.info = infoString
        }

        if let verboseString = config.levelString?.verbose {
            destination.levelString.verbose = verboseString
        }

        if let warningString = config.levelString?.warning {
            destination.levelString.warning = warningString
        }

        if let minLevel = config.minLevel {
            destination.minLevel = minLevel.sbLevel()
        }

        return destination
    }
}
