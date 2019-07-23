//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import Foundation

public final class UserConfigService: UserConfigServiceProtocol {

    public var mediaLibraryFilter: MediaItemFilter? {
        didSet {
            storage.set(mediaLibraryFilter?.rawValue, forKey: storageKey(for: \UserConfigService.mediaLibraryFilter))
        }
    }

    public var mediaLibraryAlbum: String? {
        didSet {
            storage.set(mediaLibraryAlbum, forKey: storageKey(for: \UserConfigService.mediaLibraryAlbum))
        }
    }

    private let storage: UserDefaults = .standard
    public init() {
        if let filter = storage.string(forKey: storageKey(for: \UserConfigService.mediaLibraryFilter)) {
            mediaLibraryFilter = MediaItemFilter(rawValue: filter)
        }

        mediaLibraryAlbum = storage.string(forKey: storageKey(for: \UserConfigService.mediaLibraryAlbum))
    }

    private func storageKey<T: UserConfigService, V>(for keyPath: KeyPath<T, V>) -> String {
        return "user.config.\(keyPath)"
    }
}
