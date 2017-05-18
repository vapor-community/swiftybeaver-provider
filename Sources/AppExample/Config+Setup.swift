//
//  Config+Setup.swift
//  SwiftyBeaverProvider
//
//  Created by Gustavo Perdomo on 5/18/17.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

import SwiftyBeaverProvider

extension Config {
    public func setup() throws {
        try setupProviders()
    }

    /// Configure providers
    private func setupProviders() throws {
        try addProvider(SwiftyBeaverProvider.Provider.self)
    }
}
