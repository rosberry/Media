//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import Texstyle
import Framezilla

final class PermissionsPlaceholderView: UIView {

    var title: String? {
        get {
            titleLabel.text
        }
        set {
            titleLabel.attributedText = newValue?.text(with: .title2A).attributed
        }
    }

    var subtitle: String? {
        get {
            subtitleLabel.text
        }
        set {
            subtitleLabel.attributedText = newValue?.text(with: .body1A).attributed
        }
    }

    // MARK: - Subviews

    private lazy var titleLabel: UILabel = .init()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    private lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.backgroundColor = .button1A
        button.setTitleColor(UIColor.white, for: .normal)
        button.setAttributedTitle(L10n.Permissions.action.text(with: .title4B).attributed, for: .normal)
        button.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = UIColor.white

        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(settingsButton)
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        subtitleLabel.configureFrame { maker in
            maker.left(inset: 16).right(inset: 16)
            maker.centerY()
            maker.heightToFit()
        }

        titleLabel.configureFrame { maker in
            maker.left(inset: 16).right(inset: 16)
            maker.bottom(to: subtitleLabel.nui_top, inset: 8)
            maker.heightToFit()
        }

        settingsButton.configureFrame { maker in
            maker.top(to: subtitleLabel.nui_bottom, inset: 24)
            maker.centerX()
            maker.left(inset: 68).right(inset: 68)
            maker.height(50)
        }
    }

    // MARK: - Actions

    @objc private func settingsButtonPressed() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
    }
}
