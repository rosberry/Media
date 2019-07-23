//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import Texstyle
import Framezilla

final class PermissionsPlaceholderView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.backgroundColor = .main1
        button.contentEdgeInsets = UIEdgeInsets(top: 14, left: 24, bottom: 11, right: 24)
        button.setAttributedTitle(Text(value: L10n.Permissions.action.uppercased(), style: .title2a).attributed, for: .normal)
        button.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Accessors
    
    var title: String? {
        set {
            guard let title = newValue else {
                titleLabel.text = nil
                return
            }
            titleLabel.attributedText = title.text(with: .heading4a).attributed
        }
        get {
            return titleLabel.text
        }
    }
    
    var subtitle: String? {
        set {
            guard let subtitle = newValue else {
                subtitleLabel.text = nil
                return
            }
            subtitleLabel.attributedText = subtitle.text(with: .paragraph2d).attributed
        }
        get {
            return subtitleLabel.text
        }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .main2
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(settingsButton)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        subtitleLabel.configureFrame { (maker: Maker) in
            maker.left(inset: 40).right(inset: 40)
            maker.centerY()
            maker.heightToFit()
        }
        
        titleLabel.configureFrame { (maker: Maker) in
            maker.left(inset: 40).right(inset: 40)
            maker.bottom(to: subtitleLabel.nui_top, inset: 8)
            maker.heightToFit()
        }
        
        settingsButton.configureFrame { (maker: Maker) in
            maker.top(to: subtitleLabel.nui_bottom, inset: 24)
            maker.centerX()
            maker.sizeToFit()
            maker.cornerRadius(byHalf: .height)
        }
    }
    
    // MARK: - Actions
    
    @objc private func settingsButtonPressed() {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            return
        }
        
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) else {
            return
        }
        
        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
    }
}
