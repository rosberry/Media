//
//  Copyright © 2017 Rosberry. All rights reserved.
//

import UIKit

extension CGImage {
    
    var size: CGSize {
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
    
    func createPixelBuffer(from pixelBufferPool: CVPixelBufferPool,
                           canvasSize: CGSize,
                           isTransposed: Bool = false) -> CVPixelBuffer? {
        var buffer: CVPixelBuffer?
        CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pixelBufferPool, &buffer)
        
        guard let pixelBuffer = buffer else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        guard let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer) else {
            return nil
        }
        
        let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        guard let context = CGContext(data: pixelData,
                                      width: Int(canvasSize.width),
                                      height: Int(canvasSize.height),
                                      bitsPerComponent: 8,
                                      bytesPerRow: 4 * Int(canvasSize.width),
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: bitmapInfo) else {
                                        return nil
        }
        
        let transform: CGAffineTransform = isTransposed ? .init(rotationAngle: .pi / 2.0) : .identity
        let size = abs(canvasSize.applying(transform))
        let aspect = CGFloat(width) / CGFloat(height)
        let rect = CGRect(fitting: CGRect(origin: .zero, size: size), aspect: aspect)
        
        context.setAllowsAntialiasing(true)
        context.setShouldAntialias(true)
        context.interpolationQuality = .high
        context.clear(rect)
        
        if isTransposed {
            context.translateBy(x: canvasSize.width / 2.0, y: canvasSize.height / 2.0)
            context.concatenate(transform)
            context.translateBy(x: -canvasSize.height / 2.0, y: -canvasSize.width / 2.0)
        }
        
        context.draw(self, in: rect)
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}
