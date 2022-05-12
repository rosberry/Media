//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import Texstyle

open class AssetCellAppearance {

    public var selectionViewInitializer: () -> UIView = {
        let view = SelectionView(textColor: .white)
        view.alpha = 0.0
        return view
    }

    public init() {
    }

    open func update(cell: MediaItemCell, viewModel: EmptyItemCellModel) {
        guard let selectionView = cell.selectionView as? SelectionView else {
            return
        }
        if let selectionIndex = viewModel.selectionIndex {
            selectionView.alpha = 1.0
            selectionView.selectionInfoLabel.text = "\(selectionIndex + 1)"
            cell.imageView.layer.cornerRadius = selectionView.layer.cornerRadius
        }
        else {
            selectionView.alpha = 0.0
            selectionView.selectionInfoLabel.text = nil
            cell.imageView.layer.cornerRadius = 0.0
        }
    }

    open func layout(cell: MediaItemCell) {
        cell.bringSubviewToFront(cell.infoView)
    }

    open func updateInfoLabelForVideoItem(cell: MediaItemCell, viewModel: EmptyItemCellModel) {
    }
}

open class DefaultAssetCellAppearance: AssetCellAppearance {
    public var contentViewCornerRadius: Double
    public var contentViewColor: UIColor
    public var infoViewCornerRadius: Double
    public var infoTitleStyle: TextStyle
    public var infoViewBackgroundColor: UIColor
    public var selectedColor: UIColor
    public var highlightedColor: UIColor

    public init(contentViewCornerRadius: Double = 0,
                contentViewColor: UIColor = .clear,
                infoViewCornerRadius: Double = 4,
                infoViewBackgroundColor: UIColor = .main1A,
                infoTitleStyle: TextStyle = .subtitle1B,
                selectedColor: UIColor = .clear,
                highlightedColor: UIColor = .clear) {
        self.contentViewCornerRadius = contentViewCornerRadius
        self.contentViewColor = contentViewColor
        self.infoViewCornerRadius = infoViewCornerRadius
        self.infoViewBackgroundColor = infoViewBackgroundColor
        self.infoTitleStyle = infoTitleStyle
        self.selectedColor = selectedColor
        self.highlightedColor = highlightedColor
    }

    open override func update(cell: MediaItemCell, viewModel: EmptyItemCellModel) {
        super.update(cell: cell, viewModel: viewModel)
        cell.infoView.backgroundColor = infoViewBackgroundColor
        cell.infoView.layer.cornerRadius = CGFloat(infoViewCornerRadius)
        cell.contentView.backgroundColor = contentViewColor
        cell.contentView.layer.cornerRadius = CGFloat(contentViewCornerRadius)
    }

    open override func updateInfoLabelForVideoItem(cell: MediaItemCell, viewModel: EmptyItemCellModel) {
        guard let duration = viewModel.mediaItem.duration else {
            return
        }

        let minutes = Int(duration / 60)
        let seconds = Int(duration) % 60
        cell.infoLabel.attributedText = String(format: "%01d:%02d", minutes, seconds).text(with: infoTitleStyle).attributed
    }
}
