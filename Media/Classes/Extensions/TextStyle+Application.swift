//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import Texstyle

extension TextStyle {
//
//    static var heading1: TextStyle {
//        let textStyle = TextStyle()
//        textStyle.color = .main1
//        textStyle.font = .helveticaBoldFont(ofSize: 40)!
//        textStyle.kerning = 0.5
//        textStyle.alignment = .center
//        return textStyle
//    }
//
    static var heading4a: TextStyle {
        let textStyle = TextStyle()
        textStyle.color = .main1
        textStyle.font = .functionProMediumFont(ofSize: 20)!
        textStyle.kerning = 1.0
        textStyle.alignment = .center
        return textStyle
    }

    static var heading4b: TextStyle {
        let textStyle = TextStyle.heading4a
        textStyle.color = .additional3
        return textStyle
    }

    static var title2a: TextStyle {
        let textStyle = TextStyle()
        textStyle.color = .main2
        textStyle.font = .functionProDemiFont(ofSize: 15.0)!
        textStyle.kerning = 1.5
        textStyle.alignment = .center
        return textStyle
    }

    static var title3: TextStyle {
        let textStyle = TextStyle()
        textStyle.color = .main1
        textStyle.font = .functionProDemiFont(ofSize: 13.0)!
        textStyle.kerning = 2.0
        textStyle.alignment = .center
        return textStyle
    }
//
//    static var paragraph1: TextStyle {
//        let textStyle = TextStyle()
//        textStyle.color = .main1
//        textStyle.font = .functionProMediumFont(ofSize: 17.0)!
//        textStyle.kerning = 0.5
//        textStyle.alignment = .center
//        return textStyle
//    }
//
    static var paragraph2: TextStyle {
        let textStyle = TextStyle()
        textStyle.color = .main1
        textStyle.font = .functionProMediumFont(ofSize: 15.0)!
        textStyle.kerning = 0.3
        textStyle.alignment = .center
        return textStyle
    }

    static var paragraph2d: TextStyle {
        let textStyle = TextStyle()
        textStyle.color = .additional2
        textStyle.font = .functionProBookFont(ofSize: 15.0)!
        textStyle.kerning = 0.5
        textStyle.lineHeight = 19
        textStyle.alignment = .center
        return textStyle
    }
//
//    static var paragraph3: TextStyle {
//        let textStyle = TextStyle()
//        textStyle.color = .main1
//        textStyle.font = .functionProDemiFont(ofSize: 13.0)!
//        textStyle.kerning = 1.0
//        textStyle.alignment = .center
//        return textStyle
//    }
//
//    static var paragraph3a: TextStyle {
//        let textStyle = paragraph3
//        textStyle.color = .additional4
//        return textStyle
//    }
//
    static var paragraph4: TextStyle {
        let textStyle = TextStyle()
        textStyle.color = .additional2
        textStyle.font = .functionProMediumFont(ofSize: 13.0)!
        textStyle.kerning = 0.5
        textStyle.alignment = .center
        return textStyle
    }

    static var paragraph5: TextStyle {
        let textStyle = TextStyle()
        textStyle.color = .main2
        textStyle.font = .functionProMediumFont(ofSize: 10.0)!
        textStyle.kerning = 0.0
        textStyle.alignment = .center
        return textStyle
    }
//
//    static func textLayerTitle1(alignment: NSTextAlignment = .center) -> TextStyle {
//        let textStyle = TextStyle()
//        textStyle.color = .main1
//        textStyle.font = .functionProBookObliqueFont(ofSize: 14.0)!
//        textStyle.kerning = 0.5
//        textStyle.alignment = alignment
//        textStyle.alignment = .center
//        return textStyle
//    }
//
//    static func textLayerTitle2(alignment: NSTextAlignment = .center) -> TextStyle {
//        let textStyle = TextStyle()
//        textStyle.color = .main1
//        textStyle.font = .functionProBookFont(ofSize: 16.0)!
//        textStyle.kerning = 1.0
//        textStyle.alignment = alignment
//        textStyle.alignment = .center
//        return textStyle
//    }
//
//    static func textLayerBody(alignment: NSTextAlignment = .center) -> TextStyle {
//        let textStyle = TextStyle()
//        textStyle.color = .main1
//        textStyle.font = .libreBaskervilleRegularFont(ofSize: 12.0)!
//        textStyle.kerning = 0.2
//        textStyle.alignment = alignment
//        textStyle.alignment = .center
//        return textStyle
//    }
    
}
