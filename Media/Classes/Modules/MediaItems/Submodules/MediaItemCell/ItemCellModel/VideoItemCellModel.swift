//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import MediaService
import CollectionViewTools

final class VideoItemCellModel: BaseItemCellModel {
    override var diffIdentifier: String {
        mediaItem.identifier
    }
}
