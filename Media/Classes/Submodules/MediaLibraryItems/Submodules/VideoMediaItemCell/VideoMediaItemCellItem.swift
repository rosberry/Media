//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import CollectionViewTools

class VideoMediaItemCellItem: MediaItemCellItem {

    typealias Cell = VideoMediaItemCell

    override var reuseType: ReuseType {
        .class(Cell.self)
    }
}
