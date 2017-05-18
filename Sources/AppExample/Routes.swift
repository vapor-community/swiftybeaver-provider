//
//  Routes.swift
//  SwiftyBeaverProvider
//
//  Created by Gustavo Perdomo on 5/2/17.
//  Copyright © 2017 Gustavo Perdomo. All rights reserved.
//

import Vapor

final class Routes: RouteCollection {
    private let log: LogProtocol

    init(log: LogProtocol) {
        self.log = log
    }

    func build(_ builder: RouteBuilder) throws {
        builder.get("hello") { _ in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }

        builder.get("plaintext") { _ in
            self.log.verbose("not so important")
            self.log.debug("something to debug")
            self.log.info("a nice information")
            self.log.warning("oh no, that won’t be good")
            self.log.error("ouch, an error did occur!")

            return "Hello, world!"
        }

        // response to requests to /info domain
        // with a description of the request
        builder.get("info") { req in
            return req.description
        }

        builder.get("*") { req in return req.description }
    }
}
