//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import UIKit
import Ion
import Photos
import PhotosUI
import MediaService

public protocol MediaCoordinatorDelegate: AnyObject {
    func selectMediaItemsEventTriggered(_ mediaItems: [MediaItem])
    func photoEventTriggered(_ image: UIImage)
    func moreEventTriggered()
    func settingEventTriggered()
    func customEventTriggered()
}

public final class MediaCoordinator {

    typealias Dependencies = HasMediaLibraryService

    private lazy var dependencies: Dependencies = Services

    let navigationViewController: UINavigationController
    public weak var delegate: MediaCoordinatorDelegate?

    private lazy var permissionsCollector: Collector<PHAuthorizationStatus> = {
        return .init(source: dependencies.mediaLibraryService.permissionStatusEventSource)
    }()

    public var maxItemsCount: Int = 2
    public var numberOfItemsInRow: Int = 4

    public var mediaAppearance: MediaAppearance
    public var isAccessManagerEnabled: Bool = false
    public var filter: MediaItemsFilter

    private var actionButtonsAppearance: [ActionButtonAppearance] {
        mediaAppearance.actionSheet.actionButtonsAppearance
    }

    // MARK: - Modules

    private var galleryModule: GalleryModule?

    // MARK: - Lifecycle

    public init(navigationViewController: UINavigationController, mediaAppearance: MediaAppearance, filter: MediaItemsFilter = .all) {
        self.navigationViewController = navigationViewController
        self.mediaAppearance = mediaAppearance
        self.filter = filter
        setupPermissionsCollector()
    }

    public init(navigationViewController: UINavigationController, filter: MediaItemsFilter = .all) {
        self.navigationViewController = navigationViewController
        self.mediaAppearance = .init()
        self.filter = filter
        setupPermissionsCollector()
    }

    public func start(bundleName: String) {
        let module = makeGalleryModule(bundleName: bundleName)
        galleryModule = module
        navigationViewController.pushViewController(module.viewController, animated: true)
        dependencies.mediaLibraryService.requestMediaLibraryPermissions()
    }

    // MARK: - Private

    private func setupPermissionsCollector() {
        permissionsCollector.subscribe { [weak self] status in
            self?.galleryModule?.input.update(isAuthorized: status == .authorized)
        }
    }

    private func makeGalleryModule(bundleName: String) -> GalleryModule {
        let module = GalleryModule(bundleName: bundleName,
                                   isAccessManagerEnabled: isAccessManagerEnabled,
                                   filter: filter,
                                   maxItemsCount: maxItemsCount,
                                   numberOfItemsInRow: numberOfItemsInRow,
                                   mediaAppearance: mediaAppearance)
        module.output = self
        return module
    }

    private func makeMediaItemPreviewModule() -> MediaItemPreviewModule {
        let module = MediaItemPreviewModule()
        module.viewController.modalPresentationStyle = .overCurrentContext
        module.viewController.modalTransitionStyle = .crossDissolve
        module.viewController.modalPresentationCapturesStatusBarAppearance = false
        return module
    }
}

// MARK: - MediaItemsModuleOutput
extension MediaCoordinator: GalleryModuleOutput {
    public func didStartPreview(item: MediaItem, from rect: CGRect) {
        let module = makeMediaItemPreviewModule()
        module.input.mediaItem = item
        navigationViewController.present(module.viewController, animated: true, completion: nil)
    }

    public func didStopPreview(item: MediaItem) {
        navigationViewController.dismiss(animated: true, completion: nil)
    }

    public func didFinishLoading(_ collection: MediaItemsCollection, isMixedContentCollection: Bool) {

    }

    public func closeEventTriggered() {
        navigationViewController.popViewController(animated: true)
    }

    public func selectMediaItemsEventTriggered(_ mediaItems: [MediaItem]) {
        navigationViewController.popViewController(animated: true)
        delegate?.selectMediaItemsEventTriggered(mediaItems)
    }

    public func photoEventTriggered(_ image: UIImage) {
        navigationViewController.popViewController(animated: true)
        delegate?.photoEventTriggered(image)
    }

    public func showActionSheetEventTriggered(moreCompletion: @escaping () -> Void,
                                              settingCompletion: @escaping () -> Void) {
        let actionSheetViewController = ActionSheetViewController(appearance: mediaAppearance.actionSheet)
        let actionButtons: [ActionButton] = actionButtonsAppearance.map { appearance in
            let actionButton = ActionButton(appearance: appearance)
            switch appearance.type {
                case .more:
                    actionButton.actionHandler = {
                        actionSheetViewController.dismiss(animated: true) { [weak self] in
                            moreCompletion()
                            self?.delegate?.moreEventTriggered()
                        }
                    }
                case .setting:
                    actionButton.actionHandler = { [weak self] in
                        settingCompletion()
                        self?.delegate?.settingEventTriggered()
                    }
                case .custom:
                    actionButton.actionHandler = { [weak self] in
                        self?.delegate?.customEventTriggered()
                    }
                default:
                    break
            }
            return actionButton
        }
        actionSheetViewController.actionButtons = actionButtons
        navigationViewController.present(actionSheetViewController, animated: true)
    }

    public func openApplicationSettingEventTriggered() {
        let settingsUrl = URL(string: UIApplication.openSettingsURLString)
        if let settingsUrl = settingsUrl, UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }

    public func showLimitedPickerEventTriggered() {
        if #available(iOS 14, *) {
            PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: navigationViewController)
        }
    }
}
