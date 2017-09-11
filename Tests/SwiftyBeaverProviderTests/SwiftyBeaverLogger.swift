//
//  RouteTests.swift
//  SwiftyBeaverProvider
//
//  Created by Gustavo Perdomo on 5/2/17.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

import XCTest
import Foundation
import Vapor
@testable import SwiftyBeaverProvider

class SwiftyBeaverProviderTests: XCTestCase {
    func testValidConfig(using destinations: [JSON]) throws {
        let config = try Config(node: [
            "droplet": ["log": "swiftybeaver"],
            "swiftybeaver": destinations
            ])

        try config.addProvider(Provider.self)

        let drop = try Droplet(config)
        XCTAssertNotNil(drop)
    }

    func testInvalidConfig(using destinations: [JSON]) throws {
        do {
            try testValidConfig(using: destinations)
            XCTFail("The config is valid")
        } catch {
            XCTAssertTrue(true)
        }
    }

    func testMultipleDestinationConfig() throws {
        let destinations: [JSON] = [
            ["type": "console"],
            ["type": "file"]
        ]

        try testValidConfig(using: destinations)
    }

    func testValidConsoleConfig() throws {
        var destinations: [JSON] = [[
            "type": "console"
            ]]

        try testValidConfig(using: destinations)

        destinations = [[
            "type": "console",
            "format": " $DHH:mm:ss$d $L: $M",
            "async": true,
            "minLevel": "warning"
            ]]

        try testValidConfig(using: destinations)
    }

    func testInvalidConsoleConfig() throws {
        var destinations: [JSON] = [[
            "type": "console",
            "async": "z"
            ]]

        try testInvalidConfig(using: destinations)

        destinations = [[
            "type": "console",
            "async": true,
            "minLevel": "invalidLevel"
            ]]

        try testInvalidConfig(using: destinations)
    }

    func testValidFileConfig() throws {
        var destinations: [JSON] = [[
            "type": "file"
            ]]

        try testValidConfig(using: destinations)

        destinations = [[
            "type": "file",
            "path": "path/to/file",
            "async": true,
            "minLevel": "verbose"
            ]]

        try testValidConfig(using: destinations)
    }

    func testInvalidFileConfig() throws {
        var destinations: [JSON] = [[
            "type": "file",
            "path": ""
            ]]

        try testInvalidConfig(using: destinations)

        destinations = [[
            "type": "file",
            "minLevel": "invalidLevel"
            ]]

        try testInvalidConfig(using: destinations)
    }

    func testValidPlatformConfig() throws {
        let destinations: [JSON] = [[
            "type": "platform",
            "app": "xxxxxx",
            "secret": "yyyyyy",
            "key": "zzzzzz"
            ]]

        try testValidConfig(using: destinations)
    }

    func testInvalidPlatformConfig() throws {
        var destinations: [JSON] = [[
            "type": "platform",
            "secret": "yyyyyy",
            "key": "zzzzzz"
            ]]

        try testInvalidConfig(using: destinations)

        destinations = [[
            "type": "platform",
            "app": "xxxxxx",
            "key": "zzzzzz"
            ]]

        try testInvalidConfig(using: destinations)

        destinations = [[
            "type": "platform",
            "app": "xxxxxx",
            "secret": "yyyyyy"
            ]]

        try testInvalidConfig(using: destinations)

        destinations = [[
            "type": "platform",
            "app": "xxxxxx",
            "secret": "yyyyyy",
            "key": "zzzzzz",
            "threshold": "--"
            ]]

        try testInvalidConfig(using: destinations)

        destinations = [[
            "type": "platform",
            "app": "xxxxxx",
            "secret": "yyyyyy",
            "key": "zzzzzz",
            "threshold": -1
            ]]

        try testInvalidConfig(using: destinations)

        destinations = [[
            "type": "platform",
            "app": "xxxxxx",
            "secret": "yyyyyy",
            "key": "zzzzzz",
            "threshold": "1001"
            ]]

        try testInvalidConfig(using: destinations)
    }
}

// MARK: Manifest

extension SwiftyBeaverProviderTests {
    func testLinuxTestSuiteIncludesAllTests() throws {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            let thisClass = type(of: self)
            let linuxCount = thisClass.allTests.count
            #if swift(>=4.0)
                let darwinCount = Int(thisClass.defaultTestSuite.testCaseCount)
            #else
                let darwinCount = Int(thisClass.defaultTestSuite().testCaseCount)
            #endif

            XCTAssertEqual(linuxCount, darwinCount, "\(darwinCount - linuxCount) tests are missing from allTests")
        #endif
    }

    static let allTests = [
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests),
        ("testMultipleDestinationConfig", testMultipleDestinationConfig),
        ("testValidConsoleConfig", testValidConsoleConfig),
        ("testInvalidConsoleConfig", testInvalidConsoleConfig),
        ("testValidFileConfig", testValidFileConfig),
        ("testInvalidFileConfig", testInvalidFileConfig),
        ("testValidPlatformConfig", testValidPlatformConfig),
        ("testInvalidPlatformConfig", testInvalidPlatformConfig)
    ]
}
