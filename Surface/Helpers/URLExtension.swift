//
//  URLExtension.swift
//  BeautyKingdom
//
//  Created by apple on 08/08/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import AVFoundation

extension URL{
    
    func generateThumnail() -> UIImage?{
        
        URLCache.shared.removeAllCachedResponses()
        
        let assetImgGenerate :  AVAssetImageGenerator!
        
        var thumbImage:UIImage?
        
        let ast = AVAsset(url: self)
        
        assetImgGenerate = AVAssetImageGenerator(asset: ast)
        
        assetImgGenerate.appliesPreferredTrackTransform = true
        
        let time : CMTime = CMTimeMakeWithSeconds(1, 60)
        
        if let cgImage = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil) {
            
            thumbImage = UIImage(cgImage: cgImage)
            
            return thumbImage
            
        }
        return nil
    }
    
    func getDataFromUrl() -> Data? {
        
        let dummyThumbNil = UIImageJPEGRepresentation(#imageLiteral(resourceName: "squarePlaceholderLarge"), 0.6)
        
        guard let thumbNil = self.generateThumnail() else{ return dummyThumbNil
       
        }
        
        guard let imgData = UIImageJPEGRepresentation(thumbNil, 0.6) else { return dummyThumbNil}
        
        return imgData
        
    }
    
     var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            return nil
        }
        
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        
        return parameters
    }
}
