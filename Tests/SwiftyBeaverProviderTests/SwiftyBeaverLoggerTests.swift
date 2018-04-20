//
//  SwiftyBeaverLoggerTests.swift
//  SwiftyBeaverProvider
//
//  Created by Gustavo Perdomo on 5/2/17.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

import XCTest
import Vapor
@testable import SwiftyBeaverProvider

final class FakeResolver: ResolverProtocol {
    var executed: String!

    func resolveConsoleDestination(from config: DestinationConfig) throws -> ConsoleDestination {
        executed = "resolveConsoleDestination"
        return ConsoleDestination()
    }

    func resolveFileDestination(from config: DestinationConfig) throws -> FileDestination {
        executed = "resolveFileDestination"
        return FileDestination()
    }

    func resolvePlatformDestination(from config: DestinationConfig) throws -> SBPlatformDestination {
        executed = "resolvePlatformDestination"
        return SBPlatformDestination(appID: "", appSecret: "", encryptionKey: "")
    }
}

final class SwiftyBeaverLoggerTests: XCTestCase {
    var app: Application!

    override func setUp() {
        super.setUp()
        app = try! Application.testable()
    }

    // MARK: - General
    func testLogLevelExtension() throws {
        XCTAssertEqual(LogLevel.custom("").style, SwiftyBeaver.Level.debug)
        XCTAssertEqual(LogLevel.debug.style, SwiftyBeaver.Level.debug)
        XCTAssertEqual(LogLevel.error.style, SwiftyBeaver.Level.error)
        XCTAssertEqual(LogLevel.fatal.style, SwiftyBeaver.Level.error)
        XCTAssertEqual(LogLevel.info.style, SwiftyBeaver.Level.info)
        XCTAssertEqual(LogLevel.verbose.style, SwiftyBeaver.Level.verbose)
        XCTAssertEqual(LogLevel.warning.style, SwiftyBeaver.Level.warning)
    }

    func testLinuxTestSuiteIncludesAllTests() throws {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            let thisClass = type(of: self)
            let linuxCount = thisClass.allTests.count
            let darwinCount = Int(thisClass.defaultTestSuite.testCaseCount)

            XCTAssertEqual(linuxCount, darwinCount, "\(darwinCount - linuxCount) tests are missing from allTests")
        #endif
    }

    static let allTests = [
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests),
        ("testLogLevelExtension", testLogLevelExtension)
    ]
}
