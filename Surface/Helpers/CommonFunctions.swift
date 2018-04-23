

import Photos
import AVFoundation
import SwiftyJSON


final class CommonFunctions {
    
    static let dateFormatter = DateFormatter()
    
    
    class func addChildVC(childVC:UIViewController, parentVC:UIViewController){
        parentVC.addChildViewController(childVC)
        childVC.view.frame = parentVC.view.bounds
        parentVC.view.addSubview(childVC.view)
        childVC.didMove(toParentViewController: parentVC)
    }
    
    class func removeChildVC(childVC:UIViewController){
        childVC.willMove(toParentViewController: nil)
        childVC.view.removeFromSuperview()
        childVC.removeFromParentViewController()
    }
    
    
    class func shareWithSocialMedia(message:String,vcObj:UIViewController)
    {
        
        let sub = "BeautyKingdom"
        
        var sharingItems = [AnyObject]()
        
        // sharingItems.append(sub as AnyObject)
        sharingItems.append(message as AnyObject)
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        
        activityViewController.setValue(sub, forKey: "Subject")
        
        var activitiesToExclude : [String] = []
        if #available(iOS 9.0, *) {
            
            activitiesToExclude = [UIActivityType.airDrop.rawValue, UIActivityType.print.rawValue, UIActivityType.copyToPasteboard.rawValue, UIActivityType.assignToContact.rawValue, UIActivityType.saveToCameraRoll.rawValue, UIActivityType.addToReadingList.rawValue, UIActivityType.openInIBooks.rawValue]
            
        } else {
            activitiesToExclude = [UIActivityType.airDrop.rawValue, UIActivityType.print.rawValue, UIActivityType.copyToPasteboard.rawValue, UIActivityType.assignToContact.rawValue, UIActivityType.saveToCameraRoll.rawValue, UIActivityType.addToReadingList.rawValue]
        }
        
        
        
        //if IsIPhone {
            vcObj.present(activityViewController, animated: true, completion: nil)
//        }else{
//
//        }
        
    }

    
    class func delayy(delay:Double, closure:@escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
    
    
    class func delay(delay:Double, closure:@escaping () -> Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }


}

extension CommonFunctions {


    class func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    class func getTimeStampFromDate(date:Date) -> Int{
        
        return Int(Double(date.timeIntervalSince1970))
        
    }
    
    class func dateWithFormater(time:Double)->String{
        
        let utcdate = Date(timeIntervalSince1970: time/1000.0)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        //        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "dd MMM yyyy hh:mm a"
        
        let utcstrdate = dateFormatter.string(from: utcdate)
        
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        
        let date = dateFormatter.date(from: utcstrdate) ?? Date()
        
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
}

// TODO: Move to Video Extension
extension CommonFunctions {

    class func saveVideoToDocumentDirectory(pathName : String,imageUrl:URL){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(pathName)
        // _ = UIImage(named: pathName)
        
        // let url = URL(string: imageUrl)
        var pdfData : Data?
        do{
            
            //  if imageUrl != ""{
            pdfData = try Data(contentsOf: imageUrl)
            //  }
            
        }catch {
            
        }
        Global.print_Debug(paths)
        //  let imageData = UIImageJPEGRepresentation(image!, 0.5)
        fileManager.createFile(atPath: paths as String, contents: pdfData, attributes: nil)
    }
    
    
    class func getVideoFromDocumentDirectory(pathName : String) -> Data?{
        let fileManager = FileManager.default
        
        let imagePAth = (CommonFunctions.getDirectoryPath() as NSString).appendingPathComponent(pathName)
        if fileManager.fileExists(atPath: imagePAth){
            
            do{
                
                let data = try Data(contentsOf:URL(string: imagePAth)!)
                return data
            }
            catch {
                
            }
            
            return nil
            
            
        }
        
        return nil
        
    }
    
    
    class func convertVideo(toMPEG4FormatForVideo inputURL: URL, outputURL: URL, handler : @escaping (_ session : AVAssetExportSession) -> Void){
        
