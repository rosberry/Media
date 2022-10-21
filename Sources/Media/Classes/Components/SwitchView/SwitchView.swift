//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import Texstyle

public final class SwitchItem {

    var title: String
    var handler: () -> Void

    init(title: String, handler: @escaping () -> Void) {
        self.title = title
        self.handler = handler
    }
}

public final class SwitchItemButton: UIButton {

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

public final class SwitchView: UIView {

    public var selectedItemStyle: TextStyle = .toggle1A
    public var deselectedItemStyle: TextStyle = .toggle1B
    public var fillColor: UIColor = .white {
        didSet {
            backgroundLayer.fillColor = fillColor.cgColor
        }
    }
    public var selectionFillColor: UIColor = .clear {
        didSet {
            selectionLayer.fillColor = selectionFillColor.cgColor
        }
    }
    public var selectionStrokeColor: UIColor = .black {
        didSet {
            selectionLayer.strokeColor = selectionStrokeColor.cgColor
        }
    }
    public var selectionStrokeWidth: CGFloat = 2 {
        didSet {
            selectionLayer.lineWidth = selectionStrokeWidth
        }
    }
    public var preferredHeight: CGFloat = 32
    public var itemPadding: CGFloat = 8
    public var cornerRoundHandler: ((CGRect) -> CGFloat) = { $0.height / 2 }

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

    private var itemViews: [SwitchItemButton] = []

    // MARK: - Layers

    private(set) lazy var backgroundLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = fillColor.cgColor
        return layer
    }()

    private lazy var selectionLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = selectionFillColor.cgColor
        layer.strokeColor = selectionStrokeColor.cgColor
        layer.lineWidth = selectionStrokeWidth
        return layer
    }()

    // MARK: - Lifecycle

    public override func layoutSubviews() {
        super.layoutSubviews()

        var offset: CGFloat = 0.0

        backgroundLayer.frame = bounds
        backgroundLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRoundHandler(bounds)).cgPath

        for view in itemViews {
            let itemWidth = view.sizeThatFits(bounds.size).width + 2 * itemPadding
            view.frame =  CGRect(x: offset, y: 0.0, width: itemWidth, height: bounds.height)
            offset += itemWidth

            if view.tag == selectedIndex {
                view.alpha = 1.0
                view.setAttributedTitle(Text(value: view.item.title, style: selectedItemStyle).attributed, for: .normal)
                selectionLayer.frame = view.frame.insetBy(dx: 2, dy: 2)
                selectionLayer.path = UIBezierPath(roundedRect: selectionLayer.bounds,
                                                   cornerRadius: cornerRoundHandler(selectionLayer.bounds)).cgPath
            }
            else {
                view.setAttributedTitle(Text(value: view.item.title, style: deselectedItemStyle).attributed, for: .normal)
                view.alpha = inactiveItemAlpha
            }
        }
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        let width = itemViews.reduce(0) { result, view in
            result + view.sizeThatFits(size).width + 2 * itemPadding
        }
        return CGSize(width: width, height: preferredHeight)
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
