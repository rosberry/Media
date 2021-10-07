//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Photos
import CollectionViewTools

extension PHAsset: DiffCompatible {
    public var diffIdentifier: String {
        localIdentifier
    }

    public func makeDiffComparator() -> Bool {
        true
    }
}
