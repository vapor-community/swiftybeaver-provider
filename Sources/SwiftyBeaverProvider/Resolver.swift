//
//  Resolver.swift
//  SwiftyBeaverProvider
//
//  Created by Gustavo Perdomo on 9/12/17.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

import SwiftyBeaver
import Vapor
import Foundation

enum DestinationType: String {
    case console
    case file
    case platform
}

struct Resolver {
    func resolveDestination(of type: DestinationType, using config: JSON) throws -> BaseDestination {
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
        
        return destination
    }
    
    func resolveConsoleDestination(using config: JSON) throws -> ConsoleDestination {
        let destination = ConsoleDestination()
        return try configureCommonsProperties(destination, using: config)
    }
    
    func resolveFileDestination(using config: JSON) throws -> FileDestination {
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
    
    func resolvePlatformDestination(using config: JSON) throws -> SBPlatformDestination {
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
    
    func configureCommonsProperties<T>(_ destination: T, using config: JSON) throws -> T where T: BaseDestination {
        if let format: String = try config.get("format") {
            destination.format = format
        }
        
        if let a = config["async"] {
            guard let async = a.bool else {
                throw ConfigError.unsupported(value: a.string ?? "-", key: ["async"], file: configFileName)
            }
            
            destination.asynchronously = async
        }
        
        if let debugString = config["levelString.debug"]?.string {
            destination.levelString.debug = debugString
        }
        
        if let errorString = config["levelString.error"]?.string {
            destination.levelString.error = errorString
        }
        
        if let infoString = config["levelString.info"]?.string {
            destination.levelString.info = infoString
        }
        
        if let verboseString = config["levelString.verbose"]?.string {
            destination.levelString.verbose = verboseString
        }
        
        if let warningString = config["levelString.warning"]?.string {
            destination.levelString.warning = warningString
        }
        
        if let minLevel = try getMinLevel(from: config) {
            destination.minLevel = minLevel
        }
        
        return destination
    }
    
    func getMinLevel(from config: JSON) throws -> SwiftyBeaver.Level? {
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
}
