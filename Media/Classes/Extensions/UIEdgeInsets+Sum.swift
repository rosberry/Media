//
//  Copyright © 2019 Rosberry. All rights reserved.
//
import UIKit

extension UIEdgeInsets: AdditiveArithmetic {

    public var horizontalSum: CGFloat {
        left + right
    }

    public var verticalSum: CGFloat {
        top + bottom
    }

    /// Initialize edge insets with one value for all dimensions.
    ///
    /// - Parameter inset: The inset for all dimensions.
    public init(inset: CGFloat) {
        self.init(top: inset, left: inset, bottom: inset, right: inset)
    }

    public static func + (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: lhs.top + rhs.top,
                            left: lhs.left + rhs.left,
                            bottom: lhs.bottom + rhs.bottom,
                            right: lhs.right + rhs.right)
    }

    public static func - (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: lhs.top - rhs.top,
                            left: lhs.left - rhs.left,
                            bottom: lhs.bottom - rhs.bottom,
                            right: lhs.right - rhs.right)
    }

    public static prefix func - (_ insets: Self) -> Self {
        return UIEdgeInsets.zero - insets
    }

}

extension UIEdgeInsets: ExpressibleByIntegerLiteral {

    public init(integerLiteral value: IntegerLiteralType) {
        self.init(inset: CGFloat(value))
    }
}

extension UIEdgeInsets: ExpressibleByFloatLiteral {

    public init(floatLiteral value: FloatLiteralType) {
        self.init(inset: CGFloat(value))
    }
}
