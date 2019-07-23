//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import AVFoundation

final class PlayerView: UIView {
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    // swiftlint:disable force_cast
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    // swiftlint:enable force_cast
    
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var isReadyForDisplay: Bool {
        return playerLayer.isReadyForDisplay
    }
    
    init() {
        super.init(frame: .zero)
        playerLayer.videoGravity = .resizeAspect
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func waitForReadyState(on queue: DispatchQueue = .global(qos: .background), completion: @escaping () -> Void) {
        playerLayer.waitForReadyState(on: queue, completion: completion)
    }
}
