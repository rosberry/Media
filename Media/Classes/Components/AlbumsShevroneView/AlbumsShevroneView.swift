//
//  Copyright © 2022 Rosberry. All rights reserved.
//

import Foundation

final class AlbumsShevroneView: TitleImageView {

    enum ShevronePosition {
        // swiftlint:disable:next  identifier_name
        case up
        case down
    }

    private var state: ShevronePosition = .down

    func update(shevronePosition: ShevronePosition) {
        guard state != shevronePosition else {
            return
        }
        let transform: CGAffineTransform
        switch shevronePosition {
        case .up:
            transform = .init(rotationAngle: CGFloat.pi)
        case .down:
            transform = .identity
        }
        state = shevronePosition
        UIView.animate(withDuration: 0.1) {
            self.imageView.transform = transform
        }
    }

    convenience init() {
        self.init(frame: .zero)
        imageView.image = Asset.icShevroneDown24.image.withRenderingMode(.alwaysOriginal)
        innerInset = 6
    }
}
