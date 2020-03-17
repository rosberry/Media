//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Ion
import Photos

public final class MediaLibraryService: NSObject, MediaLibraryServiceProtocol {

    private lazy var permissionStatusEmitter: Emitter<PHAuthorizationStatus> = .init()
    lazy public var permissionStatusEventSource: AnyEventSource<PHAuthorizationStatus> = .init(permissionStatusEmitter)

    private lazy var mediaItemListEmitter: Emitter<MediaItemFetchResult> = .init()
    lazy public var mediaItemListEventSource: AnyEventSource<MediaItemFetchResult> = .init(mediaItemListEmitter)

    private lazy var collectionListEmitter: Emitter<[MediaItemCollection]> = .init()
    lazy public var collectionListEventSource: AnyEventSource<[MediaItemCollection]> = .init(collectionListEmitter)

    private lazy var mediaLibraryUpdateEmitter: Emitter<PHChange> = .init()
    lazy public var mediaLibraryUpdateEventSource: AnyEventSource<PHChange> = .init(mediaLibraryUpdateEmitter)

    private lazy var mediaItemFetchProgressEmitter: Emitter<Float> = .init()
    lazy public var mediaItemFetchProgressEventSource: AnyEventSource<Float> = .init(mediaItemFetchProgressEmitter)

    private lazy var manager: PHCachingImageManager = .init()
    private let thumbnailCache: NSCache<NSString, UIImage> = .init()

    private var didRegisterForMediaLibraryUpdates: Bool = false

    // MARK: - Permissions

    public func requestMediaLibraryPermissions() {
        PHPhotoLibrary.requestAuthorization { (status: PHAuthorizationStatus) in
            DispatchQueue.main.async {
                self.permissionStatusEmitter.replace(status)
            }
        }
    }

    // MARK: - Lists

