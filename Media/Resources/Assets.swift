// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
  internal typealias AssetColorTypeAlias = NSColor
  internal typealias AssetImageTypeAlias = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  internal typealias AssetColorTypeAlias = UIColor
  internal typealias AssetImageTypeAlias = UIImage
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let backArrow = ImageAsset(name: "backArrow")
  internal static let group = ImageAsset(name: "group")
  internal static let homeFeed = ImageAsset(name: "homeFeed")
  internal static let icArrowBackDark24 = ImageAsset(name: "icArrowBackDark24")
  internal static let icFiltersDownload = ImageAsset(name: "icFiltersDownload")
  internal static let icFiltersDownloadingArrow = ImageAsset(name: "icFiltersDownloadingArrow")
  internal static let icFiltersFree = ImageAsset(name: "icFiltersFree")
  internal static let icFiltersInstagram = ImageAsset(name: "icFiltersInstagram")
  internal static let icFiltersMail = ImageAsset(name: "icFiltersMail")
  internal static let icLive12 = ImageAsset(name: "icLive12")
  internal static let icRecentProjectsM = ImageAsset(name: "icRecentProjectsM")
  internal static let icShopBlackWhite19 = ImageAsset(name: "icShopBlackWhite19")
  internal static let icShopPlusSmall = ImageAsset(name: "icShopPlusSmall")
  internal static let icShoppingCart = ImageAsset(name: "icShoppingCart")
  internal static let icSquaresTemplateBlack32 = ImageAsset(name: "icSquaresTemplateBlack32")
  internal static let iconShevroneLeftDark24 = ImageAsset(name: "iconShevroneLeftDark24")
  internal static let imgHomeGallery = ImageAsset(name: "imgHomeGallery")
  internal static let imgHomeStory = ImageAsset(name: "imgHomeStory")
  internal static let workspaceAddSlide = ImageAsset(name: "workspaceAddSlide")
  internal static let workspaceEdit = ImageAsset(name: "workspaceEdit")
  internal static let icAddMediaFileM = ImageAsset(name: "icAddMediaFileM")
  internal static let icArrowDropdownM = ImageAsset(name: "icArrowDropdownM")
  internal static let icDoneM = ImageAsset(name: "icDoneM")
  internal static let icLivePhotoXs = ImageAsset(name: "icLivePhotoXs")
  internal static let icSloMoXs = ImageAsset(name: "icSloMoXs")
  internal static let imgWorkspacePickTemplate = ImageAsset(name: "imgWorkspacePickTemplate")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ColorAsset {
  internal fileprivate(set) var name: String

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  internal var color: AssetColorTypeAlias {
    return AssetColorTypeAlias(asset: self)
  }
}

internal extension AssetColorTypeAlias {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct DataAsset {
  internal fileprivate(set) var name: String

  #if os(iOS) || os(tvOS) || os(OSX)
  @available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
  internal var data: NSDataAsset {
    return NSDataAsset(asset: self)
  }
  #endif
}

#if os(iOS) || os(tvOS) || os(OSX)
@available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
internal extension NSDataAsset {
  convenience init!(asset: DataAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(name: asset.name, bundle: bundle)
    #elseif os(OSX)
    self.init(name: NSDataAsset.Name(asset.name), bundle: bundle)
    #endif
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  internal var image: AssetImageTypeAlias {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = AssetImageTypeAlias(named: name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = AssetImageTypeAlias(named: name)
    #endif
    guard let result = image else { fatalError("Unable to load image named \(name).") }
    return result
  }
}

internal extension AssetImageTypeAlias {
  @available(iOS 1.0, tvOS 1.0, watchOS 1.0, *)
  @available(OSX, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = Bundle(for: BundleToken.self)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

private final class BundleToken {}
