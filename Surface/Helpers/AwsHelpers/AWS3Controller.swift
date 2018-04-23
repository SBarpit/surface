//
//
import Foundation
import AWSCore
import AWSS3
import UIKit
import AVFoundation



enum UploadingStatus{
    case Compressing
    case InProgress
    case Posting
    case Uploaded
    case failed
    case None

}

class AWS3Controller {

    //MARK:- variables
    //==========================
    static let shared = AWS3Controller()
    var uploadingStatus = UploadingStatus.None
    var totalBytes : Int64 = 0
    var totalBytesSent : Int64 = 0
    var dataToUpload : JSONDictionary = [:]
    var imageUploadingData : Data?
    var isVideoFrom_Camera:Bool = false
    
    var setProgressValue : Float = 0.0 {

        didSet{
            DispatchQueue.main.async {

                guard let homeVc = AppDelegate.shared?.tabBarScene.getHomeVC() else { return }

                guard let _ = homeVc.progressView else { return }
                print("progress val is ...\(self.setProgressValue)")
                homeVc.progressView.setProgress(self.setProgressValue, animated: true)
            }
        }
    }
    //MARK:- Get upload request object
    //=====================================
    func getRequest(url : URL,bucketDirectory:String) -> AWSS3TransferManagerUploadRequest?{
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest?.bucket = S3Details.bucketName
        uploadRequest?.acl = AWSS3ObjectCannedACL.publicRead
        uploadRequest?.key = bucketDirectory
        uploadRequest?.body = url
        return uploadRequest
    }
}

////MARK:- UPLOAD VIDEO FUNCTIONS
////==============================
extension AWS3Controller{

    func uploadVideoThumbNil(url : URL , ThumbSuccess : @escaping (Bool, String) -> Void){

        guard let imgData = url.getDataFromUrl() else{ return }

        //Note:- for this guard let is not used because if we get nil rest of the task must be executed

        self.imageUploadingData = imgData

        if let homeVc = AppDelegate.shared?.tabBarScene.getHomeVC(){
            homeVc.setUploadingThumbNil(imgData: imgData)
        }

        let name = "\(currentUser.id)/post/image/\(currentUser.id)_video_thumb_\(Date().timeIntervalSince1970*1000)"
        
        AWS3Controller.shared.uploadImageTos3(imagedata: imgData, name: name, success: { (success, imageS3Url) in
            ThumbSuccess(true , imageS3Url)

        }, progress: { (progressValue, bytesSent, totalBytesSent, totalBytesExpectedToSend) in
            
        }) { (error) in
            
        }
    }

    func uploadVideo(url : URL){

        var mediaArray : JSONDictionaryArray = JSONDictionaryArray()
        var jsonDict : JSONDictionary = JSONDictionary()

        self.uploadVideoThumbNil(url: url) { (success, thumbnilUrl) in

            Global.print_Debug("thumbnilUrl...\(thumbnilUrl)")

            jsonDict["thumbnail"] = thumbnilUrl

        }
        jsonDict["type"] = "2"

        AWS3Controller.shared.uploadVideoTos3(url : url, ext: "mp4", success: { (success, videoS3Url) in

            jsonDict["url"] = videoS3Url

            mediaArray.append(jsonDict)
            
            // save Video in Photo Gallery if video recording from camera
            if self.isVideoFrom_Camera{
                Global.saveToPhotoLibrary(url: url) { (fileUrl, error) in
                    Global.print_Debug("video is saved")
                }
            }
            self.makePostApi(type: "2", mediaArray: mediaArray)
        
        }, progress: { (progressValue) in

            self.setProgressValue = progressValue

            self.performActionInProgressBlock()
            
        }) { (error) in
            self.performActionInErrorBlock()
            Global.print_Debug(error)
        }
    }
}


////MARK:- Upload image functions
////=================================
extension AWS3Controller{

