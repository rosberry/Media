//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit

extension CATransaction {

    static func execute(_ handler: () -> Void) {
        execute(handler, completion: nil)
    }

    static func execute(_ handler: () -> Void, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        handler()
        CATransaction.commit()
    }
}
