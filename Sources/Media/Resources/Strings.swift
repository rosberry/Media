// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// dummy
  internal static let dummy = L10n.tr("Localizable", "dummy")

  internal enum Camera {
    internal enum PermissionsPlaceholder {
      /// Give access to your camera\nto take a shot
      internal static let body = L10n.tr("Localizable", "camera.permissions_placeholder.body")
      /// Camera
      internal static let title = L10n.tr("Localizable", "camera.permissions_placeholder.title")
    }
  }

  internal enum ManageAccess {
    /// Manage
    internal static let buttonTitle = L10n.tr("Localizable", "manage_access.button_title")
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "manage_access.cancel")
    /// Select more photos
    internal static let more = L10n.tr("Localizable", "manage_access.more")
    /// Change settings
    internal static let settings = L10n.tr("Localizable", "manage_access.settings")
    /// %@ has access to a limited number of photos. Tap «%@» to add more.
    internal static func title(_ p1: Any, _ p2: Any) -> String {
      return L10n.tr("Localizable", "manage_access.title", String(describing: p1), String(describing: p2))
    }
  }

  internal enum MediaLibrary {
    /// Albums
    internal static let albums = L10n.tr("Localizable", "mediaLibrary.albums")
    /// All videos & photos
    internal static let allItems = L10n.tr("Localizable", "mediaLibrary.allItems")
    /// Done
    internal static let done = L10n.tr("Localizable", "mediaLibrary.done")
    /// No media items
    internal static let empty = L10n.tr("Localizable", "mediaLibrary.empty")
    /// Favorite videos & photos
    internal static let favoriteItems = L10n.tr("Localizable", "mediaLibrary.favoriteItems")
    /// List
    internal static let list = L10n.tr("Localizable", "mediaLibrary.list")
    /// Library
    internal static let title = L10n.tr("Localizable", "mediaLibrary.title")
    /// Unknown
    internal static let unknown = L10n.tr("Localizable", "mediaLibrary.unknown")
    internal enum Filter {
      /// All
      internal static let all = L10n.tr("Localizable", "mediaLibrary.filter.all")
      /// Videos
      internal static let videos = L10n.tr("Localizable", "mediaLibrary.filter.videos")
    }
    internal enum Permissions {
      /// To share photos and videos, %@ needs access to storage on your device
      internal static func subtitle(_ p1: Any) -> String {
        return L10n.tr("Localizable", "mediaLibrary.permissions.subtitle", String(describing: p1))
      }
      /// Allow Access to Storage
      internal static let title = L10n.tr("Localizable", "mediaLibrary.permissions.title")
    }
  }

  internal enum Permissions {
    /// Allow Access
    internal static let action = L10n.tr("Localizable", "permissions.action")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
