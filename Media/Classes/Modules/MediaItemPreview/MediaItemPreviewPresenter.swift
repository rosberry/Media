//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import AVFoundation
import UIKit
import MediaService

typealias MediaItemPreviewDependencies = HasMediaLibraryService

final class MediaItemPreviewPresenter {

    private var playerItemStateObserver: AnyObject?
    private let dependencies: MediaItemPreviewDependencies
    weak var view: MediaItemPreviewViewController?

    weak var output: MediaItemPreviewModuleOutput?

    var mediaItem: MediaItem? {
        didSet {
            updateContent()
        }
    }

    var player: AVPlayer?

    // MARK: - Lifecycle

    init(dependencies: MediaItemPreviewDependencies) {
        self.dependencies = dependencies
    }

    func viewReadyEventTriggered() {

    }

    // MARK: - Helpers

    private func updateContent() {
        guard let mediaItem = mediaItem else {
            view?.updateWithEmptyState()
            removeCurrentPlayerItemStateObserver()
            player?.pause()
            player = nil
            return
        }

        if mediaItem.type.isVideo || mediaItem.type.isLivePhoto {
            updateVideoPreview(mediaItem: mediaItem)
        }
        else {
            updatePhotoPreview(mediaItem: mediaItem)
        }
    }

    private func updateVideoPreview(mediaItem: MediaItem) {
        view?.updateWithEmptyState()

        dependencies.mediaLibraryService.fetchVideoAsset(for: mediaItem) { [weak self] (asset: AVAsset?) in
            guard let asset = asset, mediaItem == self?.mediaItem else {
                return
            }

            let playerItem = AVPlayerItem(asset: asset)
            let player = AVPlayer(playerItem: playerItem)
            self?.setupCurrentPlayerItemStateObserver(for: player)
            player.play()

            self?.view?.update(with: player, size: asset.presentationSize)
            self?.player = player
        }
    }

    private func updatePhotoPreview(mediaItem: MediaItem) {
        player = nil
        view?.updateWithEmptyState()

        dependencies.mediaLibraryService.fetchImage(for: mediaItem) { [weak self] (image: UIImage?) in
            guard let image = image, mediaItem == self?.mediaItem else {
                return
            }

            self?.view?.update(with: image)
        }
    }

    // MARK: - Observer

    private func setupCurrentPlayerItemStateObserver(for player: AVPlayer) {
        playerItemStateObserver = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                                                         object: player.currentItem,
                                                                         queue: .main) { _ in
            player.seek(to: .zero)
            player.play()
        }
    }

    private func removeCurrentPlayerItemStateObserver() {
        guard let observer = playerItemStateObserver else {
            return
        }

        NotificationCenter.default.removeObserver(observer)
    }
}

// MARK: - MediaItemPreviewModuleInput

extension MediaItemPreviewPresenter: MediaItemPreviewModuleInput {
	//
}
