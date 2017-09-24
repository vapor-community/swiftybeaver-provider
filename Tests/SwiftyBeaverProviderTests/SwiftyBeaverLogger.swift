//
//  SwiftyBeaverLogger.swift
//  SwiftyBeaverProvider
//
//  Created by Gustavo Perdomo on 5/2/17.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

import XCTest
import Foundation
import Vapor
import SwiftyBeaver

@testable import SwiftyBeaverProvider

class FakeResolver: ResolverProtocol {
    var executed: String!

    func resolveConsoleDestination(using config: JSON) throws -> ConsoleDestination {
        executed = "resolveConsoleDestination"
        return ConsoleDestination()
    }

    func resolveFileDestination(using config: JSON) throws -> FileDestination {
        executed = "resolveFileDestination"
        return FileDestination()
    }

    func resolveSBPlatformDestination(using config: JSON) throws -> SBPlatformDestination {
        executed = "resolveSBPlatformDestination"
        return SBPlatformDestination(appID: "", appSecret: "", encryptionKey: "")
    }
}

class SwiftyBeaverProviderTests: XCTestCase {
    // MARK: - General
    func testConfig() throws {
        let resolver = FakeResolver()

        SwiftyBeaverLogger.resolver = resolver

        try assertExecutedFunction("resolveConsoleDestination", on: resolver, using: ["type": "console"])
        try assertExecutedFunction("resolveFileDestination", on: resolver, using: ["type": "file"])
        try assertExecutedFunction("resolveSBPlatformDestination", on: resolver, using: ["type": "platform", "app": "xxxxxx", "secret": "yyyyyy", "key": "zzzzzz"])
    }

    func assertExecutedFunction(_ functionName: String, on resolver: FakeResolver, using destination: JSON) throws {
        let config = try Config(node: [
            "droplet": ["log": "swiftybeaver"],
            "swiftybeaver": [destination]
            ])

        try config.addProvider(Provider.self)
        let drop = try Droplet(config)

        XCTAssertNotNil(drop)
        XCTAssertEqual(functionName, resolver.executed)
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
        ("testConfig", testConfig)
    ]
}
