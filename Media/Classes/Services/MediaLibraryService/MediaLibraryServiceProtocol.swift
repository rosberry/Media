//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Ion
import Photos

public protocol HasMediaLibraryService {
    var mediaLibraryService: MediaLibraryServiceProtocol { get }
}

public protocol MediaLibraryServiceProtocol: AnyObject {

    typealias Completion<T> = (T) -> Void

    // MARK: - Sources

    var permissionStatusEventSource: AnyEventSource<PHAuthorizationStatus> { get }
    var mediaItemListEventSource: AnyEventSource<MediaItemFetchResult> { get }
    var collectionListEventSource: AnyEventSource<[MediaItemCollection]> { get }
    var mediaLibraryUpdateEventSource: AnyEventSource<PHChange> { get }
    var mediaItemFetchProgressEventSource: AnyEventSource<Float> { get }

    // MARK: - Permissions

    func requestMediaLibraryPermissions()

    // MARK: - Lists

    func fetchMediaItemList(in collection: MediaItemCollection?, filter: MediaItemFilter)
    func fetchMediaItemCollectionList()

    // MARK: - Thumbnails

    func fetchThumbnail(for item: MediaItem, completion: @escaping Completion<UIImage?>)
    func fetchThumbnail(for collection: MediaItemCollection, completion: @escaping Completion<UIImage?>)

    // MARK: - Data

    func fetchImage(for item: MediaItem, completion: @escaping Completion<UIImage?>)
    func fetchVideoAsset(for item: MediaItem, completion: @escaping Completion<AVAsset?>)
}
