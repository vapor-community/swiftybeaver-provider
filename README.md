[![Swift Version](https://img.shields.io/badge/Swift-4.1-brightgreen.svg)](https://swift.org)
[![Vapor Version](https://img.shields.io/badge/Vapor-3-brightgreen.svg)](https://vapor.codes)
[![SwiftyBeaver Version](https://img.shields.io/badge/SwiftyBeaver-1.5-brightgreen.svg)](https://github.com/SwiftyBeaver/SwiftyBeaver)
[![Linux Build Status](https://img.shields.io/circleci/project/github/vapor-community/swiftybeaver-provider.svg)](https://circleci.com/gh/vapor-community/swiftybeaver-provider)
[![codecov](https://codecov.io/gh/vapor-community/swiftybeaver-provider/branch/master/graph/badge.svg)](https://codecov.io/gh/vapor-community/swiftybeaver-provider)
[![GitHub license](https://img.shields.io/badge/license-MIT-brightgreen.svg)](LICENSE)

# SwiftyBeaver Logging Provider for Vapor

Adds the powerful logging of [SwiftyBeaver](https://github.com/SwiftyBeaver/SwiftyBeaver) to [Vapor](https://github.com/vapor/vapor) for server-side Swift 4 on Linux and Mac.

## Installation

Add this project to the `Package.swift` dependencies of your Vapor project:

```swift
  .package(url: "https://github.com/vapor-community/swiftybeaver-provider.git", from: "3.0.0")
```

## Setup

After you've added the SwiftyBeaver Provider package to your project, setting the provider up in code is easy.

You can configure your SwiftyBeaver instance in a pure swift way or using a JSON file like Vapor 2 do,

### Register using a pure swift way

```swift
import SwiftBeaverProvider

public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services ) throws {
    // ...

    // Setup your destinations
    let console = ConsoleDestination()
    console.minLevel = .info // update properties according to your needs

    let fileDestination = FileDestination()

    // Register the logger
    services.register(SwiftyBeaverLogger(destinations: [console, fileDestination]), as: Logger.self)

    // Optional
    config.prefer(SwiftyBeaverLogger.self, for: Logger.self)
}
```

### Register using a JSON file

First, register the SwiftyBeaverProvider in your `configure.swift` file.

```swift
import SwiftBeaverProvider

public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services ) throws {
    // ...

    // Register providers first
    try services.register(SwiftyBeaverProvider())

    // Optional
    config.prefer(SwiftyBeaverLogger.self, for: Logger.self)
}
```

#### Configure Destinations

If you run your application now, you will likely see an error that the SwiftyBeaver configuration file is missing. Let's add that now

The configuration consist of an array of destinations located in `Config/swiftybeaver.json` file. Here is an example of a simple SwiftyBeaver configuration file to configure console, file and swiftybeaver platform destinations with their required properties.

```json
[
  {
    "type": "console",
    "format": " $Dyyyy-MM-dd HH:mm:ss.SSS$d $C$L$c: $M"
  },
  {
    "type": "file"
  },
  {
    "type": "platform",
    "app": "YOUR_APP_ID",
    "secret": "YOUR_SECRET_ID",
    "key": "YOUR_ENCRYPTION_KEY"
  }
]
```

Aditional options:

| KEY                 | AVAILABLE FOR           | TYPE   | OBSERVATION                                  |
| ------------------- | ----------------------- | ------ | -------------------------------------------- |
| async               | console, file           | Bool   |                                              |
| format              | console, file           | String | A space must be placed before dollar sign    |
| levelString.debug   | console, file           | String |                                              |
| levelString.error   | console, file           | String |                                              |
| levelString.info    | console, file           | String |                                              |
| levelString.verbose | console, file           | String |                                              |
| levelString.warning | console, file           | String |                                              |
| path                | file                    | String | path to the log file                         |
| minLevel            | console, file, platform | String | values: verbose, debug, info, warning, error |
| threshold           | platform                | Int    | min: 1, max: 1000                            |

> Note:
> \
> It's a good idea to store the SwiftyBeaver configuration file in the Config/secrets folder since it contains sensitive information.
> \
> \
> To get more information about configuration options check the official [SwiftyBeaver docs](https://docs.swiftybeaver.com/)

## Use

```swift
router.get("hello") { req -> Future<String> in
    // Get a logger instance
    let logger: Logger = try req.make(SwiftyBeaverLogger.self)

    // Or
    let logger: Logger = try req.make(Logger.self) // needs config.prefer(SwiftyBeaverLogger.self, for: Logger.self) in configure.swift

    logger.info("Logger info")
    return Future("Hello, world!")
}
```

Please also see the SwiftyBeaver [destination docs](http://docs.swiftybeaver.com/category/8-logging-destinations) and how to set a [custom logging format](http://docs.swiftybeaver.com/category/19-advanced-topics).
<br/><br/>

## Output to Xcode 8 Console

<img src="https://cloud.githubusercontent.com/assets/564725/18640658/5e1ea16e-7e99-11e6-8fbf-706b3150c617.png" width="615">

[Learn more](http://docs.swiftybeaver.com/article/9-log-to-xcode-console) about colored logging to Xcode 8 Console.
<br/><br/>

## Output to File

<img src="https://cloud.githubusercontent.com/assets/564725/18640664/658667ac-7e99-11e6-9267-d7cd168fea47.png" width="802">

[Learn more](http://docs.swiftybeaver.com/article/10-log-to-file) about logging to file which is great for Terminal.app fans or to store logs on disk.
<br/><br/>

## Output to Cloud & Mac App

![swiftybeaver-demo1](https://cloud.githubusercontent.com/assets/564725/14846071/218c0646-0c62-11e6-92cb-e6e963b68724.gif)

[Learn more](http://docs.swiftybeaver.com/article/11-log-to-swiftybeaver-platform) about logging to the SwiftyBeaver Platform **during release!**
<br/><br/>

## Learn More

* [Website](https://swiftybeaver.com)
* [SwiftyBeaver Framework](https://github.com/SwiftyBeaver/SwiftyBeaver)
* [Documentation](http://docs.swiftybeaver.com/)
* [Medium Blog](https://medium.com/swiftybeaver-blog)
* [On Twitter](https://twitter.com/SwiftyBeaver)

Get support via Github Issues, email and our <b><a href="https://slack.swiftybeaver.com">public Slack channel</a></b>.
<br/><br/>

## Credits

This package is developed and maintained by [Gustavo Perdomo](https://github.com/gperdomor) with the collaboration of all vapor community.

## License

SwiftyBeaverProvider is released under the [MIT License](LICENSE).