    public func fetchMediaItemList(in collection: MediaItemCollection?, filter: MediaItemFilter = .all) {
        guard let collection = collection else {
            fetchMediaItemList(in: fetchCameraRollItemCollection(), filter: filter)
            return
        }
        DispatchQueue.global(qos: .background).async {
            let identifiers = [collection.identifier]
            guard let assetCollection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: identifiers,
                                                                                options: nil).firstObject else {
                                                                                    return
            }

            let options = PHFetchOptions()
            let allResult = PHAsset.fetchAssets(in: assetCollection, options: options)

            options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
            let videoResult = PHAsset.fetchAssets(in: assetCollection, options: options)

            let containsVideoItems = videoResult.count != 0
            DispatchQueue.main.async {
                if self.didRegisterForMediaLibraryUpdates == false {
                    PHPhotoLibrary.shared().register(self)
                    self.didRegisterForMediaLibraryUpdates = true
                }

                let fetchResult = (containsVideoItems && (filter == .video)) ? videoResult : allResult
                let result = MediaItemFetchResult(collection: collection, filter: filter, fetchResult: fetchResult)
                result.containsMixedTypeContent = containsVideoItems && (allResult.count != videoResult.count)
                self.mediaItemListEmitter.replace(result)
            }
        }
    }

    public func fetchMediaItemCollectionList() {
        DispatchQueue.global(qos: .background).async {
            var collections: [MediaItemCollection] = []
            let allItemsCollectionResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                                   subtype: .smartAlbumUserLibrary,
                                                                                   options: nil)
            if let allItemsCollection = allItemsCollectionResult.firstObject {
                let collection = MediaItemCollection(collection: allItemsCollection)
                collections.append(collection)
            }

            let favoritesCollectionResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                                    subtype: .smartAlbumFavorites,
                                                                                    options: nil)
            if let favoritesCollection = favoritesCollectionResult.firstObject,
               PHAsset.fetchAssets(in: favoritesCollection, options: nil).firstObject != nil {
                let collection = MediaItemCollection(collection: favoritesCollection)
                collection.isFavorite = true
                collections.append(collection)
            }

            let albumCollectionsResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
            albumCollectionsResult.enumerateObjects { (album: PHAssetCollection, _, _) in
                guard album.estimatedAssetCount != 0 else {
                    return
                }

                let collection = MediaItemCollection(collection: album)
                collections.append(collection)
            }

            DispatchQueue.main.async {
                if self.didRegisterForMediaLibraryUpdates == false {
                    PHPhotoLibrary.shared().register(self)
                    self.didRegisterForMediaLibraryUpdates = true
                }
                self.collectionListEmitter.replace(collections)
            }
        }
    }

    // MARK: - Thumbnails

    public func fetchThumbnail(for item: MediaItem, completion: @escaping Completion<UIImage?>) {
        if let thumbnail = item.thumbnail {
            completion(thumbnail)
            return
        }

        DispatchQueue.global(qos: .background).async {
            guard let asset = self.fetchAsset(for: item) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            self.fetchThumbnail(for: asset) { (image: UIImage?) in
                item.thumbnail = image
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }

    public func fetchThumbnail(for collection: MediaItemCollection, completion: @escaping Completion<UIImage?>) {
        if let thumbnail = collection.thumbnail {
            completion(thumbnail)
            return
        }

        DispatchQueue.global(qos: .background).async {
            guard let assetCollection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [collection.identifier],
                                                                                options: nil).firstObject else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            let posterAsset: PHAsset?
            if assetCollection.assetCollectionType == .smartAlbum || assetCollection.assetCollectionSubtype == .albumMyPhotoStream {
                posterAsset = PHAsset.fetchAssets(in: assetCollection, options: nil).lastObject
            }
            else {
                posterAsset = PHAsset.fetchAssets(in: assetCollection, options: nil).firstObject
            }

            guard let asset = posterAsset else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            self.fetchThumbnail(for: asset) { (image: UIImage?) in
                collection.thumbnail = image
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }

    // MARK: - Data

    public func fetchImage(for item: MediaItem, completion: @escaping Completion<UIImage?>) {
        guard let asset = fetchAsset(for: item) else {
            completion(nil)
            return
        }

        let requestOptions = PHImageRequestOptions()
        requestOptions.isNetworkAccessAllowed = true
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.progressHandler = { [weak self] (progress: Double, _, _, _) in
            DispatchQueue.main.async {
                self?.mediaItemFetchProgressEmitter.replace(Float(progress))
            }
        }

        manager.requestImageData(for: asset, options: requestOptions) { (imageData: Data?, _, _: UIImage.Orientation?, _) in
            guard let data = imageData else {
                completion(nil)
                return
            }

            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.mediaItemFetchProgressEmitter.discard()
                completion(image)
            }
        }
    }

    public func fetchVideoAsset(for item: MediaItem, completion: @escaping Completion<AVAsset?>) {
        guard let asset = fetchAsset(for: item) else {
            completion(nil)
            return
        }

        if item.type.isVideo {
            let requestOptions = PHVideoRequestOptions()
            requestOptions.isNetworkAccessAllowed = true
            requestOptions.progressHandler = { [weak self] (progress: Double, _, _, _) in
                DispatchQueue.main.async {
                    self?.mediaItemFetchProgressEmitter.replace(Float(progress))
                }
            }

            manager.requestAVAsset(forVideo: asset, options: requestOptions) { (asset: AVAsset?, _, _) in
                DispatchQueue.main.async {
                    self.mediaItemFetchProgressEmitter.discard()
                    completion(asset)
                }
            }
        }
        else if item.type.isLivePhoto {
            let requestOptions = PHLivePhotoRequestOptions()
            requestOptions.isNetworkAccessAllowed = true
            requestOptions.deliveryMode = .highQualityFormat
            requestOptions.progressHandler = { [weak self] (progress: Double, _, _, _) in
                DispatchQueue.main.async {
                    self?.mediaItemFetchProgressEmitter.replace(Float(progress))
                }
            }

            manager.requestLivePhoto(for: asset,
                                     targetSize: .zero,
                                     contentMode: .default,
                                     options: requestOptions) { (photo: PHLivePhoto?, _) in
                guard let photo = photo else {
                    return completion(nil)
                }

                let resources = PHAssetResource.assetResources(for: photo)
                guard let videoResource = resources.first(where: { (resource: PHAssetResource) -> Bool in
                    return resource.type == .pairedVideo
                }) else {
                    return completion(nil)
                }

                let url = self.prepareOutputURL(forAssetIdentifier: videoResource.assetLocalIdentifier)
                let requestOptions = PHAssetResourceRequestOptions()
                requestOptions.isNetworkAccessAllowed = true

                PHAssetResourceManager.default().writeData(for: videoResource,
                                                           toFile: url,
                                                           options: requestOptions,
                                                           completionHandler: { _ in
                    DispatchQueue.main.async {
                        self.mediaItemFetchProgressEmitter.discard()
                        let asset = AVURLAsset(url: url, options: [AVURLAssetPreferPreciseDurationAndTimingKey: true])
                        completion(asset)
                    }
                })
            }
        }
        else {
            completion(nil)
        }
    }
    
    private func fetchCameraRollItemCollection() -> MediaItemCollection {
        let allItemsCollectionResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                               subtype: .smartAlbumUserLibrary,
                                                                               options: nil)
        guard let allItemsCollection = allItemsCollectionResult.firstObject else {
            return MediaItemCollection(identifier: "id", title: "null")
        }
        return MediaItemCollection(collection: allItemsCollection)
    }

    public func prepareOutputURL(forAssetIdentifier identifier: String) -> URL {
        let url =  URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(identifier.replacingOccurrences(of: "/", with: "_"))
            .appendingPathExtension("mov")
        try? FileManager.default.removeItem(at: url)
        return url
    }

    // MARK: - Helpers

    private func mediaItems(for assets: PHFetchResult<PHAsset>) -> [MediaItem] {
        var items: [MediaItem] = []
        assets.enumerateObjects(options: [.reverse]) { (asset: PHAsset, _, _) in
            items.append(MediaItem(asset: asset))
        }

        return items
    }

    private func fetchAsset(for item: MediaItem) -> PHAsset? {
        if let asset = item.asset {
            return asset
        }

        let fetchOptions = PHFetchOptions()
        return PHAsset.fetchAssets(withLocalIdentifiers: [item.identifier], options: fetchOptions).firstObject
    }

    private func fetchThumbnail(for asset: PHAsset, completion: @escaping Completion<UIImage?>) {
        if let thumbnail = thumbnailCache.object(forKey: asset.localIdentifier as NSString) {
            return completion(thumbnail)
        }

        let size = CGSize(width: 100.0, height: 100.0)
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.isNetworkAccessAllowed = true

        manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options) { [weak self] (image: UIImage?, _) in
            if let image = image {
                self?.thumbnailCache.setObject(image, forKey: asset.localIdentifier as NSString)
            }

            completion(image)
        }
    }
}

// MARK: - PHPhotoLibraryChangeObserver

extension MediaLibraryService: PHPhotoLibraryChangeObserver {

    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            self.mediaLibraryUpdateEmitter.replace(changeInstance)
        }
    }
}
