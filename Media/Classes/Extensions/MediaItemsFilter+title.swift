//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Foundation
import MediaService

// swiftlint:disable switch_case_alignment
extension MediaItemsFilter {
    var title: String {
        switch self {
        case .video:
            return L10n.MediaLibrary.Filter.videos
        case .all, .livePhoto, .photo, .sloMoVideo, .unknown:
            return L10n.MediaLibrary.Filter.all
        }
    }

    func matches(item: MediaItem) -> Bool {
        switch self {
        case .video:
            return item.type.isVideo
        case .all, .livePhoto, .photo, .sloMoVideo, .unknown:
            return true
        }
    }
}
// swiftlint:enable switch_case_alignment
