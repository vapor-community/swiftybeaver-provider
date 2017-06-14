//
//  LinuxMain.swift
//  SwiftyBeaverProvider
//
//  Created by Gustavo Perdomo on 5/2/17.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

#if os(Linux)

import XCTest
@testable import SwiftyBeaverProviderTests

XCTMain([
    testCase(VaporSwiftyBeaverTests.allTests)
])

#endif
