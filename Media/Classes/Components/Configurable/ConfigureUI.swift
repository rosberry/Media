//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Foundation

public struct ConfigureUI {
    public var library: ConfigureView
    public var albums: ConfigureView
    public var list: ConfigureView

    public init(library: ConfigureView = .init(), albums: ConfigureView = .init(), list: ConfigureView = .init()) {
        self.library = library
        self.albums = albums
        self.list = list
    }
}
