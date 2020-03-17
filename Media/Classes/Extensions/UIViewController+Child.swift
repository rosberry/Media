//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func add(child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
    }
}
