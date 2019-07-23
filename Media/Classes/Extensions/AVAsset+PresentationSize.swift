//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import AVFoundation

extension AVAsset {
    
    var presentationSize: CGSize? {
        guard let track = tracks(withMediaType: .video).first else {
            return nil
        }
        
        return track.presentationSize
    }
}
