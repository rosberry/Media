//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Ion
import UIKit
import Photos
import CollectionViewTools
import MediaService

public final class GalleryPresenter {

    public enum FocusDirection {
        case up
        case down
    }

    typealias Dependencies = HasMediaLibraryService
    typealias Direction = AlbumTitleView.Direction

    private let dependencies: Dependencies
    weak var view: GalleryViewController?

    weak var output: GalleryModuleOutput?

    var collections: [MediaItemsCollection] = []
    private var isFetching: Bool = false
    public var collection: MediaItemsCollection? {
        didSet {
            // Do not update default collection
            if oldValue == nil, collection === collections.first {
                return
            }
            updateMediaItemList(usingPlaceholderTransition: collection !== oldValue)
        }
    }

    public var filter: MediaItemsFilter = .all {
        didSet {
            updateMediaItemList(usingPlaceholderTransition: true)
            lastUsedMediaFilter = filter
        }
    }

    private var lastUsedMediaFilter: MediaItemsFilter? {
        get {
            guard let value = UserDefaults.standard.value(forKey: #function) as? Int else {
                return .all
            }
            return .init(rawValue: value)
        }
        set {
            UserDefaults.standard.set(newValue?.rawValue, forKey: #function)
        }
    }

    private var lastUsedCollectionId: String? {
        get {
            UserDefaults.standard.string(forKey: #function)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
    }

    public var fetchResult: MediaItemsFetchResult?
    public var selectedItems: [MediaItem] = [] {
        didSet {
            updateSelection()
        }
    }

    private var focusDirection: FocusDirection = .down

    private lazy var mediaItemsCollector: Collector<MediaItemsFetchResult> = {
        return .init(source: dependencies.mediaLibraryService.mediaItemsEventSource)
    }()

    private lazy var mediaLibraryUpdateEventCollector: Collector<PHChange> = {
        return .init(source: dependencies.mediaLibraryService.mediaLibraryUpdateEventSource)
    }()

    private lazy var collectionsCollector: Collector<[MediaItemsCollection]> = {
        return .init(source: dependencies.mediaLibraryService.collectionsEventSource)
    }()

    private lazy var permissionsCollector: Collector<PHAuthorizationStatus> = {
        return .init(source: dependencies.mediaLibraryService.permissionStatusEventSource)
    }()

    private lazy var factory: GallerySectionsFactory = {
        let factory = GallerySectionsFactory(dependencies: Services,
                                             mediaAppearance: mediaAppearance)
        factory.output = self
        return factory
    }()

    private let maxItemsCount: Int
    private var direction: Direction
    public var numberOfItemsInRow: Int
    public var mediaAppearance: MediaAppearance
    public var isAccessManagerEnabled: Bool

    // MARK: - Lifecycle

    init(isAccessManagerEnabled: Bool,
         filter: MediaItemsFilter,
         maxItemsCount: Int,
         numberOfItemsInRow: Int = 1,
         dependencies: Dependencies,
         mediaAppearance: MediaAppearance) {
        self.maxItemsCount = maxItemsCount
        self.isAccessManagerEnabled = isAccessManagerEnabled
        self.numberOfItemsInRow = numberOfItemsInRow
        self.dependencies = dependencies
        self.mediaAppearance = mediaAppearance
        self.filter = filter
        self.direction = .down
    }

    func viewReadyEventTriggered() {
        if let filter = lastUsedMediaFilter {
            self.filter = filter
            view?.update(with: filter)
        }
        setupMediaLibraryUpdateEventCollector()
        setupForegroundObserver()

        guard isAccessManagerEnabled else {
            setupMediaItemsCollection(isHideTitle: false)
            return
        }

        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                switch status {
                    case .limited:
                        self?.view?.showAccessManagerView()
                    default:
                        break
                }
                DispatchQueue.main.async {
                    self?.setupMediaItemsCollection(isHideTitle: status == .limited)
                }
            }
        }
    }

    func viewWillAppear() {
        fetchMediaItems()
    }

    func scrollEventTriggered(direction: FocusDirection) {
        guard focusDirection != direction else {
            return
        }

        focusDirection = direction
    }

    func albumsEventTriggered() {
        switch direction {
           case .up:
              direction = .down
              fetchMediaItems()
              view?.changeCollectionView(assetsIsHidden: false)
            output?.albumsEventTriggered(isShown: false)
           case .down:
              direction = .up
              if collections.isEmpty {
                  setupCollections()
                }
                view?.update(with: collections)
                view?.changeCollectionView(assetsIsHidden: true)
                output?.albumsEventTriggered(isShown: true)
        }
        view?.updateTitleView(with: direction)
        view?.hidePlaceholdersIfNeeded()
    }

    func closeEventTriggered() {
        output?.closeEventTriggered()
    }

    func permissionEventTriggered() {
        dependencies.mediaLibraryService.requestMediaLibraryPermissions()
        setupPermissionsCollector()
    }

    func makePhotoEventTriggered(_ image: UIImage) {
        output?.photoEventTriggered(image)
    }

    func showActionSheetEventTriggered() {
        output?.showActionSheetEventTriggered(moreCompletion: { [weak self] in
            self?.output?.showLimitedPickerEventTriggered()
        }, settingCompletion: { [weak self] in
            self?.output?.openApplicationSettingEventTriggered()
        })
    }

    func filterEventTriggered(_ filter: MediaItemsFilter) {
        self.filter = filter
    }

    // MARK: - Helpers

    func updateSelection() {
        view?.updateSelection { item -> Int? in
            selectedItems.firstIndex(of: item)
        }
    }

    // MARK: - Private

    private func setupMediaItemsCollection(isHideTitle: Bool) {
        setupMediaItemsCollector(isHideTitle: isHideTitle)
        setupMediaLibraryUpdateEventCollector()
        setupCollections()
    }

    private func setupCollections() {
        dependencies.mediaLibraryService.fetchMediaItemCollections()
        collectionsCollector.subscribe { [weak self] (collections: [MediaItemsCollection]) in
            let lastUsedCollection = collections.first { collection in
                collection.identifier == self?.lastUsedCollectionId
            }
            if let collection = lastUsedCollection ?? collections.first {
                self?.collection = collection
            }
            self?.collections = collections
            self?.view?.update(with: collections)
        }
    }

    private func setupMediaItemsCollector(isHideTitle: Bool) {
        mediaItemsCollector.subscribe { [weak self] (result: MediaItemsFetchResult) in
            guard let self = self else {
                return
            }
            self.isFetching = false
            self.fetchResult = result
            self.view?.update(with: self.sectionItemsProvider(for: result.fetchResult), animated: true)
            self.output?.didFinishLoading(result.collection, isMixedContentCollection: result.filter == .all)
            self.view?.updateTitleView(with: result.collection.title,
                                       isHideTitle: isHideTitle,
                                       direction: self.direction)
        }
    }

    private func setupMediaLibraryUpdateEventCollector() {
        mediaLibraryUpdateEventCollector.subscribe { [weak self] _ in
            if self?.filter != nil {
                self?.fetchMediaItems()
            }
        }
    }

    private func sectionItemsProvider(for result: PHFetchResult<PHAsset>) -> LazySectionItemsProvider {
        let count = result.count
        let sectionAppearance = mediaAppearance.gallery.assetSectionAppearance

        let provider = LazySectionItemsProvider(factory: factory.complexFactory, cellItemsNumberHandler: { _ in
            count
        }, makeSectionItemHandler: { _ in
            let sectionItem = GeneralCollectionViewDiffSectionItem()
            sectionItem.minimumLineSpacing = sectionAppearance.minimumLineSpacing
            sectionItem.minimumInteritemSpacing = sectionAppearance.minimumInteritemSpacing
            sectionItem.insets = sectionAppearance.insets
            return sectionItem
        }, sizeHandler: { [weak self] _, collection in
            let numberOfItemsInRow = CGFloat(self?.mediaAppearance.gallery.assetSectionAppearance.numberOfItemsInRow ?? 0)
            let widthWithoutInsets: CGFloat = collection.bounds.width - sectionAppearance.insets.left - sectionAppearance.insets.right
            let width: CGFloat = (widthWithoutInsets - numberOfItemsInRow * sectionAppearance.minimumInteritemSpacing) / numberOfItemsInRow
            return CGSize(width: width, height: width)
        }, objectHandler: { [weak self] indexPath in
            guard let self = self,
                  indexPath.row < count else {
                return nil
            }
            let asset = result.object(at: count - indexPath.row - 1)
            let mediaItem = MediaItem(asset: asset)
            let selectionIndex = self.selectedItems.firstIndex(of: mediaItem)
            let isSelectionInfoLabelHidden = self.maxItemsCount == 1

            switch mediaItem.type {
              case .unknown:
                return EmptyItemCellModel(mediaItem: mediaItem, selectionIndex: selectionIndex)
              case .photo, .livePhoto:
                return PhotoItemCellModel(mediaItem: mediaItem,
                                          selectionIndex: selectionIndex,
                                          isSelectionInfoLabelHidden: isSelectionInfoLabelHidden)
              case .video, .sloMoVideo:
                return VideoItemCellModel(mediaItem: mediaItem,
                                          selectionIndex: selectionIndex,
                                          isSelectionInfoLabelHidden: isSelectionInfoLabelHidden)
            }
        })
        return provider
    }

    private func updateMediaItemList(usingPlaceholderTransition: Bool) {

        if usingPlaceholderTransition {
            view?.showMediaItemsPlaceholder(estimatedItemCount: min(collection?.estimatedMediaItemsCount ?? 64, 64))
        }

        fetchMediaItems()
    }

    private func setupPermissionsCollector() {
        permissionsCollector.subscribe { [weak self] status in
            switch status {
               case .denied, .notDetermined:
                  self?.view?.showMediaLibraryDeniedPermissionsPlaceholder()
               default:
                  return
            }
        }
    }

    private func setupForegroundObserver() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(appEnterForeground),
                                       name: UIApplication.willEnterForegroundNotification,
                                       object: nil)
    }

    private func fetchMediaItems() {
        guard isFetching == false else {
            return
        }
        isFetching = true
        dependencies.mediaLibraryService.fetchMediaItems(in: collection, filter: filter)
    }

    @objc private func appEnterForeground() {
        setupCollections()
    }

}

// MARK: - MediaItemSectionsFactoryOutput
extension GalleryPresenter: GallerySectionsFactoryOutput {

    func didSelect(_ collection: MediaItemsCollection) {
        direction = .down
        self.collection = collection
        lastUsedCollectionId = collection.identifier
        view?.changeCollectionView(assetsIsHidden: false)
        output?.albumsEventTriggered(isShown: false)
    }

    func didSelect(_ item: MediaItem) {
        output?.selectMediaItemsEventTriggered([item])
    }

    func didRequestPreviewStart(item: MediaItem, from rect: CGRect) {
        output?.didStartPreview(item: item, from: rect)
    }

    func didRequestPreviewStop(item: MediaItem) {
        output?.didStopPreview(item: item)
    }
}

// MARK: - MediaItemsModuleInput
extension GalleryPresenter: GalleryModuleInput {

    public func update(isAuthorized: Bool) {
        if isAuthorized {
            fetchMediaItems()
        }
        else {
            view?.showMediaLibraryDeniedPermissionsPlaceholder()
        }
    }
}
