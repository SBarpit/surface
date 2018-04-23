//
//  NYAlertContorller.swift
//  Surface
//
//  Created by Nandini Yadav on 15/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation

public class NYAlertContoller{
    
    class var alertInstance : NYAlertContoller {
        struct Static {
            static let inst = NYAlertContoller()
        }
        return Static.inst
    }
    
    
    private func topMostVC() -> UIViewController? {
        var presentVC = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentVC?.presentedViewController
        {
            presentVC = pVC
        }
        if presentVC == nil {
            Global.print_Debug("Alert Controller Error: You don't have any views set. You may be calling in viewdidload. Try viewdidappear.")
        }
        return presentVC
    }
    
    // Show Alert Controller
    public class func showAlertVC(alert:String, msg: String , done:String, cancel:String , success: @escaping (Bool)->Void){
        let alertController = UIAlertController (title: alert, message: msg, preferredStyle: .alert)
        let doneAction = UIAlertAction(title:done, style: .default) { (_) -> Void in
            success(true)
        }
        let cancelAction = UIAlertAction(title: cancel, style: .default) { (_) in
            success(false)
        }
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        alertInstance.topMostVC()?.present(alertController, animated: true, completion: nil);
    }
    
    public class func alert_With_Accept_Action(title: String, message: String, acceptMsg: String, successBlock:  @escaping (Bool)->Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: acceptMsg, style: .default) { (_) -> Void in
            successBlock(true)
        }
        alert.addAction(okAction)
        
        alertInstance.topMostVC()?.present(alert, animated: true, completion: nil)
    }
}
