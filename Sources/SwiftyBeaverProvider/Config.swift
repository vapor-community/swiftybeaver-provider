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
    let async: Bool?
    let format: String?
    let minLevel: DestinationLevel?
    let levelString: LevelString?
    
    //  File
    let path: String?
    
    // Platform
    let app: String?
    let secret: String?
    let key: String?
    let threshold: Int?
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
