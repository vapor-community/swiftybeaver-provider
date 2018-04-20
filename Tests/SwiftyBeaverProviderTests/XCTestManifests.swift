//
//  XCTestManifests.swift
//  SwiftyBeaverProvider
//
//  Created by Gustavo Perdomo on 4/20/18.
//  Copyright © 2018 Gustavo Perdomo. All rights reserved.
//

import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SwiftyBeaverLoggerTests.allTests),
        testCase(ResolverTests.allTests)
    ]
}
#endif
