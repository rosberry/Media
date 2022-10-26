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
    private var isShowActionSheetView: Bool
    private var isAnimated: Bool = false
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
        view.addGestureRecognizer(tapRecognizer)
        view.alpha = 0
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
        self.isShowActionSheetView = false
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        contentView.addSubview(cancelButton)
        contentView.addSubview(actionButtonsContainerView)

        view.addSubview(backgroundView)
        view.addSubview(contentView)
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        backgroundView.frame = view.bounds

        [actionButtonsContainerView, cancelButton].configure(container: contentView,
                                                             relation: .horizontal(left: sideInsets.left,
                                                                                   right: sideInsets.right)) {
            actionButtons.configure(container: actionButtonsContainerView, relation: .horizontal(left: 0, right: 0)) {
                (0..<actionButtons.count).forEach { index in
                    actionButtons[index].configureFrame { maker in
                        maker.left().right().top(inset: buttonHeight * CGFloat(index)).height(buttonHeight)
                    }
                }
            }

            actionButtonsContainerView.configureFrame { maker in
                maker.left().right().top().centerX().sizeToFit().cornerRadius(14)
            }

            cancelButton.configureFrame { maker in
                maker.left().right().height(buttonHeight)
                    .top(to: actionButtonsContainerView.nui_bottom, inset: 8).cornerRadius(14)
            }
        }

        contentView.configureFrame { maker in
            maker.centerX()
            if isShowActionSheetView {
                maker.bottom(to: view.nui_safeArea.bottom, inset: sideInsets.bottom)
            }
            else {
                maker.top(to: view.nui_bottom, inset: sideInsets.bottom)
            }
        }
    }

    func animateActionSheetPreview(_ isShowActionSheetView: Bool = true,
                                   animated: Bool = true,
                                   completion: (() -> Void)? = nil) {
        self.isShowActionSheetView = isShowActionSheetView
        self.isAnimated = animated
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut]) { [weak self] in
                self?.updateViewLayout()
            } completion: { _ in
                completion?()
            }
        }
        else {
            updateViewLayout()
            completion?()
        }
    }

    // MARK: - Private

    private func updateViewLayout() {
        backgroundView.alpha = isShowActionSheetView ? 1 : 0
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

    private func dismiss() {
        animateActionSheetPreview(false, animated: isAnimated) { [weak self] in
            self?.dismiss(animated: false)
        }
    }

    @objc private func cancelButtonPressed() {
        dismiss()
    }

    @objc private func backgroundViewTapped() {
        dismiss()
    }
}
