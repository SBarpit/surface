//
//  AlamofireReachability.swift
//  BeautyKingdom
//
//  Created by apple on 25/07/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import Alamofire


class AlamofireReachability{

    let reachable = NetworkReachabilityManager()

    class var sharedInstance : AlamofireReachability{
        
        struct Static {
            
            static let instance : AlamofireReachability = AlamofireReachability()
        }
        return Static.instance
    }

    
    func isNetworkConnected() -> Bool{
        if (self.reachable?.isReachable)!{
            return true
        }else{
            return false
        }
     //return self.reachable!.networkReachabilityStatus
    }
    
    func isWifiNetworkConnected() -> Bool{
        if (self.reachable?.isReachableOnEthernetOrWiFi)!{
            return true
        }else{
            return false
        }
      // return self.reachable!.isReachableOnEthernetOrWiFi
    }
    
     func configureAlamofireTimeInterval() {
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 10 // in seconds
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForResource = 10 // in seconds
    }
    
}


