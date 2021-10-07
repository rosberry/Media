//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import CollectionViewTools
import MediaService

final class EmptyItemCellModel: BaseItemCellModel {
    override var diffIdentifier: String {
        UUID().uuidString
    }

    init(mediaItem: MediaItem, selectionIndex: Int?) {
        super.init(mediaItem: mediaItem, selectionIndex: selectionIndex, isSelectionInfoLabelHidden: false)
    }
}
