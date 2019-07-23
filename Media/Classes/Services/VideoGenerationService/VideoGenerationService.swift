//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import AVFoundation

public final class VideoGenerationService: VideoGenerationServiceProtocol {

    private let queue = DispatchQueue(label: "video.generation")
    private var maximumVideoOutputHeight: CGFloat = 1080
    private var maximumVideoOutputWidth: CGFloat = 1920

    private var videoCompressionSettings: [String: Any] {
        return [
            AVVideoQualityKey: 1.0
        ]
    }

    private func videoOutputSize(for image: UIImage) -> CGSize {
        let aspect = image.size.width / image.size.height
        let rawOutputHeight = min(maximumVideoOutputHeight, image.size.height * image.scale)
        let rawOutputWidth = Int(min(maximumVideoOutputWidth, min(max(aspect, 1.0 / aspect), 3.0) * rawOutputHeight))
        let videoOutputWidth = CGFloat(rawOutputWidth - (rawOutputWidth % 16))
        return CGSize(width: videoOutputWidth, height: videoOutputWidth / max(aspect, 1.0 / aspect))
    }

    private func videoSettings(size: CGSize) -> [String: Any] {
        return [
            AVVideoCodecKey: AVVideoCodecType.jpeg,
            AVVideoCompressionPropertiesKey: videoCompressionSettings,
            AVVideoWidthKey: Int(size.width),
            AVVideoHeightKey: Int(size.height)
        ]
    }

    private func pixelBufferAttributes(size: CGSize) -> [String: Any] {
        return [
            String(kCVPixelBufferPixelFormatTypeKey): kCVPixelFormatType_32ARGB,
            String(kCVPixelBufferWidthKey): Int(size.width),
            String(kCVPixelBufferHeightKey): Int(size.height)
        ]
    }

    private func setupWriterInput(for image: UIImage, size: CGSize, isTransposed: Bool) -> AVAssetWriterInput {
        let writerInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings(size: size))
        writerInput.expectsMediaDataInRealTime = false
        writerInput.performsMultiPassEncodingIfSupported = false
        writerInput.mediaTimeScale = 30

        if isTransposed {
            writerInput.transform = image.transform.rotated(by: .pi / 2.0)
        }
        else {
            writerInput.transform = image.transform
        }

        return writerInput
    }
    
    public init() {
        
    }

    public func prepareOutputURL(forAssetIdentifier identifier: String) -> URL {
        let url =  URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(identifier.replacingOccurrences(of: "/", with: "_"))
            .appendingPathExtension("mov")
        try? FileManager.default.removeItem(at: url)
        return url
    }

    public func createAVAsset(for image: UIImage, identifier: String, completion: @escaping (AVAsset?) -> Void) {
        let outputURL = prepareOutputURL(forAssetIdentifier: identifier)
        guard let videoWriter = try? AVAssetWriter(url: outputURL, fileType: .mov) else {
            assertionFailure("No writer")
            return completion(nil)
        }
        videoWriter.movieTimeScale = 30

        let outputSize = videoOutputSize(for: image)
        let isTransposed = (image.aspect < 1.0) && (image.transform.b == 0.0)
        let writerInput = setupWriterInput(for: image, size: outputSize, isTransposed: isTransposed)

        guard videoWriter.canAdd(writerInput) else {
            assertionFailure("No input")
            return completion(nil)
        }

        videoWriter.add(writerInput)

        let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: writerInput,
                                                           sourcePixelBufferAttributes: pixelBufferAttributes(size: outputSize))

        guard videoWriter.startWriting() else {
            assertionFailure("No writer session")
            return completion(nil)
        }

        videoWriter.startSession(atSourceTime: CMTime.zero)

        guard let pixelBufferPool = adaptor.pixelBufferPool else {
            assertionFailure("No pixel buffer pool")
            return completion(nil)
        }

        let time: CMTime = .zero
        let step: CMTime = .init(seconds: 2.5, preferredTimescale: 30)
        writerInput.requestMediaDataWhenReady(on: queue) {
            if let pixelBuffer = image.cgImage?.createPixelBuffer(from: pixelBufferPool,
                                                                  canvasSize: outputSize,
                                                                  isTransposed: isTransposed) {
                adaptor.append(pixelBuffer, withPresentationTime: time)
                adaptor.append(pixelBuffer, withPresentationTime: CMTimeAdd(time, step))
            }

            writerInput.markAsFinished()
            videoWriter.finishWriting { [weak videoWriter] in
                guard videoWriter?.error == nil else {
                    return completion(nil)
                }

                completion(AVAsset(url: outputURL))
            }
        }
    }
}