        do {
            try FileManager.default.removeItem(at: outputURL)
        }
        catch {
            
        }
        
        let asset = AVAsset(url: inputURL)
        
        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)
        
        exportSession?.outputURL = outputURL
        
        exportSession?.outputFileType = AVFileType.mp4
        exportSession?.exportAsynchronously(completionHandler: {
            
            handler(exportSession!)
            
        })
        
    }
    
    class func exportVideo(toMPEG4FormatForVideo asset: AVURLAsset, outputURL: URL, handler : @escaping (_ session : AVAssetExportSession) -> Void){
        
        do {
            try FileManager.default.removeItem(at: outputURL)
        }
        catch {
            
        }
        
        
        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)
        
        exportSession?.outputURL = outputURL
        
        exportSession?.outputFileType = AVFileType.mp4
        
        exportSession?.exportAsynchronously(completionHandler: {
            
            handler(exportSession!)
            
        })
        
    }
    
    
    class func removeChahe(){
        
//        let imageCache = SDImageCache.shared()
//        imageCache?.clearMemory()
//        imageCache?.cleanDisk()
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
    }
    
    class func clearTempDirectory() {
        
        let fileManager = FileManager.default
    
        let tempFolderPath = NSTemporaryDirectory()
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
            for filePath in filePaths {
                try fileManager.removeItem(atPath: tempFolderPath + filePath)
            }
        } catch {
            print("Could not clear temp folder: \(error)")
        }
        self.removeFilesFromDocumentDirectory(fileName: "")
    }
    class func removeFilesFromDocumentDirectory(fileName:String = ""){
        
        let fileManager = FileManager.default
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        if let directoryContents = try? fileManager.contentsOfDirectory(atPath: dirPath){
            
            for path in directoryContents {
                
                if fileName.isEmpty || path.contains(fileName) {
                    let fullPath = dirPath.stringByAppendingPathComponent(path: path)
                    if let _ = try? fileManager.removeItem(atPath: fullPath){
                        Global.print_Debug("deleted at given path")
                    }
                    else {
                        Global.print_Debug("Could not retrieve directory")
                    }
                }
            }
        }
        else {
            Global.print_Debug("Could not retrieve directory")
        }
    }
    
    class func saveVideoToDocumentDirectory(assetUrl : URL){
        
        let videoURL = assetUrl
        
        var outpurURL =  (CommonFunctions.getDirectoryPath() as NSString).appendingPathComponent("mytestvideo")
        
        
        outpurURL = "" + outpurURL
        
        do {
            let data = try Data(contentsOf: videoURL)
            
            Global.print_Debug("data...\(data)")
            
            if let url = URL(string: outpurURL){
                
                try data.write(to: url)
                
                //let thumbnail = self.thumbnailForVideoAtURL(url: url)
                // let message = ChatMessageModel(image: thumbnail, messageType: .video, media: dirPath)
                // message.isUploading = true
                // self.chatList.append(message)
                DispatchQueue.main.async {
                    // self.chatTable.insertRows(at: [IndexPath(row: self.chatList.count - 1, section: 0)], with: .none)
                    // self.chatTable.scrollToRow(at: IndexPath(row: self.chatList.count - 1, section: 0), at: .none, animated: true)
                    // SQLiteManager.savePendingMessages([message], self.toUserId, .video)
                    //self.sendAudioVideo(url, ".mp4", thumbnail)
                }
            }
            
        }catch let error{
            Global.print_Debug(error.localizedDescription)
        }
        
    }
    
}

