//
//  AppFonts.swift
//  Surface
//
//  Created by Nandini on 12/01/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import UIKit

enum AppFonts : String {
    case regular       = "Poppins-Regular"
    case bold          = "Poppins-Bold"
    case semibold      = "Poppins-SemiBold"
    case medium        = "Poppins-Medium"
    case light         = "Poppins-Light"
}

extension AppFonts {
    
    func withSize(_ fontSize: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    func withDefaultSize() -> UIFont {
        return UIFont(name: self.rawValue, size: 12.0) ?? UIFont.systemFont(ofSize: 12.0)
    }
}
