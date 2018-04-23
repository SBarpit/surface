//
//  APIKeys.swift
//  Surface
//
//  Created by Arvind Rawat on 02/04/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation

enum ApiKeys {
    
    case id
    case accessToken
    
    
    var string : String {
        
        switch self {
            
        case .id:
            return "id"
        case .accessToken:
            return "access-token"
        }
    }
}
