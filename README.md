# Media
Media - wrapper on over system gallery. Also support customization UI.

<p align="center">
    <a href="https://swift.org/">
        <img src="https://img.shields.io/badge/swift-5.0-orange.svg" alt="Swift Version" />
    </a>
    <a href="https://github.com/Carthage/Carthage">
        <img src="https://img.shields.io/badge/Carthage-compatible-green.svg" alt="Carthage Compatible" />
    </a>
    <a href="https://github.com/apple/swift-package-manager">
        <img src="https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
    </a>
</p>

## Using
### Create MediaCoordinator

First create object `MediaCoordinator`

```Swift
private var coordinator: MediaCoordinator?
```

`MediaCoordinator` initialization:

```Swift
MediaCoordinator(navigationViewController: UINavigationController, mediaAppearance: MediaAppearance, filter: MediaItemsFilter)
```

Let's break it down for you one at a time:
- `navigationViewController: UINavigationController` need for navigation. 
- `mediaAppearance: MediaAppearance` object for customization UI on gallery. Argument is optional.
- `filter: MediaItemsFilter` enum for filtered item in gallery. Default value `.all`.

Also `MediaCoordinator` is have important variable such as:

```Swift

```

After init class `MediaCoordinator` and call `func start()` on coordinator

```Swift
    private func start() {
        coordinator = .init(navigationViewController: navigationController)
        coordinator?.delegate = self
        coordinator?.start()
    }
```

## Requirements

- iOS 12.2+
- Xcode 12.0+

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate MediaService into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "rosberry/Media"
```
### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate MediaService into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'Media'
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. Once you have your Swift package set up, adding MediaService as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/rosberry/Media.git")
]
```

## Documentation

Read the [docs](https://rosberry.github.io/Media). Generated with [jazzy](https://github.com/realm/jazzy). Hosted by [GitHub Pages](https://pages.github.com).

## About

<img src="https://github.com/rosberry/Foundation/blob/master/Assets/full_logo.png?raw=true" height="100" />

This project is owned and maintained by [Rosberry](http://rosberry.com). We build mobile apps for users worldwide 🌏.

Check out our [open source projects](https://github.com/rosberry), read [our blog](https://medium.com/@Rosberry) or give us a high-five on 🐦 [@rosberryapps](http://twitter.com/RosberryApps).

## License

This project is available under the MIT license. See the LICENSE file for more info.
