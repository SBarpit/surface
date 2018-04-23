//
//  AppNetworking.swift
//  ArchievZ
//
//  Created by Appinventiv on 10/01/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

typealias JSONDictionary = [String : Any]
typealias JSONDictionaryArray = [JSONDictionary]
typealias SuccessResponse = (_ json : JSON) -> ()
typealias FailureResponse = ( _ errorMessage: String, _ errorCode: Int?) -> Void

extension Notification.Name {
    
    static let NotConnectedToInternet = Notification.Name("NotConnectedToInternet")
}

enum AppNetworking {
    
    static func POST(endPoint : WebServices.EndPoint.RawValue,
                     parameters : JSONDictionary = [:],
                     headers : HTTPHeaders = [:],
                     loader : Bool = true,
                     success : @escaping (JSON) -> Void,
                     failure : @escaping (Error) -> Void) {
        
        request(URLString: endPoint, httpMethod: .post, parameters: parameters, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    static func POSTWithImage(endPoint : WebServices.EndPoint.RawValue,
                              parameters : [String : Any] = [:],
                              image : [String:UIImage]? = [:],
                              headers : HTTPHeaders = [:],
                              loader : Bool = true,
                              progress : @escaping (Double) -> Void,
                              success : @escaping (JSON) -> Void,
                              failure : @escaping (Error) -> Void){
        
        upload(URLString: endPoint, httpMethod: .post, parameters: parameters,image: image ,headers: headers, loader: loader, progress: progress, success: success, failure: failure )
    }
    
    static func GET(endPoint : WebServices.EndPoint.RawValue,
                    parameters : JSONDictionary = [:],
                    headers : HTTPHeaders = [:],
                    loader : Bool = true,
                    success : @escaping (JSON) -> Void,
                    failure : @escaping (Error) -> Void) {
        
        request(URLString: endPoint, httpMethod: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    static func PUT(endPoint : WebServices.EndPoint.RawValue,
                    parameters : JSONDictionary = [:],
                    headers : HTTPHeaders = [:],
                    loader : Bool = true,
                    success : @escaping (JSON) -> Void,
                    failure : @escaping (Error) -> Void) {
        
        request(URLString: endPoint, httpMethod: .put, parameters: parameters, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    static func DELETE(endPoint : WebServices.EndPoint.RawValue,
                       parameters : JSONDictionary = [:],
                       headers : HTTPHeaders = [:],
                       loader : Bool = true,
                       success : @escaping (JSON) -> Void,
                       failure : @escaping (Error) -> Void) {
        
        request(URLString: endPoint, httpMethod: .delete, parameters: parameters, encoding: URLEncoding.queryString, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    
    private static func request(URLString : String,
                                httpMethod : HTTPMethod,
                                parameters : JSONDictionary = [:],
                                encoding: URLEncoding = .default,
                                headers : HTTPHeaders = [:],
                                loader : Bool = true,
                                success : @escaping (JSON) -> Void,
                                failure : @escaping (Error) -> Void) {
        
        if loader { appLoader.start() }
        
        Global.print_Debug(headers)
        Global.print_Debug(URLString)
        Global.print_Debug(parameters)
        
        // Encrypt Data
        //let encryptParams = self.encryptParam(params: parameters)
        
       // Global.print_Debug(encryptParams)
        
        Alamofire.request(URLString, method: httpMethod, parameters: parameters, encoding: encoding, headers: headers).responseString(completionHandler: { (response : DataResponse<String>) in
            
            if loader { appLoader.stop() }
            
            switch(response.result) {
                
            case .success(let value):
                Global.print_Debug(value)
                if let dict = Global.convertStringIntoDictionary(value: value){
                    Global.print_Debug(JSON(dict))
                    success(JSON(dict))
                }
//                if let decodedDict = value.aesDecrypt as? [String:Any]{
//                    Global.print_Debug(decodedDict)
//                    Global.print_Debug(JSON(decodedDict))
//                    success(JSON(decodedDict))
//                }
                else{
                    failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
                }
                
            case .failure(let e):
                Global.print_Debug(e)
                if (e as NSError).code == NSURLErrorNotConnectedToInternet {
                    NotificationCenter.default.post(name: .NotConnectedToInternet, object: nil)
                }
                failure(e)
            }
        })
    }
    
    private static func upload(URLString : String,
                               httpMethod : HTTPMethod,
                               parameters : JSONDictionary = [:],
                               image : [String:UIImage]? = [:],
                               headers : HTTPHeaders = [:],
                               loader : Bool = true,
                               progress : @escaping (Double) -> Void,
                               success : @escaping (JSON) -> Void,
                               failure : @escaping (Error) -> Void) {
        
        if loader {appLoader.start()}
        
        Global.print_Debug(headers)
        Global.print_Debug(parameters)
        Global.print_Debug(image)
        Global.print_Debug(URLString)
        
        var newParams = JSONDictionary()
        
        let url = try! URLRequest(url: URLString, method: httpMethod, headers: headers)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let image = image {
                for (key , value) in image{
                    if let img = UIImageJPEGRepresentation(value, 0.6){
                        multipartFormData.append(img, withName: key, fileName: "image.jpg", mimeType: "image/jpg")
                    }
                }
            }
            
            for (key , value) in parameters{
                if let url = value as? URL{
                    multipartFormData.append(url, withName: key, fileName: "movie.mp4", mimeType: "movie/mp4")
                }else if let value = value as? UIImage{
                    if let img = UIImageJPEGRepresentation(value, 0.6){
                        Global.print_Debug(img)
                        multipartFormData.append(img, withName: key, fileName: "image.jpg", mimeType: "image/jpg")
                    }
                }else{
                    newParams[key] = value
                }
            }
            
            //let encryptedParams = self.encryptParam(params: newParams)
            
            for (key , value) in newParams{
                multipartFormData.append((value as AnyObject).data(using : String.Encoding.utf8.rawValue)!, withName: key)
            }
        },
                       with: url, encodingCompletion: { encodingResult in
                        
                        switch encodingResult{
                        case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                            
                            upload.uploadProgress(closure: { (Progress) in
                                progress(Progress.fractionCompleted)
                            })
                            upload.responseString(completionHandler: { (response:DataResponse<String>) in
                                
                                switch response.result{
                                case .success(let value):
                                  if loader { appLoader.stop() }
                                    Global.print_Debug(value)
                                  if let dict = Global.convertStringIntoDictionary(value: value){
                                    Global.print_Debug(JSON(dict))
                                    success(JSON(dict))
                                  }
//                                    if let decodedDict = value.aesDecrypt as? [String : Any]{
//                                        let json = JSON(decodedDict)
//                                        Global.print_Debug(json)
//                                        success(json)
//                                    }
                                  else{
                                        failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
                                    }
                                    
                                case .failure(let e):
                                    if loader { appLoader.stop() }
                                    
                                    if (e as NSError).code == NSURLErrorNotConnectedToInternet {
                                        NotificationCenter.default.post(name: .NotConnectedToInternet, object: nil)
                                    }
                                    failure(e)
                                }
                            })
                            
                        case .failure(let e):
                            if loader { appLoader.stop() }
                            
                            if (e as NSError).code == NSURLErrorNotConnectedToInternet {
                                NotificationCenter.default.post(name: .NotConnectedToInternet, object: nil)
                            }
                            failure(e)
                        }
        })
    }
}

