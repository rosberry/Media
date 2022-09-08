//
//  Copyright © 2022 Rosberry. All rights reserved.
//

import UIKit
import Texstyle

public final class ActionButton: UIButton {

    public var actionHandler: (() -> Void)?

    private(set) lazy var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .main1A
        return view
    }()

    public init(title: String, textStyle: TextStyle, actionHandler: (() -> Void)? = nil) {
        super.init(frame: .zero)
        let text = title.text(with: textStyle)
        setAttributedTitle(text.attributed, for: .normal)
        self.actionHandler = actionHandler
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        bottomLineView.configureFrame { maker in
            maker.left().right().bottom().height(1)
        }
    }

    private func setup() {
        backgroundColor = .clear
        layer.cornerRadius = 14
        addSubview(bottomLineView)
        addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }

    @objc private func buttonPressed() {
        actionHandler?()
    }
}
