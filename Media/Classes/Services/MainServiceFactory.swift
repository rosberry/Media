//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Foundation

typealias ServicesAlias = HasMediaLibraryService

var Services: MainServicesFactory = { // swiftlint:disable:this variable_name
    return MainServicesFactory()
}()

final class MainServicesFactory {
    
    class Scope: ServicesAlias {
        
        private var _parent: Scope?
        private var parent: Scope {
            return _parent ?? self
        }
        
        init(parent: Scope? = nil) {
            _parent = parent
        }
        
        deinit {
            //
        }
        
        lazy var mediaLibraryService: MediaLibraryServiceProtocol = {
            if let parent = _parent {
                return parent.mediaLibraryService
            }
            
            return MediaLibraryService()
        }()
    }
    
    // MARK: - Scopes
    
    lazy var sharedScope = Scope()
    
    private weak var _cameraScope: Scope?
    var cameraScope: Scope {
        if let scope = _cameraScope {
            return scope
        }
        
        let scope = newScope(parent: self.sharedScope)
        _cameraScope = scope
        return scope
    }
    
    private weak var _workspaceScope: Scope?
    var workspaceScope: Scope {
        if let scope = _workspaceScope {
            return scope
        }
        
        let scope = newScope(parent: self.sharedScope)
        _workspaceScope = scope
        return scope
    }
    
    private weak var _projectExportScope: Scope?
    var projectExportScope: Scope {
        if let scope = _projectExportScope {
            return scope
        }
        
        let scope = newScope(parent: self.sharedScope)
        _projectExportScope = scope
        return scope
    }
    
    // MARK: - Helpers
    
    func newScope(parent: Scope? = nil) -> Scope {
        return Scope(parent: parent ?? sharedScope)
    }
}
