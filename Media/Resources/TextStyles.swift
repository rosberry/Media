//
//  Copyright © 2022 Rosberry. All rights reserved.
//

import Foundation
import Texstyle

public extension TextStyle {

    static var title2A: TextStyle {
        let style = TextStyle()
        style.font = .systemFont(ofSize: 22, weight: .bold)
        style.color = .main1T
        style.alignment = .center
        return style
    }

    static var body1A: TextStyle {
        let style = TextStyle()
        style.font = .systemFont(ofSize: 17, weight: .regular)
        style.color = .main1T
        style.alignment = .center
        return style
    }

    static var title4B: TextStyle {
        let style = TextStyle()
        style.font = .systemFont(ofSize: 17, weight: .bold)
        style.color = .white
        style.alignment = .center
        return style
    }

    static var title4A: TextStyle {
        let style = TextStyle()
        style.font = .systemFont(ofSize: 17, weight: .bold)
        style.color = .main1T
        style.alignment = .left
        return style
    }

    static var subtitle1B: TextStyle {
        let style = TextStyle()
        style.font = .systemFont(ofSize: 15, weight: .regular)
        style.color = .white
        style.alignment = .center
        return style
    }

    static var subtitle2C: TextStyle {
        let style = TextStyle()
        style.font = .systemFont(ofSize: 17, weight: .regular)
        style.color = .main2T
        style.alignment = .left
        return style
    }

    static var button1D: TextStyle {
        let style = TextStyle()
        style.font = .systemFont(ofSize: 17, weight: .bold)
        style.color = .main1T
        style.alignment = .center
        return style
    }

}
