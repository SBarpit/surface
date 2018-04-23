//
//  AppColors.swift
//  Surface
//
//  Created by Nandini on 11/01/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation

import UIKit

class AppColors: UIColor{
    static var appTheme              = #colorLiteral(red: 0.5058823529, green: 0.768627451, blue: 0.1137254902, alpha: 1)
    static var appBorderLineGray     = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
    static var appBlack              = #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 1)
    static var appTextGray           = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
    static var appTextFieldGray      = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
    static var appPlaceholderColor   = #colorLiteral(red: 0.6784313725, green: 0.6784313725, blue: 0.6784313725, alpha: 1)
    static var separatorLineGray     = #colorLiteral(red: 0.8196078431, green: 0.8196078431, blue: 0.8196078431, alpha: 1)
    static let progressViewColor     = #colorLiteral(red: 1, green: 0, blue: 0.4552601329, alpha: 1)
    static let postingProgressViewColor    = #colorLiteral(red: 0.7452511942, green: 0, blue: 1, alpha: 1)
    static let profileBtnColor       = #colorLiteral(red: 0.368627451, green: 0.5960784314, blue: 0.8823529412, alpha: 1)

}

extension UIColor{
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}
