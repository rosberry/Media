//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import AVFoundation

extension AVPlayerLayer {
    
    func waitForReadyState(on queue: DispatchQueue = .global(qos: .background), completion: @escaping () -> Void) {
        guard isReadyForDisplay == false else {
            completion()
            return
        }
        
        let tick: UInt32 = 1000
        let timeout: UInt32 = 100000
        var waitingTime: UInt32 = 0
        queue.async {
            while self.isReadyForDisplay == false {
                usleep(tick) // per Apple docs, `isReadyForDisplay` should be key-value observable, but it's not. Whoops
                waitingTime += tick
                
                if waitingTime >= timeout {
                    break
                }
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