    func uploadImages(dict : JSONDictionary){

        var totalBytes = 0
        var mediaArray : JSONDictionaryArray = JSONDictionaryArray()
        var uploadCount = 0
        var uploadedBits : [String : Int64] = [String : Int64]()

        for item in dict.keys{
            
            guard let imageToupple = dict[item] as? (orignal : Data , compressed : Data) else { return }
            totalBytes += imageToupple.orignal.count
            totalBytes += imageToupple.compressed.count

        }
        self.totalBytes = Int64(totalBytes)

        for (index , item) in dict.keys.enumerated() {

            guard let imageToupple = dict[item] as? (orignal : Data , compressed : Data) else { return
         
            }

            let orignalName = "\(currentUser.id)/post/image/\(currentUser.id)_photo_\(Date().timeIntervalSince1970*1000)"

            let compressedName = "\(currentUser.id )/post/image/\(currentUser.id )_photo_compressed_\(Date().timeIntervalSince1970*1000)"

            let imgDict : JSONDictionary = ["type":"1","url" : "\(S3Details.s3Url)/\(orignalName).jpeg" , "thumbnail" : "\(S3Details.s3Url)/\(compressedName).jpeg"]

            mediaArray.append(imgDict)

            if let homeVc = AppDelegate.shared?.tabBarScene.getHomeVC() , index == 0 {

                self.imageUploadingData = imageToupple.orignal

                homeVc.setUploadingThumbNil(imgData: imageToupple.orignal)

            }

            self.uploadImageTos3(imagedata:  imageToupple.orignal, name: orignalName, success: { (success, url) in

                uploadCount += 1

                if uploadCount == dict.keys.count * 2{
                    self.makePostApi(type: "1", mediaArray: mediaArray)
                }

            }, progress: { (key, bytesSent, totalBytesSent, totalBytesExpected) in

                uploadedBits[key] = totalBytesSent


                _ = uploadedBits.keys.map({ (key) in

                    if let value = uploadedBits[key]{
                        self.totalBytesSent += value
                    }

                })



                let pro = Float(self.totalBytesSent) /  Float(self.totalBytes)

                Global.print_Debug("\(bytesSent)...\(totalBytesSent)...\(self.totalBytesSent)...\(self.totalBytes)...\(pro)")
                self.setProgressValue = pro

                self.performActionInProgressBlock()


            }, failure: { (error) in
                self.performActionInErrorBlock()
                Global.print_Debug(error.localizedDescription)

            })


            self.uploadImageTos3(imagedata: imageToupple.compressed, name: compressedName, success: { (success, url) in

                uploadCount += 1

                if uploadCount == dict.keys.count * 2{
                    self.makePostApi(type: "1", mediaArray: mediaArray)

                }

            }, progress: { (key, bytesSent, totalBytesSent, totalBytesExpected) in

                self.totalBytesSent += bytesSent

                let pro = Float(self.totalBytesSent) /  Float(self.totalBytes)

                self.setProgressValue = pro

                self.performActionInProgressBlock()

            }, failure: { (error) in

                self.performActionInErrorBlock()
                Global.print_Debug(error.localizedDescription)

            })
        }
    }
}


////MARK:- Perform actions in specific blocks
////=============================================
extension AWS3Controller {


    func performActiWhilePosting(){

        self.uploadingStatus = UploadingStatus.Posting

        guard let vc = AppDelegate.shared?.tabBarScene.getHomeVC() else { return }

        DispatchQueue.main.async {
                vc.uploadingStatus(status: self.uploadingStatus)
            }
    }

    func performActionInProgressBlock(){

        self.uploadingStatus = UploadingStatus.InProgress

        if let vc = AppDelegate.shared?.tabBarScene.getHomeVC(){
            DispatchQueue.main.async {

                vc.uploadingStatus(status: self.uploadingStatus)
            }
        }
    }

    func performActionInSuccessBlock(){
        self.uploadingStatus = UploadingStatus.Uploaded

        if let vc = AppDelegate.shared?.tabBarScene.getHomeVC(){
            DispatchQueue.main.async {

                vc.uploadingStatus(status: self.uploadingStatus)

            }
        }

        self.totalBytes = 0
        self.totalBytesSent = 0
        self.setProgressValue = 0.0
    }

    func performActionInErrorBlock(){

        self.uploadingStatus = UploadingStatus.failed
        self.totalBytesSent = 0
        self.totalBytes = 0
        self.setProgressValue = 0.0

        if let vc = AppDelegate.shared?.tabBarScene.getHomeVC(){
            DispatchQueue.main.async {

                vc.uploadingStatus(status: self.uploadingStatus)
            }
        }

    }
}

////MARK:- MAIN METHODS
////==============================
extension AWS3Controller{

