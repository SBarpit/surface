//
//  EditProfileController.swift
//  Surface
//
//  Created by Arvind Rawat on 03/04/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation


protocol EditProfileDelegates : class{
    
    func userEnterIncorrect(_ text : String)
    func userDidFailSignUp(_ error : Error?)
    func showSucessMessage(msg:String)
    func showErrorMessage(msg:String)
    func userDidEnterValidEmailPassword()
    func userVerifiedSuccesFully(msg:String)
    func userNotVerified(msg:String)
}
class EditProfileController{
    
    weak var delegate : EditProfileDelegates?
    
    var userInfo         = UserInfoModel()
    var inputDataDict    = [[String]]()
    var userInfoDict     = [[String]]()
    var profileImage:UIImage?
    
    func configureInputDict() {
      
        inputDataDict = [
            ["PlaceHolder"],
            ["DisplayName","UserName","Bio","Work","BirthDate","Gender"],
            ["Location"],
            ["Link"],
            ["Email","Phone"]
        ]
        
        userInfoDict = [
            [userInfo.user_name],
            [userInfo.user_name,userInfo.user_name,userInfo.bio,userInfo.company,userInfo.dob, userInfo.gender],
            [userInfo.location],
            [userInfo.link],
            [userInfo.email,userInfo.mobile]
        ]
    }
}
