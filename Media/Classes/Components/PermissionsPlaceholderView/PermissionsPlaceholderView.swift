//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import Framezilla

final class PermissionsPlaceholderView: UIView {

    var title: String? {
        get {
            titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }

    var subtitle: String? {
        get {
            subtitleLabel.text
        }
        set {
            subtitleLabel.text = newValue
        }
    }

    // MARK: - Subviews

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()

    private lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.backgroundColor = UIColor.black
        button.contentEdgeInsets = UIEdgeInsets(top: 14, left: 24, bottom: 14, right: 24)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle(L10n.Permissions.action.uppercased(), for: .normal)
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
            maker.left(inset: 40).right(inset: 40)
            maker.centerY()
            maker.heightToFit()
        }

        titleLabel.configureFrame { maker in
            maker.left(inset: 40).right(inset: 40)
            maker.bottom(to: subtitleLabel.nui_top, inset: 8)
            maker.heightToFit()
        }

        settingsButton.configureFrame { maker in
            maker.top(to: subtitleLabel.nui_bottom, inset: 24)
            maker.centerX()
            maker.sizeToFit()
            maker.cornerRadius(byHalf: .height)
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
