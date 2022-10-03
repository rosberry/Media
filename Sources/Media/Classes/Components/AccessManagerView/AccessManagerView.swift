//
//  Copyright © 2022 Rosberry. All rights reserved.
//

import UIKit
import Framezilla
import Texstyle

public final class AccessManagerView: UIView {
    var manageEventHandler: (() -> Void)?

    private let managerAppearance: AccessManagerAppearance

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = managerAppearance.title.text(with: managerAppearance.titleStyle).attributed
        label.numberOfLines = 0
        return label
    }()

    private lazy var manageButton: ATRButton = {
        let button = ATRButton()
        button.touchRadiusInsets = 10
        button.setAttributedTitle(managerAppearance.buttonTitle.text(with: managerAppearance.buttonTitleStyle).attributed,
                                  for: .normal)
        button.addTarget(self, action: #selector(manageButtonPressed), for: .touchUpInside)
        return button
    }()

    init(managerAppearance: AccessManagerAppearance) {
        self.managerAppearance = managerAppearance
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        self.managerAppearance = .init()
        super.init(coder: coder)
        setup()
    }

    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        let buttonFrame = manageButton.sizeThatFits(.zero)
        let titleWidth = size.width - (buttonFrame.width + 40 + 24)
        let titleHeight = titleLabel.sizeThatFits(.init(width: titleWidth, height: .zero)).height + 24
        let buttonHeight = buttonFrame.height + 24
        let height = titleHeight > buttonHeight ? titleHeight : buttonHeight
        return .init(width: size.width, height: height)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        manageButton.sizeToFit()
        manageButton.configureFrame { maker in
            maker.right().height(bounds.height).width(manageButton.frame.width + 40).centerY()
        }

        titleLabel.configureFrame { maker in
            maker.left(inset: 16).top(inset: 12).bottom(inset: 12).right(to: manageButton.nui_left, inset: 8).heightToFit()
        }
    }

    private func setup() {
        addSubview(titleLabel)
        addSubview(manageButton)
        backgroundColor = managerAppearance.backgroundColor
        layer.cornerRadius = managerAppearance.cornerRadius
        clipsToBounds = true
    }

    @objc private func manageButtonPressed() {
        manageEventHandler?()
    }
}
