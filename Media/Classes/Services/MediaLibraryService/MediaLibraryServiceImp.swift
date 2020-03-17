//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Ion
import Photos

public final class MediaLibraryServiceImp: NSObject, MediaLibraryService {

    private lazy var permissionStatusEmitter: Emitter<PHAuthorizationStatus> = .init()
    lazy public var permissionStatusEventSource: AnyEventSource<PHAuthorizationStatus> = .init(permissionStatusEmitter)

    private lazy var mediaItemListEmitter: Emitter<MediaItemFetchResult> = .init()
    lazy public var mediaItemListEventSource: AnyEventSource<MediaItemFetchResult> = .init(mediaItemListEmitter)

    private lazy var collectionsEmitter: Emitter<[MediaItemCollection]> = .init()
    lazy public var collectionsEventSource: AnyEventSource<[MediaItemCollection]> = .init(collectionsEmitter)

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

    public func fetchMediaItemCollections() {
        DispatchQueue.global(qos: .background).async {
            var collections = [MediaItemCollection]()

            if let userLibraryCollection = self.fetchCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary).first {
                collections.append(userLibraryCollection)
            }

            if let favoritesCollection = self.fetchCollections(with: .smartAlbum, subtype: .smartAlbumFavorites).first,
                favoritesCollection.estimatedMediaItemsCount != 0 {
                favoritesCollection.isFavorite = true
                collections.append(favoritesCollection)
            }

            let allCollections = self.fetchCollections(with: .album, subtype: .any).filter { collection in
                collection.estimatedMediaItemsCount != 0
            }
            collections.append(contentsOf: allCollections)

            DispatchQueue.main.async {
                self.registerForMediaLibraryUpdatesIfNeeded()
                self.collectionsEmitter.replace(collections)
            }
        }
    }

    private func fetchCollections(with type: PHAssetCollectionType, subtype: PHAssetCollectionSubtype, options: PHFetchOptions? = nil) -> [MediaItemCollection] {
        let result = PHAssetCollection.fetchAssetCollections(with: type,
                                                             subtype: subtype,
                                                             options: options)
        var collections = [MediaItemCollection]()
        result.enumerateObjects { collection, _, _ in
            let collection = MediaItemCollection(collection: collection)
            collections.append(collection)
        }
        return collections
    }

    public func fetchMediaItems(in collection: MediaItemCollection?, filter: MediaItemFilter = .all) {
        guard let collection = collection else {
            let collection = fetchCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary).first
            fetchMediaItems(in: collection, filter: filter)
            return
        }
        DispatchQueue.global(qos: .background).async {
            guard let assetCollection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [collection.identifier], options: nil).firstObject else {
                return
            }
            let mediaType: PHAssetMediaType? = filter == .all ? nil : .video
            let fetchResult = self.fetchMediaItems(in: assetCollection, mediaType: mediaType)

            DispatchQueue.main.async {
                self.registerForMediaLibraryUpdatesIfNeeded()
                let result = MediaItemFetchResult(collection: collection, filter: filter, fetchResult: fetchResult)
                self.mediaItemListEmitter.replace(result)
            }
        }
    }

    // MARK: - Thumbnails

    public func fetchThumbnail(for item: MediaItem, size: CGSize, completion: @escaping Completion<UIImage?>) {
        if let thumbnail = item.thumbnail, thumbnail.size == size {
            completion(thumbnail)
            return
        }

        DispatchQueue.global(qos: .background).async {
            guard let asset = self.makeAsset(item: item) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            self.fetchThumbnail(for: asset, size: size) { (image: UIImage?) in
                item.thumbnail = image
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }

    public func fetchThumbnail(for collection: MediaItemCollection, size: CGSize, completion: @escaping Completion<UIImage?>) {
        if let thumbnail = collection.thumbnail, thumbnail.size == size {
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

            self.fetchThumbnail(for: asset, size: size) { (image: UIImage?) in
                collection.thumbnail = image
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }

    // MARK: - Data

    public func fetchImage(for item: MediaItem, completion: @escaping Completion<UIImage?>) {
        guard let asset = makeAsset(item: item) else {
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

        manager.requestImageData(for: asset, options: requestOptions) { (imageData: Data?, _, _, _) in
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
        guard let asset = makeAsset(item: item) else {
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

    // MARK: - Private

    private func registerForMediaLibraryUpdatesIfNeeded() {
        guard didRegisterForMediaLibraryUpdates == false else {
            return
        }
        PHPhotoLibrary.shared().register(self)
        didRegisterForMediaLibraryUpdates = true
    }

    private func fetchMediaItems(in collection: PHAssetCollection, mediaType: PHAssetMediaType?) -> PHFetchResult<PHAsset> {
        let options = PHFetchOptions()

        if let mediaType = mediaType {
            options.predicate = NSPredicate(format: "mediaType = %d", mediaType.rawValue)
        }

        return PHAsset.fetchAssets(in: collection, options: options)
    }

    private func prepareOutputURL(forAssetIdentifier identifier: String) -> URL {
        let url = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(identifier.replacingOccurrences(of: "/", with: "_"))
            .appendingPathExtension("mov")
        try? FileManager.default.removeItem(at: url)
        return url
    }

    private func makeAsset(item: MediaItem) -> PHAsset? {
        if let asset = item.asset {
            return asset
        }

        let fetchOptions = PHFetchOptions()
        return PHAsset.fetchAssets(withLocalIdentifiers: [item.identifier], options: fetchOptions).firstObject
    }

    private func fetchThumbnail(for asset: PHAsset, size: CGSize, completion: @escaping Completion<UIImage?>) {
        if let thumbnail = thumbnailCache.object(forKey: asset.localIdentifier as NSString) {
            completion(thumbnail)
            return
        }

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

extension MediaLibraryServiceImp: PHPhotoLibraryChangeObserver {

    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            self.mediaLibraryUpdateEmitter.replace(changeInstance)
        }
    }
}
