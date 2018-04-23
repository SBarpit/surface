//
//  AppUserModel.swift
//  Surface
//
//  Created by Nandini on 12/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

enum AppUserModel {
    
    enum Key : String {
        
        case email
        case country_code
        case mobile
        case device_Token
        case username
        case user_id
        case last_name
        case accessToken
        case reciept
        case social_id
        case social_type
        case user_image
        case did_runFirstTime
    }
}

extension AppUserModel {
    
    static func value(forKey key: Key, file : String = #file, line : Int = #line, function : String = #function) -> JSON {
        
        guard let value = UserDefaults.standard.object(forKey: key.rawValue) else {
            
            return JSON.null
            //            fatalError("No Value Found in UserDefaults\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        
        return JSON(value)
    }
    
    static func value<T>(forKey key: Key, fallBackValue : T, file : String = #file, line : Int = #line, function : String = #function) -> JSON {
        
        guard let value = UserDefaults.standard.object(forKey: key.rawValue) else {
            
            print("No Value Found in UserDefaults\nFile : \(file) \nFunction : \(function)")
            return JSON(fallBackValue)
        }
        
        return JSON(value)
    }
    
    static func save(value : Any, forKey key : Key) {
        
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func removeValue(forKey key : Key) {
        
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func removeAllValues() {
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        UserDefaults.standard.synchronize()
        
    }
}

