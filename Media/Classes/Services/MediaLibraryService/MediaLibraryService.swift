//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Ion
import Photos

public protocol HasMediaLibraryService {
    var mediaLibraryService: MediaLibraryService { get }
}

public protocol MediaLibraryService: AnyObject {

    typealias Completion<T> = (T) -> Void

    // MARK: - Sources

    var permissionStatusEventSource: AnyEventSource<PHAuthorizationStatus> { get }
    var mediaItemsEventSource: AnyEventSource<MediaItemFetchResult> { get }
    var collectionsEventSource: AnyEventSource<[MediaItemCollection]> { get }
    var mediaLibraryUpdateEventSource: AnyEventSource<PHChange> { get }
    var mediaItemFetchProgressEventSource: AnyEventSource<Float> { get }

    // MARK: - Permissions

    func requestMediaLibraryPermissions()

    // MARK: - Lists

    func fetchMediaItemCollections()
    func fetchMediaItems(in collection: MediaItemCollection?, filter: MediaItemFilter)

    // MARK: - Thumbnails

    func fetchThumbnail(for item: MediaItem, size: CGSize, contentMode: PHImageContentMode, completion: @escaping Completion<UIImage?>)
    func fetchThumbnail(for collection: MediaItemCollection,
                        size: CGSize,
                        contentMode: PHImageContentMode,
                        completion: @escaping Completion<UIImage?>)

    // MARK: - Data

    func fetchImage(for item: MediaItem, completion: @escaping Completion<UIImage?>)
    func fetchImage(for item: MediaItem, options: PHImageRequestOptions, completion: @escaping Completion<UIImage?>)
    func fetchVideoAsset(for item: MediaItem, completion: @escaping Completion<AVAsset?>)
}
