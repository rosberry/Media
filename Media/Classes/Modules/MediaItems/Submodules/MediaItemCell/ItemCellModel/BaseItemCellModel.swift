//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Foundation
import UIKit.UIImage
import MediaService
import CollectionViewTools

class BaseItemCellModel: DiffCompatible {
    var diffIdentifier: String {
        ""
    }

    let mediaItem: MediaItem
    var selectionIndex: Int?
    let isSelectionInfoLabelHidden: Bool

    init(mediaItem: MediaItem, selectionIndex: Int?, isSelectionInfoLabelHidden: Bool) {
        self.mediaItem = mediaItem
        self.selectionIndex = selectionIndex
        self.isSelectionInfoLabelHidden = isSelectionInfoLabelHidden
    }

    func makeDiffComparator() -> Bool {
        true
    }
}
