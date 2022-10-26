//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import MediaService
import CollectionViewTools

final class VideoItemCellModel: EmptyItemCellModel {
    override var diffIdentifier: String {
        mediaItem.identifier
    }
}
