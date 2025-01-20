# Atmos Weather app in Swift

## Setup and Run

Copy and paste code from `develop.xcconfig.example` to a new `develop.xcconfig` file and add in the Weather API Key as needed.

Alternatively, while on the project directory on the terminal, you may run this command and paste the Weather API Key from openweather api

```bash
cat develop.xcconfig.example > develop.xcconfig
```

Build the project using `cmd+B` (⌘B)
Select the run destination. Run the project using `cmd+R` (⌘R)

## Third-party Libraries

All third party libraries are implemented in Swift Package Manager (SPM). Opening the project in Xcode will automatically resolve package dependencies. In case of failure, on Xcode go to `File > Packages > Resolve Package Versions` or via the command line using `xcodebuild -resolvePackageDependencies`

## Conventions

#### Architecture

Model View ViewModel (MVVM) with implementations being done in SwiftUI

## Performing Tests

##### Running Tests in Xcode

1. Open your project in Xcode.
2. Use shortcut cmd+U (⌘U) to run all tests

##### Running Tests in Command Line

Tests can also be run from the command line using the `xcodebuild` command. Make sure your terminal is in the project directory before running the command.

```bash
xcodebuild -scheme develop -destination 'platform=iOS Simulator, name=iPhone14' test
```

##### Static code analysis

Static code analysis is done using [Swiftlint](https://github.com/realm/SwiftLint) based off Github Swift Style Guide

```bash
swiftlint lint
swiftlint analyze
swiftlint --fix
```
