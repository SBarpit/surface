//
//  Appnetworking+Encryption+Loader.swift
//  ArchievZ
//
//  Created by Nandini on 10/01/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

extension AppNetworking{
    
    //MARK:- encrypParams
    static func encryptParam(params : [String : Any]) ->  [String : Any]{
        Global.print_Debug(params)
        var encryptParams :  [String : Any] =  [:]
        encryptParams = ["token" : self.aesEncrypt(params: params)]
        return encryptParams
    }
    
    static func aesEncrypt(params : Any) -> String {
        func encrypt(params: Any) -> String {
            func JSONStringify(value: Any, prettyPrinted: Bool = false) -> String {
                let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : []
                if JSONSerialization.isValidJSONObject(value) {
                    if let data = try? JSONSerialization.data(withJSONObject: value, options: options) {
                        if let string = String(data: data, encoding: String.Encoding.utf8){
                            return string
                        }
                    }
                }
                return ""
            }
            let dataString = JSONStringify(value: params).aesEncrypt!
            return dataString
        }
        return encrypt(params: params)
    }
}

//MARK:- Loader
var appLoader = __Loader(frame : CGRect(x: 0, y: 0, width: 0, height: 0))

class __Loader: UIView {
    
    var activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .ballRotateChase, color: Global.getGradientImage_Color(size: CGSize(width: 50, height: 50)), padding: 0)
    var isLoading = false
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.20)
        
        let innerView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 100))
        self.activityIndicator.center = CGPoint(x:innerView.center.x, y:innerView.center.y)
        innerView.center = self.center
        innerView.addSubview(self.activityIndicator)
        self.addSubview(innerView)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        Global.getMainQueue {
            if self.isLoading { return }
            AppDelegate.shared?.window?.addSubview(self)
            AppDelegate.shared?.window?.bringSubview(toFront: self)
            self.activityIndicator.startAnimating()
            self.isLoading = true
        }
    }
    
    func stop(){
        Global.getMainQueue {
            self.activityIndicator.stopAnimating()
            self.removeFromSuperview()
            self.isLoading = false
        }
    }
}