// TODO: Move to String Extension
//MARK:- Attributed string
//========================
extension CommonFunctions {
    
 
    class func wordRepresentation(val: Int) ->String{
        let num : Double = Double(val)
        let thousandNum = num/1000
        let millionNum = num/1000000
        if num >= 1000 && num < 1000000{
            if(floor(thousandNum) == thousandNum){
                return("\(Int(thousandNum))k")
            }else{
            
            let roundedStr = "\(Double(round(10*thousandNum)/10))"
            let splittedArray =  roundedStr.components(separatedBy: ".")
            guard let precisionVal = Int(splittedArray[1]) else { return "" }
            return precisionVal > 0 ? "\(roundedStr)k" : "\(splittedArray[0])k"
         
               // return "\(Double(round(10*thousandNum)/10))k"
            
            }
        }else if num >= 1000000{
            if(floor(millionNum) == millionNum){
                return("\(Int(thousandNum))k")
            }else{
                 let roundedStr = "\(Double(round(10*millionNum)/10))"
                 let splittedArray =  roundedStr.components(separatedBy: ".")
                guard let precisionVal = Int(splittedArray[1]) else { return "" }
               return precisionVal > 0 ? "\(roundedStr)M" : "\(splittedArray[0])M"
                
               // return "\(Double(round(10*millionNum)/10))M"
            }
        }else{
            if(floor(num) == num){
                return ("\(Int(num))")
            }else{
                return ("\(num)")

            }
        }
    }
    
    class func addChildForSearchVC(childVC:UIViewController, parentVC:UIViewController){
        parentVC.addChildViewController(childVC)
        let frame = CGRect(x: parentVC.view.bounds.origin.x, y: 50, width: parentVC.view.bounds.size.width, height: parentVC.view.bounds.size.height - 120)
        childVC.view.frame = frame
        parentVC.view.addSubview(childVC.view)
        childVC.didMove(toParentViewController: parentVC)
    }
  
}


//MARK:- Navigate to you youtubeAppUrl
//====================================
extension CommonFunctions{

    class func navigateToYoutube(videoId : String){
        //    EKyirtVHsK0
        guard let youtubeAppUrl = URL(string:"youtube://\(videoId)") else { return }
        
        if UIApplication.shared.canOpenURL(youtubeAppUrl) {
            UIApplication.shared.open(youtubeAppUrl, options: [:], completionHandler: nil)
        }else{
            
            guard let youtubeBrowserUrl = URL(string:"https://www.youtube.com/watch?v=\(videoId)") else { return }
            UIApplication.shared.open(youtubeBrowserUrl, options: [:], completionHandler: nil)
        }
    }
    
}


extension CommonFunctions{

class func setBtnShadow(btn: UIButton, shadowOpacity: Float, shadowRadius: CGFloat, shadowColor: UIColor) {
    
    // Shadow and Radius
    btn.layer.shadowColor = shadowColor.cgColor
    btn.layer.shadowOffset = CGSize(width: 0, height: 0)
    btn.layer.shadowOpacity = shadowOpacity
    btn.layer.shadowRadius = shadowRadius
    btn.layer.masksToBounds = false
    btn.clipsToBounds = false
}

class func setViewShadow(view: UIView, shadowOpacity: Float, shadowRadius: CGFloat, shadowColor: UIColor, shadowOffset: CGSize = CGSize(width: 0, height: 0)) {
    
    // Shadow and Radius
    view.layer.shadowColor = shadowColor.cgColor
    view.layer.shadowOffset = shadowOffset
    view.layer.shadowOpacity = shadowOpacity
    view.layer.shadowRadius = shadowRadius
    view.layer.masksToBounds = false
    view.clipsToBounds = false
}

class func btnSetup(btn: UIButton, text: String, bgColor: UIColor, titleColor: UIColor, font: UIFont) {
    // btn.doCorner(cornerRadius: btn.height/2)
    btn.setTitle(text, for: .normal)
    //btn.setTitleColor(.white, for: .normal)
    btn.backgroundColor = bgColor
    btn.setTitleColor(titleColor, for: .normal)
    btn.titleLabel?.font = font
}

class func labelSetup(label:UILabel,text:String,textColor:UIColor,font:UIFont) {
    
    label.text = text
    label.font = font
    label.textColor = textColor
    
}

class func textFieldSetup(textField:UITextField,placeholder:String,textColor:UIColor,font:UIFont) {
    
    textField.attributedPlaceholder = NSAttributedString(string:placeholder, attributes:[NSAttributedStringKey.foregroundColor:textColor ,NSAttributedStringKey.font :font])
    
}
}



