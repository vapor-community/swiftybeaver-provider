//
//  Provider.swift
//  SwiftyBeaverProvider
//
//  Created by Gustavo Perdomo on 2/11/18.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

import Service
import Vapor
import Foundation

public final class SwiftyBeaverProvider: Provider {
    /// See Provider.repositoryName
    public static let repositoryName = "swiftybeaver-provider"

    /// Create a new SwiftyBeaver provider.
    public init() { }

    /// See Provider.register
    public func register(_ services: inout Services) throws {
        services.register([], tag: "swiftybeaver", isSingleton: true) { container -> SwiftyBeaverLogger in
            let dirConfig: DirectoryConfig = try container.make(for: DirectoryConfig.self)
            // Locate the swiftybeaver.json
            let data = FileManager.default.contents(atPath: "\(dirConfig.workDir)Config/swiftybeaver.json")!

            let destinations: [DestinationConfig] = try JSONDecoder().decode([DestinationConfig].self, from: data)

            return try SwiftyBeaverLogger(configs: destinations)
        }
    }

    /// See Provider.boot
    public func boot(_ container: Container) throws {}
}
