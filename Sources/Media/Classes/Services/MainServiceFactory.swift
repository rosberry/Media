//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Foundation
import MediaService

typealias ServicesAlias = HasMediaLibraryService

var Services: MainServicesFactory = { // swiftlint:disable:this variable_name
    return MainServicesFactory()
}()

final class MainServicesFactory: ServicesAlias {

    lazy var mediaLibraryService: MediaLibraryService = MediaLibraryServiceImp()
}
