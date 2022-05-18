//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import Texstyle
import Framezilla

public final class PlaceholderView: UIView {

    private let placehiolderAppearance: PlaceholderAppearance

    // MARK: - Subviews

    public private(set) lazy var separatorView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()

    public private(set) lazy var titleLabel: UILabel = .init()

    public private(set) lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    public private(set) lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle

    init(placeholderAppearance: PlaceholderAppearance) {
        self.placehiolderAppearance = placeholderAppearance
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = placehiolderAppearance.backgroundColor

        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(button)
        addSubview(separatorView)
        placehiolderAppearance.configure(placeholderView: self)
    }

    // MARK: - Layout

    override public func layoutSubviews() {
        super.layoutSubviews()
        placehiolderAppearance.layout(placeholderView: self)
    }

    // MARK: - Actions

    @objc private func buttonPressed() {
        placehiolderAppearance.buttonAction?()
    }
}
