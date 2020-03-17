//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import Photos

public final class MediaItemFetchResult {
    public let collection: MediaItemCollection
    public let filter: MediaItemFilter
    public let fetchResult: PHFetchResult<PHAsset>

    public init(collection: MediaItemCollection, filter: MediaItemFilter, fetchResult: PHFetchResult<PHAsset>) {
        self.collection = collection
        self.filter = filter
        self.fetchResult = fetchResult
    }
}
