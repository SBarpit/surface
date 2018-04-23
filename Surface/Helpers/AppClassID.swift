//
//  AppClassID.swift
//  Surface
//
//  Created by Nandini on 15/01/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import  UIKit

enum AppClassID: String {
    case ID = "ID"

    // Signup Screen
     case phoneNumCell           = "PhoneNumCell"
     case textFieldCell          = "TextFieldCell"
     case termsAndConditionsCell = "TermsAndConditionsCell"
     case signupButtonCell       = "SignupButtonCell"
     case loginButtonCell        = "LoginButtonCell"
     case appLogoCell            = "AppLogoCell"
     case CountryCodeCell        = "CountryCodeCell"
     case feedCell               = "FeedCell"
     case featuredCell           = "FeaturedCell"
     case GalleryCell            = "GalleryCell"
     case FilterCell             = "FilterCell"
     case VideoFiltersCollectionCell    = "VideoFiltersCollectionCell"
    case AccountManagementCell  = "AccountManagementCell"
    
    var cellID : String {
        switch self {
        case .ID:
            return self.rawValue
        default:
            return self.rawValue.appending(AppClassID.ID.rawValue)
        }
    }
}
