//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Foundation

public enum MediaItemFilter: String {
    case video
    case all

    public func matches(item: MediaItem) -> Bool {
        switch self {
        case .all:
            return true
        case .video:
            return item.type.isVideo
        }
    }
}
