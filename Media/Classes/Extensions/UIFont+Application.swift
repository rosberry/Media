//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit

extension UIFont {
    
    class func bauhausMediumFont(ofSize size: CGFloat) -> UIFont? {
        if let retval = UIFont(name: "BauhausMedium", size: size) {
            return retval
        }
        else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    class func bauhausDemiFont(ofSize size: CGFloat) -> UIFont? {
        if let retval = UIFont(name: "BauhausDemi", size: size) {
            return retval
        }
        else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    class func clarikaGeoMediumFont(ofSize size: CGFloat) -> UIFont? {
        if let retval = UIFont(name: "ClarikaGeometric-Medium", size: size) {
            return retval
        }
        else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    class func functionProDemiFont(ofSize size: CGFloat) -> UIFont? {
        if let retval = UIFont(name: "FunctionPro-Demi", size: size) {
            return retval
        }
        else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    class func functionProMediumFont(ofSize size: CGFloat) -> UIFont? {
        if let retval = UIFont(name: "FunctionPro-Medium", size: size) {
            return retval
        }
        else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    class func helveticaBoldFont(ofSize size: CGFloat) -> UIFont? {
        if let retval = UIFont(name: "Helvetica-Bold", size: size) {
            return retval
        }
        else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    class func watermarkCounterFont(ofSize size: CGFloat) -> UIFont? {
        if let retval = UIFont(name: "Ayuthaya", size: size) {
            return retval
        }
        else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    class func functionProBookFont(ofSize size: CGFloat) -> UIFont? {
        if let retval = UIFont(name: "FunctionPro-Book", size: size) {
            return retval
        }
        else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    class func functionProBookObliqueFont(ofSize size: CGFloat) -> UIFont? {
        if let retval = UIFont(name: "FunctionPro-BookOblique", size: size) {
            return retval
        }
        else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    class func functionProLightFont(ofSize size: CGFloat) -> UIFont? {
        if let retval = UIFont(name: "FunctionPro-Light", size: size) {
            return retval
        }
        else {
            return UIFont.systemFont(ofSize: size)
        }
    }
  
    class func libreBaskervilleRegularFont(ofSize size: CGFloat) -> UIFont? {
        if let retval = UIFont(name: "LibreBaskerville-Regular", size: size) {
            return retval
        }
        else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    static var navigationTitle: UIFont = functionProMediumFont(ofSize: 16.0)!
    
    static var placeholderTitle: UIFont = functionProMediumFont(ofSize: 20.0)!
    static var placeholderSubtitle: UIFont = functionProMediumFont(ofSize: 16.0)!
    
    static var albumTitle: UIFont = functionProMediumFont(ofSize: 17.0)!
    static var albumSubtitle: UIFont = functionProMediumFont(ofSize: 13.0)!
    
    static var videoDuration: UIFont = functionProMediumFont(ofSize: 10.0)!
    static var mediaSelectionInfo: UIFont = UIFont.systemFont(ofSize: 14.0, weight: .bold)
    
    static var switchItem: UIFont = functionProMediumFont(ofSize: 13.0)!
    static var dropdownTitle: UIFont = functionProMediumFont(ofSize: 13.0)!
    
    static var toolPanelItem: UIFont = functionProMediumFont(ofSize: 12.0)!
    
    static var videoAdjustmentTitle: UIFont = functionProMediumFont(ofSize: 12.0)!
    
    static var socialDurationMarker: UIFont = functionProMediumFont(ofSize: 10.0)!
    
    static var exportAction: UIFont = functionProMediumFont(ofSize: 13.0)!
    
    static var exportStatus: UIFont = clarikaGeoMediumFont(ofSize: 14.0)!
    
    static var effectPackTitle: UIFont = functionProMediumFont(ofSize: 10.0)!
    static var effectTitle: UIFont = functionProDemiFont(ofSize: 8.0)!
    
    static var segmentedPickerItem: UIFont = functionProMediumFont(ofSize: 11.0)!
    
    static var actionButtonTitle: UIFont = functionProMediumFont(ofSize: 13.0)!
    static var recordingDurationTitle: UIFont = functionProMediumFont(ofSize: 13.0)!
    
    static var storePackTitle: UIFont = functionProMediumFont(ofSize: 24.0)!
    static var storePackDescription: UIFont = functionProMediumFont(ofSize: 13.0)!
    
    static var storeDetailsPackTitle: UIFont = functionProMediumFont(ofSize: 25.0)!
    
    static var watermarkToggleOption: UIFont = functionProMediumFont(ofSize: 14.0)!
    static var watermarkPlaceholder: UIFont = functionProMediumFont(ofSize: 17.0)!
    
    static var notificationTitle: UIFont = functionProMediumFont(ofSize: 12.0)!
    static var notificationAction: UIFont = functionProMediumFont(ofSize: 12.0)!
    
    static var subscriptionTitle: UIFont = bauhausDemiFont(ofSize: 42.0)!
    static var subscriptionDescription: UIFont = functionProBookFont(ofSize: 18.0)!
    static var subscriptionPreviewTitle: UIFont = functionProMediumFont(ofSize: 11.0)!
    
    static var subscriptionPriceBold: UIFont = functionProDemiFont(ofSize: 13.0)!
    static var subscriptionPrice: UIFont = functionProBookFont(ofSize: 13.0)!
    static var subscriptionDuration: UIFont = functionProBookFont(ofSize: 13.0)!
    
    static var subscriptionSuccessDescription: UIFont = functionProBookFont(ofSize: 20.0)!
    static var storeAction: UIFont = functionProMediumFont(ofSize: 14.0)!
    static var storeItemType: UIFont = functionProMediumFont(ofSize: 14.0)!

    static var onboardingAction: UIFont = functionProMediumFont(ofSize: 14.0)!
    
    static var unlockDescription: UIFont = functionProMediumFont(ofSize: 20.0)!
    static var unlockAction: UIFont = functionProMediumFont(ofSize: 16.0)!
    
    static var storeOption: UIFont = functionProDemiFont(ofSize: 14.0)!
    static var allPacksTitle: UIFont = functionProMediumFont(ofSize: 28.0)!
    
    static var appReviewPopupTitle: UIFont = functionProMediumFont(ofSize: 16.0)!
    static var appReviewPopupSecondaryAction: UIFont = functionProMediumFont(ofSize: 16.0)!
    static var appReviewPopupPrimaryAction: UIFont = functionProDemiFont(ofSize: 16.0)!
    
    static var musicTrackTitle: UIFont = functionProMediumFont(ofSize: 11.0)!
    static var audioControlToggle: UIFont = functionProDemiFont(ofSize: 12.0)!
    
    static var audioPickerPrimary: UIFont = functionProMediumFont(ofSize: 18.0)!
    static var audioPickerTitle: UIFont = functionProMediumFont(ofSize: 16.0)!
    static var audioPickerSecondary: UIFont = functionProMediumFont(ofSize: 14.0)!
    static var audioPickerSearch: UIFont = functionProMediumFont(ofSize: 17.0)!
    static var audioPickerSearchIndex: UIFont = clarikaGeoMediumFont(ofSize: 10.0)!
}
