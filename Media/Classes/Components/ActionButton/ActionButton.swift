//
//  Copyright © 2022 Rosberry. All rights reserved.
//

import UIKit
import Texstyle

public final class ActionButton: UIButton {

    public var actionHandler: (() -> Void)?

    private let appearance: ActionButtonAppearance

    private(set) lazy var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = appearance.lineColor
        return view
    }()

    public init(appearance: ActionButtonAppearance,
                actionHandler: (() -> Void)? = nil) {
        self.appearance = appearance
        super.init(frame: .zero)
        let text = appearance.title.text(with: appearance.titleStyle)
        setAttributedTitle(text.attributed, for: .normal)
        self.actionHandler = actionHandler
        setup()
    }

    required init?(coder: NSCoder) {
        self.appearance = .init(title: L10n.dummy)
        super.init(coder: coder)
        setup()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        bottomLineView.configureFrame { maker in
            maker.left(inset: appearance.cornerRadius).right(inset: appearance.cornerRadius).bottom().height(1)
        }
    }

    private func setup() {
        backgroundColor = appearance.backgroundColor
        layer.cornerRadius = appearance.cornerRadius
        addSubview(bottomLineView)
        addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }

    @objc private func buttonPressed() {
        actionHandler?()
    }
}
