//
//  Global.swift
//  Surface
//
//  Created by Nandini Yadav on 5/16/17.
//  Copyright © 2017 AppInventiv. All rights reserved.
//

import Foundation
import UIKit
import CFNetwork
import SystemConfiguration
import Toaster
import Kingfisher
import AVFoundation
import Photos
import AssetsLibrary

//MARK: Print_Debug && simulator
var isIPhoneSimulator:Bool{
    
    var isSimulator = false
    #if arch(i386) || arch(x86_64)
        //simulator
        isSimulator = true
    #endif
    return isSimulator
}


var USER_DEVICE_TOKEN   = "123456789"

class Global{
    
    // MARK:- Main Screen Size
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size

    // Print Functions
   class func print_Debug <T> (_ object: T){
        if isIPhoneSimulator{
           // print(object)
        }else{
           // print(object)
        }
    }
    
    //MARK:- delay with Seconds Method
  class func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    //MARK:- Main Thread
  class func getMainQueue(_ closure:@escaping ()->()){
        DispatchQueue.main.async(execute: {
            closure()
        })
    }
    
    //MARK:- Show Toast Message
    class func showToast(msg: String){
        if msg != ""{
            let appearance = ToastView.appearance()
            appearance.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.8)
            appearance.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            appearance.font = UIFont.systemFont(ofSize: 10.0)
            appearance.textInsets = UIEdgeInsets(top:10, left: 10, bottom: 10, right: 10)
            appearance.bottomOffsetPortrait = 20
            appearance.cornerRadius = 9.0
            Toast(text: msg, delay: 0.5, duration: 2).show()
        }
    }
    
     //MARK:- convert String Into Dictionary
    class func convertStringIntoDictionary(value:String)-> JSONDictionary?{
        var dictonary:JSONDictionary?
        
        if let data = value.data(using: String.Encoding.utf8) {
            do {
                dictonary =  try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            } catch let error{
                Global.print_Debug(error)
            }
        }
        return dictonary
    }
    
    //MARK:- set Root Controller
    class func setRootController(vc: UIViewController) {
        let navController = UINavigationController(rootViewController: vc)
        navController.isNavigationBarHidden = true
        AppDelegate.shared?.window?.rootViewController = navController
        AppDelegate.shared?.window?.makeKeyAndVisible()
    }
    
    //MARK:- remove all Cache
    class func removeChahe(){
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
    }
    
    //MARK:- clear Tmp Directory
    class func clearTempDirectory() {
        let fileManager = FileManager()
        do {
            let tmpDirectory = try fileManager.contentsOfDirectory(atPath: NSTemporaryDirectory())
            try tmpDirectory.forEach {[unowned fileManager] file in
                let path = String.init(format: "%@%@", NSTemporaryDirectory(), file)
                try fileManager.removeItem(atPath: path)
            }
        } catch {
            print(error)
        }
    }
    
    //MARK:- LogOut
    class func logOut(){
        
        let deviceToken = currentUser.deviceToken
        AppUserModel.removeAllValues()
        self.removeChahe()
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        currentUser.deviceToken = deviceToken
        let loginScene = LoginVC.instantiate(fromAppStoryboard: .PreLogin)
        self.setRootController(vc: loginScene)
    }
    
    //MARK:- Add/Remove Child View Controller
    class func addChildVC(childVC:UIViewController, parentVC:UIViewController){
        parentVC.addChildViewController(childVC)
        childVC.view.frame = parentVC.view.frame
        parentVC.view.addSubview(childVC.view)
        childVC.didMove(toParentViewController: parentVC)
    }
    
    class func removeChildVC(childVC:UIViewController){
        childVC.willMove(toParentViewController: nil)
        childVC.view.removeFromSuperview()
        childVC.removeFromParentViewController()
    }
   
    // MARK: Calculate the size of text
    class func textSizeCount(_ text: String?, font: UIFont, bundingSize size: CGSize) -> CGSize {
        if text == nil{
            return CGSize.zero
        }
        let mutableParagraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        mutableParagraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        let attributes: [NSAttributedStringKey : Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : font, NSAttributedStringKey(rawValue: NSAttributedStringKey.paragraphStyle.rawValue) : mutableParagraphStyle]
        let tempStr = NSString(string: text!)
        
        let rect: CGRect = tempStr.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
        let height = ceilf(Float(rect.size.height))
        let width = ceilf(Float(rect.size.width))
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
    
    //MARK: Check if network is available
    class func isNetworkAvailable() -> Bool{
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var  flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    // MARK:- save To PhotoLibrary
    class func saveToPhotoLibrary(url: URL, completion:@escaping (_ assetURL:URL?,_ error:Error?) -> Void){
        if FileManager.default.fileExists(atPath: url.path) || FileManager.default.fileExists(atPath: url.absoluteString){
            Global.getMainQueue {
                
                PHPhotoLibrary.shared().performChanges({
                    _ = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
                }, completionHandler: { (success, error) in
                    completion(url, error)
                })
            }
        }
    }

    // MARK:- Generate video thumbnail
    class func generateThumnail(fileName :URL)-> UIImage?{
        URLCache.shared.removeAllCachedResponses()
        let assetImgGenerate :  AVAssetImageGenerator!
        let ast = AVAsset(url: fileName)
        assetImgGenerate = AVAssetImageGenerator(asset: ast)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time : CMTime = CMTimeMakeWithSeconds(1, Int32(NSEC_PER_SEC))
        do {
            let cgImage = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: cgImage, scale: 1.0, orientation: UIImageOrientation.right)
        }catch let error{
            Global.print_Debug("Image generation failed with error \(error)")
            return nil
        }
    }
    
    // MARK:- Compress Video
    class func compressVideo(inputURL: URL, outputURL: URL, outputFileType:String, handler: @escaping (_ session: AVAssetExportSession?)-> Void)
    {
        URLCache.shared.removeAllCachedResponses()
        let urlAsset =  AVURLAsset(url: inputURL)
        let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetHighestQuality)
        exportSession?.outputURL = outputURL
        exportSession?.outputFileType = AVFileType(rawValue: outputFileType)
        exportSession?.shouldOptimizeForNetworkUse = true
        exportSession?.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
    
     // MARK:- saveVideo To DocumentDirectory
    class func saveVideoToDocumentDirectory(videoFromUrl from:URL, name:String = "") -> URL {
        let dirPath = Global.tempCompressFilePath(ext: "mov")
        let writeURL = URL(fileURLWithPath: dirPath.absoluteString)
        
        do {
            self.removeFileAtURLIfExists(writeURL)
            try FileManager.default.copyItem(at: from, to: writeURL)
        }
        catch let error {
            Global.print_Debug("error \(error)")
        }
        
        return writeURL
    }
    
    // MARK:- get video FilePath
    class func getPath(name: String, ext: String) -> URL{
        let paths =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0]
        let urlPath = URL(fileURLWithPath: documentDirectory).appendingPathComponent(name).appendingPathExtension(ext)
        let directoryPath = urlPath.absoluteString
        if FileManager.default.fileExists(atPath: urlPath.path){
            do{
                try FileManager.default.removeItem(at: urlPath)
            }catch let error {
                Global.print_Debug("Failed to remove item \(directoryPath), error = \(error)")
            }
        }
        return URL(string: directoryPath)!
    }
    
    // MARK:- tempCompress FilePath
    class func tempCompressFilePath(ext: String) -> URL {
        return self.getPath(name: "tempSurfaceMovie\(Int(Date().timeIntervalSince1970))", ext: ext)
    }
    
    class func removeFileAtURLIfExists(_ url:URL){
        if FileManager.default.fileExists(atPath: url.path){
            do{
                try FileManager.default.removeItem(at: url)
            }catch let error {
                Global.print_Debug("Failed to remove item \(url), error = \(error)")
            }
        }
    }
    
    // fixOrientationOfImage
    class func fixOrientationOfImage(image: UIImage) -> UIImage? {
        if image.imageOrientation == .up {
            return image
        }
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform = CGAffineTransform.identity
        
        switch image.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: image.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.rotated(by:  CGFloat(Double.pi / 2))
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: image.size.height)
            transform = transform.rotated(by:  -CGFloat(Double.pi / 2))
        default:
            break
        }
        
        switch image.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: image.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        guard let context = CGContext(data: nil, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: image.cgImage!.bitsPerComponent, bytesPerRow: 0, space: image.cgImage!.colorSpace!, bitmapInfo: image.cgImage!.bitmapInfo.rawValue) else {
            return nil
        }
        
        context.concatenate(transform)
        
        switch image.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            context.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: image.size.height, height: image.size.width))
        default:
            context.draw(image.cgImage!, in: CGRect(origin: .zero, size: image.size))
        }
        
        // And now we just create a new UIImage from the drawing context
        guard let CGImage = context.makeImage() else {
            return nil
        }
        
        return UIImage(cgImage: CGImage)
    }
    
    
    class func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: closure
        )
    }
}



