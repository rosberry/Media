//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var isVisible: Bool {
        return isViewLoaded && view.window != nil
    }
    
    func add(child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
    }
}
