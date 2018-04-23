//
//  Extensions.swift
//  Menu Fitness
//
//  Created by Nandini Yadav on 5/23/17.
//  Copyright © 2017 AppInventiv. All rights reserved.
//

import Foundation
import UIKit

extension Array where Element: Equatable {
    /// MARK:- Removes the first given object
    public mutating func removeFirst(_ element: Element) {
        guard let index = self.index(of: element) else { return }
        self.remove(at: index)
    }
}

// MARK:- Highlight button
class highlighted : UIButton{
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? AppColors.appTheme : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
}

extension UITextField {
    /// EZSE: Add left side padding of the textfield
    public func add_LeftPadding(paddingSize: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: paddingSize, height: self.h))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    public func add_RightPadding(paddingSize: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: self.w - 2 - paddingSize, y: 0, width: paddingSize, height: self.h))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    /// EZSE: Add a image icon on the Right side of the textfield
    public func addRightIcon(_ image: UIImage?, imageSize: CGSize , leftPaddingWidht: CGFloat = 0) {
        
        let rightView = UIView()
        let frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        rightView.frame = frame
        let imgView = UIImageView()
        imgView.frame = CGRect(x: frame.width - 2 - imageSize.width, y: (frame.height - imageSize.height) / 2, width: imageSize.width, height: imageSize.height)
        imgView.contentMode = .center
        imgView.image = image
        rightView.addSubview(imgView)
        self.rightView = rightView
        self.rightViewMode = UITextFieldViewMode.always
        self.layoutIfNeeded()
    }
    
    public func addRightBtn() {
        let rightView = UIButton()
        
        let frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        rightView.frame = frame
        rightView.layer.borderColor = Global.getGradientImage_Color(size: rightView.size)?.cgColor
       let textSize = Global.textSizeCount("Change", font:AppFonts.bold.withSize(10), bundingSize: CGSize(width: 60, height: 1000))
        //rightView.setTitle("Change", for: .normal)
        rightView.setTitleColor(Global.getGradientImage_Color(size: textSize), for: .normal)
  //      rightView.backgroundColor = UIColor.red
        rightView.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        self.rightView = rightView
        self.rightViewMode = UITextFieldViewMode.always
        self.layoutIfNeeded()
        
        
    }
    
    @objc func btnTapped(){
        
        
        
    }
    
}


extension Date {
    fileprivate func dateComponents() -> DateComponents {
        let calander = Calendar.current
        return (calander as NSCalendar).components([.second, .minute, .hour, .day, .month, .year], from: self, to: Date(), options: [])
    }
    public var timeAgo: String {
        let components = self.dateComponents()
        
        if components.year! > 0 {
            return  "\(components.year ?? 0) Year ago"
        }
        
        if components.month! > 0 {
            return "\(components.month ?? 0) Month ago"
        }
        
        if components.day! >= 7 {
            let week = components.day!/7
            return "\(week) Week ago"
        }
        
        if components.day! > 0 {
            return "\(components.day ?? 0) day ago"
        }
        
        if components.hour! > 0 {
            return "\(components.hour ?? 0) hour ago"
        }
        
        if components.minute! > 0 {
            return "\(components.minute ?? 0) min ago"
        }
        if components.second! > 10 {
            return "\(components.second ?? 0) sec ago"
        }
        if components.second! < 10 {
            return "Just now"
        }
        return ""
    }
}

extension Global{
    //MARK:- Convert String into Date
    class func convertStringIntoDate(format : String , date : String?, timeZone:TimeZone? = .current)->Date?{
        guard let time = date else { return nil}
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        // convert into utc format date
        dateFormatter.dateFormat = format
        guard let localDate  = dateFormatter.date(from: time) else {return nil}
        return localDate
    }
    
    
    
}

extension UIView{
    
    func addBorder(withColor color:UIColor, andWidth borderWidth:CGFloat){
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
    }
    
    func addShadow(_ radius : CGFloat){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = CGSize(width : 1.0, height : 1.0)
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds    = false
        self.layer.shadowColor      = color.cgColor
        self.layer.shadowOpacity    = opacity
        self.layer.shadowOffset     = offSet
        self.layer.shadowRadius     = radius
        self.layer.shadowPath       = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize  = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func cornerBorder(color:UIColor,radius:CGFloat) {
        
        self.backgroundColor = .clear
        self.layer.cornerRadius = radius
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
        
        
    }
}


