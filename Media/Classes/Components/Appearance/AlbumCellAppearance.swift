//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import Texstyle

public class AlbumCellAppearance {
    public var titleStyle: TextStyle
    public var subtitleStyle: TextStyle

    init(titleStyle: TextStyle, subtitleStyle: TextStyle) {
        self.titleStyle = titleStyle
        self.subtitleStyle = subtitleStyle
    }

    func highlightChanged(cell: CollectionCell, value: Bool) {
    }

    func update(cell: CollectionCell, viewModel: CollectionCellModel) {
        cell.imageView.image = viewModel.thumbnail
        cell.titleLabel.attributedText = viewModel.title?.text(with: titleStyle).attributed

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
        cell.itemCountLabel.attributedText = itemCountLabelString?.text(with: subtitleStyle).attributed
    }
}


public class DefaultAlbumCellAppearance: AlbumCellAppearance {
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

    override func highlightChanged(cell: CollectionCell, value: Bool) {
        if value {
            cell.contentView.backgroundColor = self.selectedColor
        }
        else {
            cell.contentView.backgroundColor = self.highlightedColor
        }
    }

    override func update(cell: CollectionCell, viewModel: CollectionCellModel) {
        cell.imageView.layer.cornerRadius = imageCornerRadius
        cell.contentView.backgroundColor = contentViewColor
        cell.contentView.layer.cornerRadius = contentViewCornerRadius
    }
}
