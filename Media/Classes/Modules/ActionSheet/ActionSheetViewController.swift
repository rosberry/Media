//
//  Copyright © 2022 Rosberry. All rights reserved.
//

import UIKit
import Texstyle

public final class ActionSheetViewController: UIViewController {

   public var buttonHeight: CGFloat = 56
   public var sideInsets: UIEdgeInsets = .init(top: 0, left: 16, bottom: 8, right: 16)

   public var actionButtons: [ActionButton] = [] {
        willSet {
            actionButtons.forEach { button in
                button.removeFromSuperview()
            }
        }
        didSet {
            actionButtons.forEach { actionButton in
                actionButtonsContainerView.addSubview(actionButton)
            }
            actionButtons.last?.bottomLineView.isHidden = true
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }

    private let appearance: ActionSheetAppearance
    private var cancelAppearance: ActionButtonAppearance {
        appearance.cancelButtonAppearance
    }

    private lazy var tapRecognizer: UITapGestureRecognizer = .init(target: self,
                                                                   action: #selector(backgroundViewTapped))

    // MARK: - Subviews

    private(set) lazy var contentView: UIView = .init()

    private(set) lazy var actionButtonsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = appearance.buttonContainerColor
        view.layer.cornerRadius = appearance.buttonContainerCornerRadius
        view.clipsToBounds = true
        return view
    }()

    private(set) lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = appearance.backgroundColor
        view.isUserInteractionEnabled = true
        return view
    }()

    private(set) lazy var cancelButton: UIButton = {
        let view = UIButton()
        let text = cancelAppearance.title.text(with: cancelAppearance.titleStyle)
        view.backgroundColor = cancelAppearance.backgroundColor
        view.setAttributedTitle(text.attributed, for: .normal)
        view.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return view
    }()

    private var separators: [UIView] = []

    // MARK: - Lifecycle

    init(appearance: ActionSheetAppearance) {
        self.appearance = appearance
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        contentView.addGestureRecognizer(tapRecognizer)

        contentView.addSubview(cancelButton)
        contentView.addSubview(actionButtonsContainerView)

        view.addSubview(backgroundView)
        view.addSubview(contentView)
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        backgroundView.frame = view.bounds

        contentView.configureFrame { maker in
            maker.edges(insets: sideInsets, sides: [.horizontal])
                .bottom(to: view.nui_safeArea.bottom, inset: sideInsets.bottom)
                .top()
        }

        cancelButton.configureFrame { maker in
            maker.left().right().bottom().cornerRadius(14).height(buttonHeight)
        }

        actionButtonsContainerView.configureFrame { maker in
            let height = CGFloat(actionButtons.count) * buttonHeight
            maker.left().right().bottom(to: cancelButton.nui_top, inset: 8)
                .height(height).cornerRadius(14)
        }

        var previousRelation = actionButtonsContainerView.nui_top
        actionButtons.forEach { actionButton in
            actionButton.configureFrame { maker in
                maker.left().right().top(to: previousRelation).height(buttonHeight)
            }
            previousRelation = actionButton.nui_bottom
        }
    }

    // MARK: - Private

    @objc private func cancelButtonPressed() {
        dismiss(animated: true)
    }

    @objc private func backgroundViewTapped() {
        dismiss(animated: true)
    }
}
