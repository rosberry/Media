//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Foundation
import MediaService

extension MediaItemsFilter {
    var title: String {
        switch self {
        // swiftlint:disable:next switch_case_alignment
        case .video:
            return L10n.MediaLibrary.Filter.videos
        // swiftlint:disable:next switch_case_alignment
        case .all, .livePhoto, .photo, .sloMoVideo, .unknown:
            return L10n.MediaLibrary.Filter.all
        }
    }

    func matches(item: MediaItem) -> Bool {
        switch self {
        // swiftlint:disable:next switch_case_alignment
        case .video:
            return item.type.isVideo
        // swiftlint:disable:next switch_case_alignment
        case .all, .livePhoto, .photo, .sloMoVideo, .unknown:
            return true
        }
    }
}
