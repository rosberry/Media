//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import Texstyle

open class AlbumCellAppearance {
    public var titleStyle: TextStyle
    public var subtitleStyle: TextStyle

    public var titleFormatter: (String?) -> String? = { $0 }
    public var subtitleFormatter: (String?) -> String? = { $0 }

    init(titleStyle: TextStyle, subtitleStyle: TextStyle) {
        self.titleStyle = titleStyle
        self.subtitleStyle = subtitleStyle
    }

    open func highlightChanged(cell: CollectionCell, value: Bool) {
    }

    open func update(cell: CollectionCell, viewModel: CollectionCellModel) {
        cell.imageView.image = viewModel.thumbnail
        cell.titleLabel.attributedText = titleFormatter(viewModel.title)?.text(with: titleStyle).attributed

        var itemCountLabelString: String?
        switch viewModel.estimatedMediaItemsCount {
           case .none:
              itemCountLabelString = L10n.MediaLibrary.unknown
           case .max?:
              if viewModel.isFavorite {
                  itemCountLabelString = L10n.MediaLibrary.favoriteItems
              }
              else {
                  itemCountLabelString = L10n.MediaLibrary.allItems
              }
           case .some(let count):
              itemCountLabelString = "\(count)"
        }
        cell.itemCountLabel.attributedText = subtitleFormatter(itemCountLabelString)?.text(with: subtitleStyle).attributed
    }

    open func layout(cell: CollectionCell) {

    }
}

open class DefaultAlbumCellAppearance: AlbumCellAppearance {
    public var imageCornerRadius: Double
    public var contentViewCornerRadius: Double
    public var contentViewColor: UIColor
    public var selectedColor: UIColor
    public var highlightedColor: UIColor

    public init(titleStyle: TextStyle = .title4A,
                subtitleStyle: TextStyle = .subtitle2C,
                imageCornerRadios: Double = 8.0,
                contentViewCornerRadius: Double = 0,
                contentViewColor: UIColor = .clear,
                selectedColor: UIColor = .clear,
                highlightedColor: UIColor = .clear) {
        self.imageCornerRadius = imageCornerRadios
        self.contentViewCornerRadius = contentViewCornerRadius
        self.contentViewColor = contentViewColor
        self.selectedColor = selectedColor
        self.highlightedColor = highlightedColor
        super.init(titleStyle: titleStyle, subtitleStyle: subtitleStyle)
    }

    override open func highlightChanged(cell: CollectionCell, value: Bool) {
        if value {
            cell.contentView.backgroundColor = self.selectedColor
        }
        else {
            cell.contentView.backgroundColor = self.highlightedColor
        }
    }

    override open func update(cell: CollectionCell, viewModel: CollectionCellModel) {
        super.update(cell: cell, viewModel: viewModel)
        cell.imageView.layer.cornerRadius = imageCornerRadius
        cell.contentView.backgroundColor = contentViewColor
        cell.contentView.layer.cornerRadius = contentViewCornerRadius
    }

    override open func layout(cell: CollectionCell) {

    }
}
