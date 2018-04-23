//
//  UIViewExtension.swift
//  Menu Fitness
//
//  Created by Nandini Yadav on 5/17/17.
//  Copyright © 2017 AppInventiv. All rights reserved.
//

import Foundation
import UIKit

//MARK:-  UIView
extension UIView {
    
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        } set(value) {
            self.frame = CGRect(x: value, y: self.y, width: self.w, height: self.h)
        }
    }
    
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        } set(value) {
            self.frame = CGRect(x: self.x, y: value, width: self.w, height: self.h)
        }
    }
    
    public var w: CGFloat {
        get {
            return self.frame.size.width
        } set(value) {
            self.frame = CGRect(x: self.x, y: self.y, width: value, height: self.h)
        }
    }
    
    public var h: CGFloat {
        get {
            return self.frame.size.height
        } set(value) {
            self.frame = CGRect(x: self.x, y: self.y, width: self.w, height: value)
        }
    }
    
    public var left: CGFloat {
        get {
            return self.x
        } set(value) {
            self.x = value
        }
    }
    
    public var right: CGFloat {
        get {
            return self.x + self.w
        } set(value) {
            self.x = value - self.w
        }
    }
    
    public var top: CGFloat {
        get {
            return self.y
        } set(value) {
            self.y = value
        }
    }
    
    public var bottom: CGFloat {
        get {
            return self.y + self.h
        } set(value) {
            self.y = value - self.h
        }
    }
    
    public var origin: CGPoint {
        get {
            return self.frame.origin
        } set(value) {
            self.frame = CGRect(origin: value, size: self.frame.size)
        }
    }
    
    public var centerX: CGFloat {
        get {
            return self.center.x
        } set(value) {
            self.center.x = value
        }
    }
    
    public var centerY: CGFloat {
        get {
            return self.center.y
        } set(value) {
            self.center.y = value
        }
    }
    
    public var size: CGSize {
        get {
            return self.frame.size
        } set(value) {
            self.frame = CGRect(origin: self.frame.origin, size: value)
        }
    }
    
    //MARK:- set round corners
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func cornerRadius(radius : CGFloat){
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    //MARK:- Get Cell And IndexPath of TableView / CollectionView
    func tableViewCell() -> UITableViewCell? {
        
        var tableViewcell : UIView? = self
        
        while(tableViewcell != nil) {
            if let cell = tableViewcell as? UITableViewCell {
                return cell
            }
            tableViewcell = tableViewcell!.superview
        }
        return nil
    }
    
    func tableViewIndexPath(tableView: UITableView) -> IndexPath? {
        
        if let cell = self.tableViewCell() {
            return tableView.indexPath(for: cell)
        }
        return nil
    }
    
    func collectionViewCell() -> UICollectionViewCell? {
        
        var collectionViewcell : UIView? = self
        
        while(collectionViewcell != nil) {
            
            if collectionViewcell! is UICollectionViewCell {
                break
            }
            collectionViewcell = collectionViewcell!.superview
        }
        return collectionViewcell as? UICollectionViewCell
    }
    
    func collectionViewIndexPath(collectionView: UICollectionView) -> IndexPath? {
        if let cell = self.collectionViewCell() {
            return collectionView.indexPath(for: cell)
        }
        return nil
    }

}

// MARK:- UIViewController
extension UIViewController{
    
    // Show Alert Controller
    func showAlert(alert:String, msg: String , done:String, cancel:String , success: @escaping (Bool)->Void){
        let alertController = UIAlertController (title: alert, message: msg, preferredStyle: .alert)
        let doneAction = UIAlertAction(title:done, style: .default) { (_) -> Void in
            success(true)
        }
        let cancelAction = UIAlertAction(title: cancel, style: .destructive) { (_) in
            success(false)
        }
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil);
    }
    
    // show Alert With Ok Button
    func alert_With_Ok_Action(alertTitle:String = "" , msg: String , done:String, success: @escaping (Bool)->Void){
        let alertController = UIAlertController (title: alertTitle, message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: done, style: .default) { (_) -> Void in
             success(true)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension Int {
    func degreesToRads() -> Double {
        return (Double(self) * .pi / 180)
    }
}
