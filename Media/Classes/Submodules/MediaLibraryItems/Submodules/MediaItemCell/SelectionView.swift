//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import UIKit
import Framezilla

final class SelectionView: UIView {

    private(set) lazy var selectionInfoLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .main1
        return label
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
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
            maker.width(28).height(28)
        }
    }

    // MARK: - Private

    private func setup() {
        addSubview(selectionInfoLabel)
    }
}
