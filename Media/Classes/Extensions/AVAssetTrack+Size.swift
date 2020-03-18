//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import AVFoundation

func abs(_ size: CGSize) -> CGSize {
    return CGSize(width: abs(size.width), height: abs(size.height))
}

extension AVAssetTrack {

    var presentationSize: CGSize {
        return abs(naturalSize.applying(preferredTransform))
    }
}
