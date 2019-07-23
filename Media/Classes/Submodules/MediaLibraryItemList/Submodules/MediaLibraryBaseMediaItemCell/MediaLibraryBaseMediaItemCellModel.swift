//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Foundation
import UIKit.UIImage

final class MediaLibraryBaseMediaItemCellModel {

    let item: MediaItem
    var selectionIndex: Int?

    init(mediaItem: MediaItem, selectionIndex: Int?) {
        self.item = mediaItem
        self.selectionIndex = selectionIndex
    }
}