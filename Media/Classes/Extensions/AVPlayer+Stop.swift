//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import AVFoundation

extension AVPlayer {
    public func stop() {
        seek(to: .zero)
        pause()
    }
}
