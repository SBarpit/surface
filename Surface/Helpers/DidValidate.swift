//
//  DidValidate.swift
//  ArchiveZ
//
//  Created by Nandini on 12/01/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import  UIKit

class DidValidate {
    
    // check Email Address is valid or not
    class func isValidEmail(email : String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    // check is field blank?
    class func isBlank(txt: String?) -> Bool {
        guard let name = txt else { return true}
        return (name.condensedWhitespace.length == 0) || (name == "0")
    }
    
    // validate password
    class func isInvalidPwd(txt : String?) -> Bool{
        guard let name = txt else{ return true}
        return name.condensedWhitespace.length < 6
    }
    
    // validate password
    class func isInvalidUsername(txt : String?) -> Bool{
        guard let name = txt else{ return true}
        return name.condensedWhitespace.length < 3
    }
    
    // validate phone number
    class func isInValidPhoneNum(txt : String?) -> Bool{
        guard let name = txt else{ return true}
        return name.condensedWhitespace.length < 7
    }
}
