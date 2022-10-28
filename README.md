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

To start using `Media`, you must use the `MediaCoordinator`.
Initialization `MediaCoordinator(navigationViewController: UINavigationController, mediaAppearance: MediaAppearance, filter: MediaItemsFilter)` where:
- `navigationViewController: UINavigationController` - navigation controller.
- `mediaAppearance: MediaAppearance` - describes UI customization of the media picker.
- `filter: MediaItemsFilter` - filter for elements in gallery. Default `.all`.

```Swift
   var coordinator = MediaCoordinator(navigationViewController: navigationViewController)
```

Also in `MediaCoordinator` has important public variables such as:
- `MediaCoordinatorDelegate` delegate which handles events from the picker:
```Swift
    public weak var delegate: MediaCoordinatorDelegate?
    
    public protocol MediaCoordinatorDelegate: AnyObject {
        // select photo in list gallery 
	// mediaItems: [MediaItems] - list selected resource
	// use framework `MediaService`. Public class `MediaItem` description selected object on gallery 
        func selectMediaItemsEventTriggered(_ mediaItems: [MediaItem])
	
	// triggered when make photo over camera
        func photoEventTriggered(_ image: UIImage)
        
	// triggered when tap on more in manager access
        func moreEventTriggered()
	
	// triggered when tap in setting in manager access
        func settingEventTriggered()
	
	// triggered when tap on custom element in manager access. If added is not custom button event never triggered.
        func customEventTriggered()
    }
```
-  `isAccessManagerEnabled` responsible for displaying the manager's access when the number of photos is limited. If you set it to false, the manager's display logic will be ignored. The default value is true.. available(iOS 14, * )

```Swift
    public var isAccessManagerEnabled: Bool
```

- `maxItemsCount` variable is responsible for the allowed number of selected photos. Default `2`.

```Swift
    public var maxItemsCount: Int
```

- `needCloseBySelect` determines if picker will be automatically closed on media item selection.

```Swift
    public var needCloseBySelect: Bool
```

- `isShowActionSheetWithAnimated` boolean variable for show animated action sheet popup. Default `true`.

```Swift
   public var isShowActionSheetWithAnimated: Bool
```

- `filter` filter for elements in gallery. Default `.all`.

```Swift
    public var filter: MediaItemsFilter
```

- `mediaAppearance` determines UI customization parameters.

```Swift
    public var mediaAppearance: MediaAppearance
```

Since Media needs access to system photos and camera, make sure to add `NSPhotoLibraryUsageDescription` and `NSCameraUsageDescription` in your app's info.plist:

```
	<key>NSPhotoLibraryUsageDescription</key>
	<string>Describe how photos / videos will be used by your app</string>
	<key>NSCameraUsageDescription</key>
	<string>Describe how camera will be used by your app</string>
```

If you want to avoid limited photo selection alert to be shown on each app launch, add `PHPhotoLibraryPreventAutomaticLimitedAccessAlert` key to the app's plist:
```
	<key>PHPhotoLibraryPreventAutomaticLimitedAccessAlert</key>
	<true/>
```

After initializing `MediaCoordinator`, call `start` to present gallery picker.

```Swift
    private func start() {
        coordinator = MediaCoordinator(navigationViewController: navigationController)
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
