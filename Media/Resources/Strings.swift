// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// dummy
  internal static let dummy = L10n.tr("Localizable", "dummy")

  internal enum MediaLibrary {
    /// All videos & photos
    internal static let allItems = L10n.tr("Localizable", "mediaLibrary.allItems")
    /// No media items
    internal static let empty = L10n.tr("Localizable", "mediaLibrary.empty")
    /// Done
    internal static let done = L10n.tr("Localizable", "mediaLibrary.done")
    /// Favorite videos & photos
    internal static let favoriteItems = L10n.tr("Localizable", "mediaLibrary.favoriteItems")
    /// Library
    internal static let title = L10n.tr("Localizable", "mediaLibrary.title")
    /// Albums
    internal static let albums = L10n.tr("Localizable", "mediaLibrary.albums")
    /// List
    internal static let list = L10n.tr("Localizable", "mediaLibrary.list")
    /// Unknown
    internal static let unknown = L10n.tr("Localizable", "mediaLibrary.unknown")
    internal enum Filter {
      /// All
      internal static let all = L10n.tr("Localizable", "mediaLibrary.filter.all")
      /// Videos
      internal static let videos = L10n.tr("Localizable", "mediaLibrary.filter.videos")
    }
    internal enum Item {
      /// LIVE
      internal static let live = L10n.tr("Localizable", "mediaLibrary.item.live")
    }
    internal enum Permissions {
      /// This will allow Template to use video and photos from your library and save videos to your camera roll
      internal static let subtitle = L10n.tr("Localizable", "mediaLibrary.permissions.subtitle")
      /// Please allow access to your videos and photos
      internal static let title = L10n.tr("Localizable", "mediaLibrary.permissions.title")
    }
  }

  internal enum Permissions {
    /// Open Settings
    internal static let action = L10n.tr("Localizable", "permissions.action")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
