//
//  RouteTests.swift
//  SwiftyBeaverProvider
//
//  Created by Gustavo Perdomo on 5/2/17.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

// swiftlint:disable force_try

import XCTest
import Foundation
import Vapor
@testable import SwiftyBeaverProvider

/// This file shows an example of testing
/// routes through the Droplet.

class VaporSwiftyBeaverTests: XCTestCase {
    func testHappyConfig() throws {
        let config = try Config(node: [
            "droplet": [
                "log": "swiftybeaver"
            ],
            "swiftybeaver": [
                "console": true
            ]
            ])
        
        try config.addProvider(Provider.self)
        let drop = try Droplet(config)
        
        XCTAssertNotNil(drop)
    }
    
    func testInvalidConfig() throws {
        do {
        let config = try Config(node: [
            "droplet": [
                "log": "swiftybeaver"
            ],
            "swiftybeaver": [
            ]
            ])
            
            try config.addProvider(Provider.self)
            let _ = try Droplet(config)
            
            XCTAssertTrue(false)
        } catch {
            XCTAssertTrue(true)
        }
    }
}

// MARK: Manifest

extension VaporSwiftyBeaverTests {
    /// This is a requirement for XCTest on Linux
    /// to function properly.
    /// See ./Tests/LinuxMain.swift for examples
    static let allTests = [
        ("testHappyConfig", testHappyConfig),
        ("testInvalidConfig", testInvalidConfig)
    ]
}
