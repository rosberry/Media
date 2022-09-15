//
//  Copyright © 2022 Rosberry. All rights reserved.
//

import Texstyle
import Framezilla
import UIKit

open class PlaceholderAppearance {
    public var title: NSAttributedString?
    public var subtitle: NSAttributedString?
    public var buttonTitle: NSAttributedString?

    public var buttonBackgroundColor: UIColor
    public var buttonCornerRadius: Double
    public var backgroundColor: UIColor

    public var buttonAction: (() -> Void)?

    public init(title: NSAttributedString?,
                subtitle: NSAttributedString?,
                buttonTitle: NSAttributedString?,
                buttonBackgroundColor: UIColor = .button1A,
                buttonCornerRadius: Double = 10,
                backgroundColor: UIColor = .white) {
        self.title = title
        self.subtitle = subtitle
        self.buttonTitle = buttonTitle
        self.buttonBackgroundColor = buttonBackgroundColor
        self.buttonCornerRadius = buttonCornerRadius
        self.backgroundColor = backgroundColor
    }

    open func configure(placeholderView: PlaceholderView) {
        placeholderView.button.setAttributedTitle(buttonTitle, for: .normal)
        placeholderView.button.layer.cornerRadius = buttonCornerRadius
        placeholderView.button.backgroundColor = buttonBackgroundColor

        placeholderView.titleLabel.attributedText = title
        placeholderView.subtitleLabel.attributedText = subtitle
    }

    open func layout(placeholderView: PlaceholderView) {
        placeholderView.subtitleLabel.configureFrame { maker in
            maker.left(inset: 16).right(inset: 16)
            maker.centerY()
            maker.heightToFit()
        }

        placeholderView.titleLabel.configureFrame { maker in
            maker.left(inset: 16).right(inset: 16)
            maker.bottom(to: placeholderView.subtitleLabel.nui_top, inset: 8)
            maker.heightToFit()
        }

        placeholderView.button.configureFrame { maker in
            maker.top(to: placeholderView.subtitleLabel.nui_bottom, inset: 24)
            maker.centerX()
            maker.left(inset: 68).right(inset: 68)
            maker.height(50)
        }
    }
}

open class DefaultPermissionsAppearance: PlaceholderAppearance {
    public convenience init(bundleName: String = (Bundle.main.infoDictionary?["CFBundleName"] as? String) ?? "App") {
        self.init(title: Text(value: L10n.MediaLibrary.Permissions.title, style: .title2A).attributed,
                  subtitle: Text(value: L10n.MediaLibrary.Permissions.subtitle(bundleName), style: .body1A).attributed,
                  buttonTitle: Text(value: L10n.Permissions.action, style: .title4B).attributed)
    }

    override public init(title: NSAttributedString?,
                         subtitle: NSAttributedString?,
                         buttonTitle: NSAttributedString?,
                         buttonBackgroundColor: UIColor = .button1A,
                         buttonCornerRadius: Double = 10,
                         backgroundColor: UIColor = .white) {
        super.init(title: title,
                   subtitle: subtitle,
                   buttonTitle: buttonTitle,
                   buttonBackgroundColor: buttonBackgroundColor,
                   buttonCornerRadius: buttonCornerRadius,
                   backgroundColor: backgroundColor)
        buttonAction = {
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
    }
}

open class DefaultPlaceholderAppearance: PlaceholderAppearance {

    public init(subtitle: NSAttributedString?) {
        super.init(title: nil,
                   subtitle: subtitle,
                   buttonTitle: nil)
    }

    public convenience init() {
        self.init(subtitle: Text(value: L10n.MediaLibrary.Placeholder.subtitle, style: .body1A).attributed)
    }

    override open func configure(placeholderView: PlaceholderView) {
        super.configure(placeholderView: placeholderView)
        placeholderView.button.isHidden = true
    }
}
