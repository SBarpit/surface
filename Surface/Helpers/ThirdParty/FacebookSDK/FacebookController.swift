//
//  FacebookController.swift
//  FacebookLogin
//
//  Created by Mohammad Umar Khan on 10/08/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import FBSDKLoginKit
import UIKit

class FacebookController {
    
    //MARK: Variable and properties...
    var success : ((_ msg : model) -> ())!
    
    //MARK: Method to call the facebook login function...
    //MARK: ===========================================
    static func facebookLogin(viewController: UIViewController,
                              success : @escaping (_ msg : model) -> (),
                              failure : @escaping (Error) -> Void) {
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        loginManager.loginBehavior = FBSDKLoginBehavior.native
        loginManager.logIn(withReadPermissions: ["email"],
                           from: viewController,
                           handler: {(result, error) in
                            
                            if error != nil {
                                failure(error!)
                            }
                            else {
                                FBSDKGraphRequest(graphPath: "me",
                                                  parameters: ["fields": "picture.type(large), email, name, id, gender"]).start(completionHandler: {(connection,
                                                    result, error) -> Void in
                                                    
                                                    if error != nil{
                                                        failure(error!)
                                                        print(error ?? "No error")
                                                        
                                                    }else{
                                                        let modelData = model(userDetails: result as! Dictionary<String, Any>)
                                                        success(modelData)
                                                    }
                                                  })
                                
                            
                            }
                            
                   })
        
    }//End of method here...
}

//MARK: Model class to store the user details...
//MARK: ===========================================
class model {
    var name: String?
    var email: String?
    var gender: String?
    var imageUrl: URL?
    var fbId: String?
    
    /* To get the details; use as...
     
     details["name"] for name
     details["email"] for Email
     details["gender"] for Gender
     details["picture"] for Profile picture
     details["id"] for Facebook id
     etc.
     */
    init(userDetails details : Dictionary<String, Any>) {
        
        self.name = details["name"] as? String ?? ""
        
        self.email = details["email"] as? String ?? ""
        
        self.gender = details["gender"] as? String ?? ""
        
        self.fbId =  details["id"] as? String ?? ""
        
        guard let picData = details["picture"] as? NSDictionary else {return}
        let pic = picData["data"] as! NSDictionary
        let url = URL(string: pic["url"]! as! String)
        self.imageUrl = url
    }
}
