//
//  SwiftyBeaverLogger.swift
//  SwiftyBeaverProvider
//
//  Created by Gustavo Perdomo on 5/2/17.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

import XCTest
//import Foundation
//import Vapor
//import SwiftyBeaver

@testable import SwiftyBeaverProvider

//class FakeResolver: ResolverProtocol {
//    var executed: String!
//
//    func resolveConsoleDestination(from config: DestinationConfig) throws -> ConsoleDestination {
//        executed = "resolveConsoleDestination"
//        return ConsoleDestination()
//    }
//
//    func resolveFileDestination(from config: DestinationConfig) throws -> FileDestination {
//        executed = "resolveFileDestination"
//        return FileDestination()
//    }
//
//    func resolvePlatformDestination(from config: DestinationConfig) throws -> SBPlatformDestination {
//        executed = "resolvePlatformDestination"
//        return SBPlatformDestination(appID: "", appSecret: "", encryptionKey: "")
//    }
//}
//
class SwiftyBeaverProviderTests: XCTestCase {
//    // MARK: - General
//    func testConfig() throws {
//        let resolver = FakeResolver()
//
//        SwiftyBeaverLogger.resolver = resolver
//
//        try assertExecutedFunction("resolveConsoleDestination", on: resolver, using: ["type": "console"])
//        try assertExecutedFunction("resolveFileDestination", on: resolver, using: ["type": "file"])
//        try assertExecutedFunction("resolvePlatformDestination", on: resolver, using: ["type": "platform", "app": "xxxxxx", "secret": "yyyyyy", "key": "zzzzzz"])
//    }
//
//    func testMissingFile() throws {
//        let config = try Config(node: [
//            "droplet": ["log": "swiftybeaver"]
//            ])
//
//        try assertError(config: config, expectedError: ConfigError.missingFile(CONFIG_FILE_NAME))
//    }
//
//    func testMissingDestinations() throws {
//        // No Array
//        var config = try Config(node: [
//            "droplet": ["log": "swiftybeaver"],
//            "swiftybeaver": ["foo": "bar"]
//            ])
//
//        try assertError(config: config, expectedError: SwiftyBeaverProviderError.missingDestinations)
//
//        // Empty
//        config = try Config(node: [
//            "droplet": ["log": "swiftybeaver"],
//            "swiftybeaver": []
//            ])
//
//        try assertError(config: config, expectedError: SwiftyBeaverProviderError.missingDestinations)
//    }
//
//    func testInvalidDestinationType() throws {
//        let destination = ["type": "_console"]
//
//        let config = try Config(node: [
//            "droplet": ["log": "swiftybeaver"],
//            "swiftybeaver": [destination]
//            ])
//
//        try assertError(config: config, expectedError: SwiftyBeaverProviderError.invalidDestinationType)
//    }
//
//    func testLogLevelExtension() throws {
//        XCTAssertEqual(LogLevel.custom("").sbStyle, SwiftyBeaver.Level.debug)
//        XCTAssertEqual(LogLevel.debug.sbStyle, SwiftyBeaver.Level.debug)
//        XCTAssertEqual(LogLevel.error.sbStyle, SwiftyBeaver.Level.error)
//        XCTAssertEqual(LogLevel.fatal.sbStyle, SwiftyBeaver.Level.error)
//        XCTAssertEqual(LogLevel.info.sbStyle, SwiftyBeaver.Level.info)
//        XCTAssertEqual(LogLevel.verbose.sbStyle, SwiftyBeaver.Level.verbose)
//        XCTAssertEqual(LogLevel.warning.sbStyle, SwiftyBeaver.Level.warning)
//    }
//
// MARK: Helpers

//    func assertExecutedFunction(_ functionName: String, on resolver: FakeResolver, using destination: JSON) throws {
//        let config = try Config(node: [
//            "droplet": ["log": "swiftybeaver"],
//            "swiftybeaver": [destination]
//            ])
//
//        try config.addProvider(Provider.self)
//        let drop = try Droplet(config)
//
//        XCTAssertNotNil(drop)
//        XCTAssertEqual(functionName, resolver.executed)
//    }
//
//    func assertError(config: Config, expectedError: ConfigError) throws {
//        try config.addProvider(Provider.self)
//
//        XCTAssertThrowsError(try Droplet(config)) { error in
//            guard let e = error as? ConfigError else {
//                XCTFail()
//                return
//            }
//
//            XCTAssertEqual(e.description, expectedError.description)
//        }
//    }
//
//    func assertError(config: Config, expectedError: SwiftyBeaverProviderError) throws {
//        try config.addProvider(Provider.self)
//
//        XCTAssertThrowsError(try Droplet(config)) { error in
//            XCTAssertEqual(error as? SwiftyBeaverProviderError, expectedError)
//        }
//    }
}

// MARK: Manifest

extension SwiftyBeaverProviderTests {
    func testLinuxTestSuiteIncludesAllTests() throws {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            let thisClass = type(of: self)
            let linuxCount = thisClass.allTests.count
            let darwinCount = Int(thisClass.defaultTestSuite.testCaseCount)

            XCTAssertEqual(linuxCount, darwinCount, "\(darwinCount - linuxCount) tests are missing from allTests")
        #endif
    }

    static let allTests = [
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
//        ("testConfig", testConfig),
//        ("testMissingFile", testMissingFile),
//        ("testMissingDestinations", testMissingDestinations),
//        ("testInvalidDestinationType", testInvalidDestinationType),
//        ("testLogLevelExtension", testLogLevelExtension)
    ]
}
