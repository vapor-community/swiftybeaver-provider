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
    // MARK: - General
    func testMultipleDestinationConfig() throws {
        let destinations: [JSON] = [
            ["type": "console"],
            ["type": "file"]
        ]

        try testValidConfig(using: destinations)
    }

    // MARK: - Console

    func testConsoleCanBeConfiguredProperly() throws {
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

        destinations = [[
            "type": "console",
            "minLevel": "WarNing"
            ]]

        try testValidConfig(using: destinations)
    }

    func testConsoleCannotBeConfiguredWithInvalidType() throws {
        let destinations: [JSON] = [[
            "type": "_console"
            ]]

        try testInvalidConfig(using: destinations, expected: SwiftyBeaverProviderError.invalidDestinationType)
    }

    func testConsoleCannotBeConfiguredWithInvalidAsync() throws {
        let destinations: [JSON] = [[
            "type": "console",
            "async": "not-bool"
            ]]

        try testInvalidConfig(using: destinations, expected: ConfigError.unsupported(value: "not-bool", key: ["async"], file: "swiftybeaver"))
    }

    func testConsoleCannotBeConfiguredWithInvalidMinLevel() throws {
        let destinations: [JSON] = [[
            "type": "console",
            "minLevel": "not-min-level"
            ]]

        try testInvalidConfig(using: destinations, expected: SwiftyBeaverProviderError.invalidMinLevel)
    }

    // MARK: - File

    func testFileCanBeConfiguredProperly() throws {
        var destinations: [JSON] = [[
            "type": "file"
            ]]

        try testValidConfig(using: destinations)

        destinations = [[
            "type": "file",
            "format": " $DHH:mm:ss$d $L: $M",
            "path": "path/to/file",
            "async": true,
            "minLevel": "warning"
            ]]

        try testValidConfig(using: destinations)

        destinations = [[
            "type": "file",
            "minLevel": "WarNing"
            ]]

        try testValidConfig(using: destinations)
    }

    func testFileCannotBeConfiguredWithInvalidType() throws {
        let destinations: [JSON] = [[
            "type": "_file"
            ]]

        try testInvalidConfig(using: destinations, expected: SwiftyBeaverProviderError.invalidDestinationType)
    }

    func testFileCannotBeConfiguredWithInvalidAsync() throws {
        let destinations: [JSON] = [[
            "type": "file",
            "async": "not-bool"
            ]]

        try testInvalidConfig(using: destinations, expected: ConfigError.unsupported(value: "not-bool", key: ["async"], file: "swiftybeaver"))
    }

    func testFileCannotBeConfiguredWithInvalidMinLevel() throws {
        let destinations: [JSON] = [[
            "type": "file",
            "minLevel": "not-min-level"
            ]]

        try testInvalidConfig(using: destinations, expected: SwiftyBeaverProviderError.invalidMinLevel)
    }

    func testFileCannotBeConfiguredWithInvalidPath() throws {
        var destinations: [JSON] = [[
            "type": "file",
            "path": ""
            ]]

        try testInvalidConfig(using: destinations, expected: SwiftyBeaverProviderError.invalidPath)

        destinations = [[
            "type": "file",
            "path": "    "
            ]]

        try testInvalidConfig(using: destinations, expected: SwiftyBeaverProviderError.invalidPath)
    }

    // MARK: - SBPlatform

    func testSBPlatformCannotBeConfiguredProperly() throws {
        var destinations: [JSON] = [[
            "type": "platform",
            "app": "xxxxxx",
            "secret": "yyyyyy",
            "key": "zzzzzz"
            ]]

        try testValidConfig(using: destinations)

        destinations = [[
            "type": "platform",
            "app": "xxxxxx",
            "secret": "yyyyyy",
            "key": "zzzzzz",
            "minLevel": "info",
            "threshold": 10
            ]]

        try testValidConfig(using: destinations)
    }

    func testSBPlatformCannotBeConfiguredWithInvalidType() throws {
        let destinations: [JSON] = [[
            "type": "platform_"
            ]]

        try testInvalidConfig(using: destinations, expected: SwiftyBeaverProviderError.invalidDestinationType)
    }

    func testSBPlatformCannotBeConfiguredWithoutAppId() throws {
        let destinations: [JSON] = [[
            "type": "platform",
            "secret": "yyyyyy",
            "key": "zzzzzz"
            ]]

        try testInvalidConfig(using: destinations, expected: ConfigError.missing(key: ["app"], file: "swiftybeaver", desiredType: String.self))

    }

    func testSBPlatformCannotBeConfiguredWithoutAppSecret() throws {
        let destinations: [JSON] = [[
            "type": "platform",
            "app": "xxxxxx",
            "key": "zzzzzz"
            ]]

        try testInvalidConfig(using: destinations, expected: ConfigError.missing(key: ["secret"], file: "swiftybeaver", desiredType: String.self))

    }

    func testSBPlatformCannotBeConfiguredWithoutAppEncryptationKey() throws {
        let destinations: [JSON] = [[
            "type": "platform",
            "app": "xxxxxx",
            "secret": "yyyyyy"
            ]]

        try testInvalidConfig(using: destinations, expected: ConfigError.missing(key: ["key"], file: "swiftybeaver", desiredType: String.self))
    }

    func testSBPlatformCannotBeConfiguredWithInvalidThreshold() throws {
        var destinations: [JSON] = [[
            "type": "platform",
            "app": "xxxxxx",
            "secret": "yyyyyy",
            "key": "zzzzzz",
            "threshold": 0
            ]]

        try testInvalidConfig(using: destinations, expected: ConfigError.unsupported(value: "0", key: ["threshold"], file: "swiftybeaver"))

        destinations = [[
            "type": "platform",
            "app": "xxxxxx",
            "secret": "yyyyyy",
            "key": "zzzzzz",
            "threshold": 1001
            ]]

        try testInvalidConfig(using: destinations, expected: ConfigError.unsupported(value: "1001", key: ["threshold"], file: "swiftybeaver"))

        destinations = [[
            "type": "platform",
            "app": "xxxxxx",
            "secret": "yyyyyy",
            "key": "zzzzzz",
            "threshold": "---"
            ]]

        try testInvalidConfig(using: destinations, expected: ConfigError.unsupported(value: "---", key: ["threshold"], file: "swiftybeaver"))
    }

    func testSBPlatformCannotBeConfiguredWithInvalidMinLevel() throws {
        let destinations: [JSON] = [[
            "type": "platform",
            "app": "xxxxxx",
            "secret": "yyyyyy",
            "key": "zzzzzz",
            "minLevel": "not-min-level"
            ]]

        try testInvalidConfig(using: destinations, expected: SwiftyBeaverProviderError.invalidMinLevel)

    }

    // MARK: - Helpers

    func testValidConfig(using destinations: [JSON]) throws {
        let config = try Config(node: [
            "droplet": ["log": "swiftybeaver"],
            "swiftybeaver": destinations
            ])

        try config.addProvider(Provider.self)

        let drop = try Droplet(config)
        XCTAssertNotNil(drop)
    }

    func testInvalidConfig(using destinations: [JSON], expected: Error) throws {
        do {
            try testValidConfig(using: destinations)
            XCTFail("The config is valid")
        } catch {
            XCTAssertEqual(String(describing: error), String(describing: expected))
        }
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
        // CONSOLE
        ("testConsoleCanBeConfiguredProperly", testConsoleCanBeConfiguredProperly),
        ("testConsoleCannotBeConfiguredWithInvalidType", testConsoleCannotBeConfiguredWithInvalidType),
        ("testConsoleCannotBeConfiguredWithInvalidAsync", testConsoleCannotBeConfiguredWithInvalidAsync),
        ("testConsoleCannotBeConfiguredWithInvalidMinLevel", testConsoleCannotBeConfiguredWithInvalidMinLevel),
        // FILE
        ("testFileCanBeConfiguredProperly", testFileCanBeConfiguredProperly),
        ("testFileCannotBeConfiguredWithInvalidType", testFileCannotBeConfiguredWithInvalidType),
        ("testFileCannotBeConfiguredWithInvalidAsync", testFileCannotBeConfiguredWithInvalidAsync),
        ("testFileCannotBeConfiguredWithInvalidMinLevel", testFileCannotBeConfiguredWithInvalidMinLevel),
        ("testFileCannotBeConfiguredWithInvalidPath", testFileCannotBeConfiguredWithInvalidPath),
        // SBPlatform
        ("testSBPlatformCannotBeConfiguredProperly", testSBPlatformCannotBeConfiguredProperly),
        ("testSBPlatformCannotBeConfiguredWithInvalidType", testSBPlatformCannotBeConfiguredWithInvalidType),
        ("testSBPlatformCannotBeConfiguredWithoutAppId", testSBPlatformCannotBeConfiguredWithoutAppId),
        ("testSBPlatformCannotBeConfiguredWithoutAppSecret", testSBPlatformCannotBeConfiguredWithoutAppSecret),
        ("testSBPlatformCannotBeConfiguredWithoutAppEncryptationKey", testSBPlatformCannotBeConfiguredWithoutAppEncryptationKey),
        ("testSBPlatformCannotBeConfiguredWithInvalidThreshold", testSBPlatformCannotBeConfiguredWithInvalidThreshold),
        ("testSBPlatformCannotBeConfiguredWithInvalidMinLevel", testSBPlatformCannotBeConfiguredWithInvalidMinLevel)
    ]
}
