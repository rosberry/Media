//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import Texstyle

final class DropdownButton: UIButton {
    
    private lazy var arrowLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.main1.cgColor
        layer.lineCap = .round
        layer.lineJoin = .round
        layer.lineWidth = 2.0
        return layer
    }()
    
    private let arrowLayerWidth: CGFloat = 24
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                arrowLayer.transform = CATransform3DMakeRotation(.pi, 0.0, 0.0, 1.0)
            }
            else {
                arrowLayer.transform = CATransform3DIdentity
            }
        }
    }
    
    var title: String? {
        set {
            guard let title = newValue else {
                arrowLayer.isHidden = true
                setTitle(nil, for: .normal)
                return
            }
            arrowLayer.isHidden = false
            setAttributedTitle(title.text(with: TextStyle.title3.leftAligned()).attributed, for: .normal)
        }
        get {
            return attributedTitle(for: .normal)?.string
        }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentHorizontalAlignment = .left
        
        arrowLayer.isHidden = true
        layer.addSublayer(arrowLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let titleLabel = titleLabel else {
            return
        }
        
        titleLabel.configureFrame(installerBlock: { maker in
            maker.left()
            maker.top().bottom()
            maker.widthThatFits(maxWidth: bounds.width - arrowLayerWidth)
        })
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        arrowLayer.bounds = CGRect(x: 0.0, y: 0.0, width: arrowLayerWidth, height: arrowLayerWidth)
        arrowLayer.position = CGPoint(x: titleLabel.frame.maxX + arrowLayer.bounds.midX, y: bounds.midY)
        
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x: 6.5, y: 9.5))
        arrowPath.addLine(to: CGPoint(x: arrowLayer.bounds.midX, y: arrowLayer.bounds.height - 9.5))
        arrowPath.addLine(to: CGPoint(x: arrowLayer.bounds.width - 6.5, y: 9.5))
        arrowLayer.path = arrowPath.cgPath
        
        CATransaction.commit()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let labelConstrainedSize = CGSize(width: size.width - arrowLayerWidth, height: size.height)
        let labelSize = titleLabel?.sizeThatFits(labelConstrainedSize) ?? labelConstrainedSize
        return CGSize(width: labelSize.width + arrowLayerWidth, height: size.height)
    }
}
