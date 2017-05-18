//
//  droplet+Setup.swift
//  SwiftyBeaverProvider
//
//  Created by Gustavo Perdomo on 5/18/17.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

@_exported import Vapor

extension Droplet {
    public func setup() throws {
        try collection(Routes(log: self.log))
    }
}