    func uploadVideoTos3(url :  URL,
                         ext : String,
                         success : @escaping (Bool, String) -> Void,
                         progress : @escaping (Float) -> Void,
                         failure : @escaping (Error) -> Void){

        let name = "\(currentUser.id)/post/video/\(currentUser.id)_video_\(Date().timeIntervalSince1970*1000)"

        let bucketDirectory = "/\(name).\(ext)"

        guard  let uploadRequest = self.getRequest(url: url, bucketDirectory: bucketDirectory) else { return }

        uploadRequest.uploadProgress = {( bytesSent: Int64,  totalBytesSent: Int64, _ totalBytesExpectedToSend: Int64) -> Void in

            let pro = Double(totalBytesSent) /  Double(totalBytesExpectedToSend)

            Global.print_Debug("\(bytesSent)....\(totalBytesSent)..\(totalBytesExpectedToSend)...===\(pro)")
            progress(Float(pro))

        }

        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(uploadRequest).continueWith(executor: AWSExecutor.mainThread()) {(task) -> AnyObject in

            if let err = task.error{

                Global.print_Debug(err)

                failure(err)

            }else{
                let url = "\(S3Details.s3Url)/\(bucketDirectory)"

                Global.print_Debug(url)

                success(true, url)

            }

            return "" as AnyObject
        }

    }


    func uploadImageTos3(imagedata :  Data, name : String,
                         success : @escaping (Bool, String) -> Void,
                         progress : @escaping (String,Int64,Int64,Int64) -> Void,
                         failure : @escaping (Error) -> Void){

        let bucketDirectory = "\(name).jpeg"
        let path = NSTemporaryDirectory().stringByAppendingPathComponent(path: "Surface\(Date().timeIntervalSince1970*1000)")

        do {

            try imagedata.write(to: URL(fileURLWithPath: path), options: .atomic)

        } catch {

            Global.print_Debug("error")

        }

        let url = URL(fileURLWithPath: path)

        guard  let uploadRequest = self.getRequest(url : url,bucketDirectory:bucketDirectory) else { return }

        uploadRequest.uploadProgress = {( bytesSent: Int64,  totalBytesSent: Int64, _ totalBytesExpectedToSend: Int64) -> Void in

            guard let key = uploadRequest.key else{ return }

            progress(key, bytesSent, totalBytesSent, totalBytesExpectedToSend)

        }

        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(uploadRequest).continueWith(executor: AWSExecutor.mainThread()) {(task) -> AnyObject in

            if let err = task.error{

                Global.print_Debug("error is....\(String(describing: task.error))")
                failure(err)

            }else{

                let url = "\(S3Details.s3Url)/\(bucketDirectory)"

                Global.print_Debug("uploaded url is....\(url)")

                success(true, url)

            }

            return "" as AnyObject
        }
    }
}


////MARK:- webservice
////=================
extension AWS3Controller{

    func makePostApi(type : String , mediaArray : JSONDictionaryArray){

        guard let content = self.dataToUpload["description"] as? String else { return }

        var params : JSONDictionary = JSONDictionary()
        params["description"] = content
        
        if let objectData = try? JSONSerialization.data(withJSONObject: mediaArray, options: JSONSerialization.WritingOptions(rawValue: 0)) {
            let objectString = String(data: objectData, encoding: .utf8)
            params["media"] = objectString
        }
        //["post_type":type , "post_content" : CommonFunctions.getUnicodeFromString(str:content) , "post_media" : mediaArray]

        Global.print_Debug("final params is ....\(params)")

        self.performActiWhilePosting()

        WebServices.add_newPost(params: params, success: { (result) in
            guard let data = result else {
                Global.print_Debug("result is not found")
                return
            }
            DispatchQueue.main.async {
                
                                    self.setProgressValue = 0.7
                                    self.setProgressValue = 0.8
                                    self.setProgressValue = 1.0
                
                                Global.delay(0.7, closure: {
                                        self.performActionInSuccessBlock()
                
                                    })
                                    CommonFunctions.clearTempDirectory()
                                    CommonFunctions.removeChahe()
                                }
            guard (AppDelegate.shared?.tabBarScene.getHomeVC()) != nil else { return }
            
                                //homeVc.collectionView?.refreshAfterCreatePost()
        
            Global.print_Debug(data)
        }) { (error, code) in
            self.performActionInErrorBlock()
            Global.showToast(msg: error.localized)
        }

    }
}

//MARK:- it is a dummy method will be removed in future or we will make another class for compression
//===========================================
extension AWS3Controller{

    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {

        let urlAsset = AVURLAsset(url: inputURL, options: nil)

        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPreset640x480) else {
            handler(nil)
            return
        }

        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
}






