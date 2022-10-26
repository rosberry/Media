//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import CollectionViewTools
import MediaService
import Foundation

public class EmptyItemCellModel: DiffCompatible {
    public var diffIdentifier: String {
        UUID().uuidString
    }

    public let mediaItem: MediaItem
    public var selectionIndex: Int?
    public let isSelectionInfoLabelHidden: Bool

    init(mediaItem: MediaItem, selectionIndex: Int?) {
        self.mediaItem = mediaItem
        self.selectionIndex = selectionIndex
        isSelectionInfoLabelHidden = false
    }

    init(mediaItem: MediaItem, selectionIndex: Int?, isSelectionInfoLabelHidden: Bool) {
        self.mediaItem = mediaItem
        self.selectionIndex = selectionIndex
        self.isSelectionInfoLabelHidden = isSelectionInfoLabelHidden
    }

    public func makeDiffComparator() -> Bool {
        true
    }
}
