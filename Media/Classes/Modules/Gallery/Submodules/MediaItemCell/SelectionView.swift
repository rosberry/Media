//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import UIKit
import Framezilla

final class SelectionView: UIView {

    private(set) lazy var selectionInfoLabel: UILabel = .init()

    // MARK: - Lifecycle

    init(textColor: UIColor) {
        super.init(frame: .zero)
        selectionInfoLabel.textColor = textColor
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        selectionInfoLabel.configureFrame { (maker: Maker) in
            maker.right().top()
            .width(28).height(28)
        }
    }

    // MARK: - Private

    private func setup() {
        addSubview(selectionInfoLabel)
    }
}
