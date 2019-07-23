//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import AVFoundation

final class MediaItemPreviewViewController: UIViewController {
    
    private var previewAspectRatio: CGFloat = 1.0

    private let presenter: MediaItemPreviewPresenter

    // MARK: - Subviews
    
    private lazy var contentView: UIView = {
        return UIView()
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var playerView: PlayerView = {
        let view = PlayerView()
        view.alpha = 0.0
        return view
    }()

    // MARK: - Lifecycle

    init(presenter: MediaItemPreviewPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.isUserInteractionEnabled = false

        view.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(playerView)

        presenter.viewReadyEventTriggered()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        CATransaction.begin()
        CATransaction.setDisableActions(true)

        var frame = view.bounds
        let safeAreaInsets = view.window?.safeAreaInsets ?? view.safeAreaInsets
        
        frame.origin.y = safeAreaInsets.top
        frame.size.height = min(frame.width / previewAspectRatio, view.bounds.height - (safeAreaInsets.top + safeAreaInsets.bottom))

        contentView.frame = frame
        imageView.frame = contentView.bounds
        playerView.frame = contentView.bounds

        CATransaction.commit()
    }

    // MARK: - Helpers

    private func fadeIn() {
        view.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.35) {
            self.view.backgroundColor = UIColor.main1.withAlphaComponent(0.75)
            self.imageView.alpha = 1.0
            self.playerView.alpha = 1.0
        }
    }

    private func fadeOut() {
        self.removeFromParent()
        guard playerView.player != nil || imageView.image != nil else {
            return
        }

        view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.35, animations: {
            self.view.backgroundColor = .clear
            self.imageView.alpha = 0.0
            self.playerView.alpha = 0.0
        }, completion: { _ in
            self.playerView.player = nil
            self.imageView.image = nil

            self.view.removeFromSuperview()
        })
    }

    // MARK: -

    func updateWithEmptyState() {
        fadeOut()
    }

    func update(with player: AVPlayer, size: CGSize?) {
        playerView.player = player
        if let size = size {
            previewAspectRatio = size.width / size.height
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }

        fadeIn()
    }

    func update(with image: UIImage) {
        playerView.player = nil
        imageView.image = image

        previewAspectRatio = image.size.width / image.size.height
        view.setNeedsLayout()
        view.layoutIfNeeded()

        fadeIn()
    }
}
