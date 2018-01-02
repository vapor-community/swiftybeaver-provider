//
//  Config.swift
//  SwiftyBeaverProvider
//
//  Created by Gustavo Perdomo on 1/1/18.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

enum DestinationType: String, Codable {
    case console
    case file
    case platform
}

enum DestinationLevel: String, Codable {
    case debug
    case error
    case info
    case verbose
    case warning
}

public struct DestinationConfig: Codable {
    let type: DestinationType
    
    // Console - Commons
    private(set) var async: Bool? = nil
    private(set) var format: String? = nil
    private(set) var minLevel: DestinationLevel? = nil
    private(set) var levelString: LevelString? = nil
    
    //  File
    private(set) var path: String? = nil
    
    // Platform
    private(set) var app: String? = nil
    private(set) var secret: String? = nil
    private(set) var key: String? = nil
    private(set) var threshold: Int? = nil
    
    init(type: DestinationType, async: Bool? = nil, format: String? = nil, minLevel: DestinationLevel? = nil, levelString: LevelString? = nil) {
        
        self.type = type
        self.async = async
        self.format = format
        self.minLevel = minLevel
        self.levelString = levelString
    }
    
    init(type: DestinationType, async: Bool? = nil, format: String? = nil, minLevel: DestinationLevel? = nil, levelString: LevelString? = nil, path: String? = nil) {
        
        self.type = type
        self.async = async
        self.format = format
        self.minLevel = minLevel
        self.levelString = levelString
        self.path = path
    }
    
    init(app: String?  = nil, secret: String? = nil, key: String? = nil, threshold: Int? = nil, minLevel: DestinationLevel? = nil) {
        self.type = .platform
        self.app = app
        self.secret = secret
        self.key = key
        self.threshold = threshold
        self.minLevel = minLevel
    }
}

extension DestinationLevel {
    func sbLevel() -> SwiftyBeaver.Level {
        switch self {
        case .debug:
            return SwiftyBeaver.Level.debug
        case .error:
            return SwiftyBeaver.Level.error
        case .info:
            return SwiftyBeaver.Level.info
        case .verbose:
            return SwiftyBeaver.Level.verbose
        case .warning:
            return  SwiftyBeaver.Level.warning
        }
    }
}

struct LevelString: Codable {
    let debug: String?
    let error: String?
    let info: String?
    let verbose: String?
    let warning: String?
}
