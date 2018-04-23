//
//  Gradient_ImageColor.swift
//  Surface
//
//  Created by Nandini on 07/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import UIKit

extension Global{
    class func getGradientImage_Color(size:CGSize) -> UIColor?{
        
        var startColorRed:CGFloat = 0
        var startColorGreen:CGFloat = 0
        var startColorBlue:CGFloat = 0
        var startAlpha:CGFloat = 0
        
        if !#colorLiteral(red: 0.1647058824, green: 0.2509803922, blue: 0.4470588235, alpha: 1).getRed(&startColorRed, green: &startColorGreen, blue: &startColorBlue, alpha: &startAlpha) {
            return nil
        }
        
        var middleColorRed:CGFloat = 0
        var middleColorGreen:CGFloat = 0
        var middleColorBlue:CGFloat = 0
        var middleAlpha:CGFloat = 0
        
        if !#colorLiteral(red: 0.8705882353, green: 0.231372549, blue: 0.4666666667, alpha: 1).getRed(&middleColorRed, green: &middleColorGreen, blue: &middleColorBlue, alpha: &middleAlpha) {
            return nil
        }
        
        var endColorRed:CGFloat = 0
        var endColorGreen:CGFloat = 0
        var endColorBlue:CGFloat = 0
        var endAlpha:CGFloat = 0
        
        if !#colorLiteral(red: 0.937254902, green: 0.6078431373, blue: 0.337254902, alpha: 1).getRed(&endColorRed, green: &endColorGreen, blue: &endColorBlue, alpha: &endAlpha) {
            return nil
        }
        
        UIGraphicsBeginImageContext(CGSize(width: size.width, height: size.height))
        
        guard let context = UIGraphicsGetCurrentContext() else {
            Global.print_Debug("Graphics is not current context")
            UIGraphicsEndImageContext()
            return nil
        }
        
        UIGraphicsPushContext(context)
        
        let glossGradient:CGGradient?
        let rgbColorspace:CGColorSpace?
        let num_locations:size_t = 3
        let locations:[CGFloat] = [ 0.0, 0.5, 1.0 ]
        
        let components:[CGFloat] = [startColorRed, startColorGreen, startColorBlue, startAlpha, middleColorRed, middleColorGreen, middleColorBlue, middleAlpha, endColorRed, endColorGreen, endColorBlue, endAlpha]
      
        rgbColorspace = CGColorSpaceCreateDeviceRGB()
      
        glossGradient = CGGradient(colorSpace: rgbColorspace!, colorComponents: components, locations: locations, count: num_locations)
        
        let startCenter = CGPoint.zero
        
        let endCenter = CGPoint(x: size.width, y: 0.0)
        
        context.drawLinearGradient(glossGradient!, start: startCenter, end: endCenter, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
        
        UIGraphicsPopContext()
        
        guard let gradientImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        
        UIGraphicsEndImageContext()
        return UIColor(patternImage: gradientImage)
    }
    
}


