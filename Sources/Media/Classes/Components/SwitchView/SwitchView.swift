//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit

final class SwitchItem {

    var title: String
    var handler: () -> Void

    init(title: String, handler: @escaping () -> Void) {
        self.title = title
        self.handler = handler
    }
}

final class SwitchItemButton: UIButton {

    let item: SwitchItem

    init(item: SwitchItem) {
        self.item = item
        super.init(frame: .zero)
        setTitleColor(UIColor.black, for: .normal)
        setTitle(item.title, for: .normal)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class SwitchView: UIView {

    var items: [SwitchItem] = [] {
        didSet {
            updateItemViews()
        }
    }

    var selectedIndex: Int = 0 {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    var inactiveItemAlpha: CGFloat = 1.0

    private var itemViews: [UIView] = []

    // MARK: - Layers

    private(set) lazy var backgroundLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.white.cgColor
        return layer
    }()

    private lazy var selectionLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.black.cgColor
        layer.lineWidth = 2.0
        return layer
    }()

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        var offset: CGFloat = 0.0
        let itemSize = CGSize(width: bounds.width / CGFloat(items.count), height: bounds.height)

        backgroundLayer.frame = bounds
        backgroundLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 2).cgPath

        for view in itemViews {
            view.frame = CGRect(x: offset, y: 0.0, width: itemSize.width, height: itemSize.height)
            offset += itemSize.width

            if view.tag == selectedIndex {
                view.alpha = 1.0
                selectionLayer.frame = view.frame.insetBy(dx: 2, dy: 2)
                selectionLayer.path = UIBezierPath(roundedRect: selectionLayer.bounds,
                                                   cornerRadius: selectionLayer.bounds.height / 2).cgPath
            }
            else {
                view.alpha = inactiveItemAlpha
            }
        }
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: 32.0)
    }

    // MARK: - Private

    private func updateItemViews() {
        itemViews.forEach { (view: UIView) in
            view.removeFromSuperview()
        }
        itemViews.removeAll()

        layer.addSublayer(backgroundLayer)

        for (index, item) in items.enumerated() {
            let view = SwitchItemButton(item: item)
            view.addTarget(self, action: #selector(itemPressed), for: .touchUpInside)
            view.tag = index

            addSubview(view)
            itemViews.append(view)
        }

        layer.addSublayer(selectionLayer)

        setNeedsLayout()
    }

    // MARK: - Actions

    @objc private func itemPressed(_ sender: UIView) {
        guard let view = sender as? SwitchItemButton else {
            return
        }

        guard view.tag != selectedIndex else {
            return
        }

        selectedIndex = view.tag
        view.item.handler()
    }
}
