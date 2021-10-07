//
//  AVPlayer+Stop().swift
//  Media
//
//  Created by Evgeny Schwarzkopf on 07.10.2021.
//  Copyright © 2021 Rosberry. All rights reserved.
//

import AVFoundation

extension AVPlayer {
    public func stop() {
        seek(to: .zero)
        pause()
    }
}
