//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import AVFoundation

public protocol HasVideoGenerationService {
    var videoGenerationService: VideoGenerationServiceProtocol { get }
}

public protocol VideoGenerationServiceProtocol: AnyObject {

    func prepareOutputURL(forAssetIdentifier identifier: String) -> URL
    func createAVAsset(for image: UIImage, identifier: String, completion: @escaping (AVAsset?) -> Void)
}
