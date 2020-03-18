//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import Photos

public final class MediaItem: Codable {

    static let dummy: MediaItem = .init(identifier: L10n.dummy, type: .unknown)

    private enum CodingKeys: String, CodingKey {
        case identifier
    }

    public enum SourceType: CustomStringConvertible {
        case unknown
        case photo
        case video(TimeInterval)
        case sloMoVideo(TimeInterval)
        case livePhoto

        public var description: String {
            switch self {
                case .unknown:
                    return "unknown"
                case .photo:
                    return "photo"
                case .video:
                    return "video"
                case .sloMoVideo:
                    return "slo-mo"
                case .livePhoto:
                    return "live photo"
            }
        }

        public var isVideo: Bool {
            switch self {
                case .video, .sloMoVideo:
                    return true
                default:
                    return false
            }
        }

        public var isLivePhoto: Bool {
            switch self {
                case .livePhoto:
                    return true
                default:
                    return false
            }
        }

        public var isSloMoVideo: Bool {
            switch self {
                case .sloMoVideo:
                    return true
                default:
                    return false
            }
        }

        public var isStatic: Bool {
            switch self {
                case .photo:
                    return true
                default:
                    return false
            }
        }
    }

    public var asset: PHAsset?
    public var identifier: String
    public var thumbnail: UIImage?

    public var type: SourceType = .unknown
    public var date: Date?

    public var duration: TimeInterval? {
        switch type {
            case .unknown, .photo, .livePhoto:
                return nil
            case .video(let duration):
                return duration
            case .sloMoVideo(let duration):
                return duration
        }
    }

    public init(identifier: String, type: SourceType) {
        self.identifier = identifier
        self.type = type
    }

    // MARK: - Codable

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(String.self, forKey: .identifier)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
    }
}

extension MediaItem {

    public convenience init(asset: PHAsset) {
        let identifier = asset.localIdentifier
        let type: SourceType
        switch asset.mediaType {
            case .image:
                if asset.mediaSubtypes.contains(.photoLive) {
                    type = .livePhoto
                }
                else {
                    type = .photo
                }
            case .video:
                if asset.mediaSubtypes.contains(.videoHighFrameRate) {
                    type = .sloMoVideo(asset.duration)
                }
                else {
                    type = .video(asset.duration)
                }
            default:
                type = .unknown
        }

        self.init(identifier: identifier, type: type)
        self.asset = asset
        self.date = asset.creationDate
    }
}

extension MediaItem: CustomStringConvertible {

    public var description: String {
        return "\(identifier): \(type)"
    }
}

extension MediaItem: Equatable {

    public static func == (lhs: MediaItem, rhs: MediaItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
