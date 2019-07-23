//
//  Copyright © 2019 Rosberry. All rights reserved.
//

public protocol HasUserConfigService {
    var userConfigService: UserConfigServiceProtocol { get }
}

public protocol UserConfigServiceProtocol: AnyObject {
    var mediaLibraryFilter: MediaItemFilter? { get set }
    var mediaLibraryAlbum: String? { get set }
}
