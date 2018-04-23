

import Foundation
import Photos

extension Global {
    
    class func checkPermissions(picker : UIImagePickerController? , vcObj : UIViewController? , complition: @escaping (_ success:Bool) -> ()) {
        Global.checkCameraPermission { (success) in
            complition(success)
        }
    }
    
    class func checkCameraPermissionWithOptimization(vcObj : UIViewController? , picker : UIImagePickerController?,complition:@escaping (_ success:Bool) -> ()){
        
        let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch authStatus {
        case .authorized:
            
            if let picker = picker{
                
                guard let obj = vcObj else { return }
                
                Global.openCamera(picker: picker, vcObj: obj)
                
            } else{
                Global.checkLibraryPermisionWithOptimization(complition: { (success) in
                    complition(success)
                })
                
            }
            
        case .notDetermined:
            
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {(granted: Bool) in
                
                if !granted { return }
                
                
                if let picker = picker{
                    
                    guard let obj = vcObj else { return }
                    
                    Global.openCamera(picker: picker, vcObj: obj)
                    
                } else{
                    Global.checkLibraryPermisionWithOptimization(complition: { (success) in
                        
                        complition(success)
                    })
                }
            })
            
        case .restricted :
            NYAlertContoller.alert_With_Accept_Action(title: "Error", message:"You've been restricted from using the camera on this device. Without camera access this feature won't work.", acceptMsg: "Cancel", successBlock: { (success) in
            })
            
        default:
            
            NYAlertContoller.showAlertVC(alert: "Error", msg: "Please change your privacy setting from the setting app and allow access to camera for Surface", done: "Settings", cancel: "Cancel", success: { (success) in
                if success{
                    UIApplication.shared.open( URL(string: UIApplicationOpenSettingsURLString)!, options: ["":""], completionHandler: { (success) in
                        
                    })
                }
            })
        }
    }
    
    class func checkLibraryPermisionWithOptimization(complition:@escaping (_ success:Bool) -> ()){
        
        let authStatus : PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authStatus {
        case .authorized:
            
            Global.checkMicrophonePermissionWithOptimization(complition: { (success) in
                
                complition(success)
                
            })
            
            
        case .notDetermined:
            
            PHPhotoLibrary.requestAuthorization({ (status) in
                
                if status == PHAuthorizationStatus.authorized{
                    
                    Global.checkMicrophonePermissionWithOptimization(complition: { (success) in
                        
                        complition(success)
                        
                    })
                    
                }else{
                    NYAlertContoller.alert_With_Accept_Action(title: "Error", message:"You've been restricted from using the library on this device. Without library access this feature won't work.", acceptMsg: "Cancel", successBlock: { (success) in
                    })
                }
            })
            
        case .restricted:
            
            NYAlertContoller.alert_With_Accept_Action(title: "Error", message:"You've been restricted from using the library on this device. Without library access this feature won't work.", acceptMsg: "Cancel", successBlock: { (success) in
            })
         
        default:
            NYAlertContoller.showAlertVC(alert: "Error", msg: "Please change your privacy setting from the setting app and allow access to Photos for Surface", done: "Settings", cancel: "Cancel", success: { (success) in
                if success{
                    UIApplication.shared.open( URL(string: UIApplicationOpenSettingsURLString)!, options: ["":""], completionHandler: { (success) in
                        
                    })
                }
            })
        }
    }
    
    
    class func checkMicrophonePermissionWithOptimization(complition:@escaping (_ success:Bool) -> ()){
        
        let authStatus = AVAudioSession.sharedInstance().recordPermission()
        
        switch authStatus {
        case AVAudioSessionRecordPermission.granted:
            
            complition(true)
            
        case AVAudioSessionRecordPermission.undetermined:
            
            AVAudioSession.sharedInstance().requestRecordPermission { (success) in
                
                if success{
                    complition(true)
                }else{
                    
                    NYAlertContoller.showAlertVC(alert: "Microphone Accessability", msg: "Surface would like to access your Microphone.", done: "Go To Settings", cancel: "Cancel", success: { (success) in
                        if success{
                            UIApplication.shared.open( URL(string: UIApplicationOpenSettingsURLString)!, options: ["":""], completionHandler: { (success) in
                                
                            })
                        }
                    })
                }
            }
            
        case AVAudioSessionRecordPermission.denied:
            
            NYAlertContoller.alert_With_Accept_Action(title: "Error", message:"You've been restricted from using the microphone on this device. Without microphone access this feature won't work.", acceptMsg: "Cancel", successBlock: { (success) in
            })
            
/*
             //        default:
                NYAlertContoller.showAlertVC(alert: "Microphone Accessability", msg: "Surface would like to access your Microphone.", done: "Go To Settings", cancel: "Cancel", success: { (success) in
                    if success{
                        UIApplication.shared.open( URL(string: UIApplicationOpenSettingsURLString)!, options: ["":""], completionHandler: { (success) in

                        })
                    }
                })
            */
        }
        
    }
    
    
    
    class func openCamera(picker : UIImagePickerController , vcObj : UIViewController){
        
        let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            picker.sourceType = sourceType
            
            picker.allowsEditing = false
            
            if picker.sourceType == UIImagePickerControllerSourceType.camera {
                
                picker.showsCameraControls = true
                
            }
            
            vcObj.present(picker, animated: true, completion: nil)
            
        }
    }
    
    class func checkAndOpenLibrary(picker : UIImagePickerController ,forTypes: [String],vcObj : UIViewController) {
        
        
        picker.mediaTypes = forTypes
        
        let status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        if (status == .notDetermined) {
            
            let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.photoLibrary
            
            picker.sourceType = sourceType
            picker.allowsEditing = false
            vcObj.present(picker, animated: true, completion: nil)
            
        }
            
        else {
            if status == .restricted {
                NYAlertContoller.alert_With_Accept_Action(title: "Error", message:"You've been restricted from using the library on this device. Without camera access this feature won't work.", acceptMsg: "Cancel", successBlock: { (success) in
                    
                })
            }
            else {
                
                if status == .denied {
                    NYAlertContoller.showAlertVC(alert: "Error", msg: "Please change your privacy setting from the setting app and allow access to library for Surface.", done: "Settings", cancel: "Cancel", success: { (success) in
                        if success{
                            UIApplication.shared.open( URL(string: UIApplicationOpenSettingsURLString)!, options: ["":""], completionHandler: { (success) in
                                
                            })
                        }
                    })
                }
                    
                else {
                    
                    if status == .authorized {
                        
                        let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.photoLibrary
                        
                        picker.sourceType = sourceType
                        
                        picker.allowsEditing = false
                        
                        vcObj.present(picker, animated: true, completion: nil)
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    class func checkAndOpenCamera(picker : UIImagePickerController ,forTypes: [String],vcObj : UIViewController) {
        
        let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == AVAuthorizationStatus.authorized {
            
            let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
            
            if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                
                picker.sourceType = sourceType
                
                picker.allowsEditing = false
                
                if picker.sourceType == UIImagePickerControllerSourceType.camera {
                    
                    picker.showsCameraControls = true
                    
                }
                
                vcObj.present(picker, animated: true, completion: nil)
                
            }
                
            else {
                
            }
        }
            
        else {
            
            if authStatus == AVAuthorizationStatus.notDetermined {
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {(granted: Bool) in
                    DispatchQueue.main.async(execute: {
                        
                        if granted {
                            
                            let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
                            
                            if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                                
                                picker.sourceType = sourceType
                                
                                if picker.sourceType == UIImagePickerControllerSourceType.camera {
                                    
                                    picker.showsCameraControls = true
                                }
                                vcObj.present(picker, animated: true, completion: nil)
                            }
                                
                            else {
                                DispatchQueue.main.async(execute: {
                                    Global.showToast(msg: "Sorry! Camera not supported on this device")
                                })
                            }
                        }
                    })
                })
            }
                
            else {
                if authStatus == AVAuthorizationStatus.restricted {
                    NYAlertContoller.alert_With_Accept_Action(title: "Error", message: "You've been restricted from using the camera on this device. Without camera access this feature won't work.", acceptMsg: "Cancel", successBlock: { (success) in
                        
                    })
                }
                    
                else {
                    NYAlertContoller.showAlertVC(alert: "Error", msg: "Please change your privacy setting from the setting app and allow access to camera for Surface.", done: "Settings", cancel: "Cancel", success: { (success) in
                        if success{
                            UIApplication.shared.open( URL(string: UIApplicationOpenSettingsURLString)!, options: ["":""], completionHandler: { (success) in
                                
                            })
                        }
                    })
                }
            }
            
        }
        
    }
}

//.................

//MARK:- permissions before optimization
//=============================
extension Global{

    class func checkCameraPermission(complition:@escaping (_ success:Bool) -> ()){
        
        let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        if authStatus == AVAuthorizationStatus.authorized {
            
            let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
            
            if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                
                Global.checkLibraryPermision2(complition: { (success) in
                    
                    if success{
                        complition(true)
                    }else{
                        complition(false)
                    }
                    
                })
            }else {
                
            }
        }
            
        else {
            
            if authStatus == AVAuthorizationStatus.notDetermined {
                
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {(granted: Bool) in
                    
                    
                    DispatchQueue.main.async(execute: {
                        
                        if granted {
                            
                            let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
                            
                            if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                                
                                Global.checkLibraryPermision2(complition: { (success) in
                                    
                                    if success{
                                        complition(true)
                                    }else{
                                        complition(false)
                                    }
                                })
                            }
                                
                            else {
                                DispatchQueue.main.async(execute: {
                                    Global.showToast(msg: "Sorry! Camera not supported on this device")
                                })
                            
                            }
                            
                        }
                        
                    })
                    
                })
            }
            else {
                if authStatus == AVAuthorizationStatus.restricted {
                    NYAlertContoller.alert_With_Accept_Action(title: "Error", message: "You've been restricted from using the camera on this device. Without camera access this feature won't work.", acceptMsg: "Cancel", successBlock: { (success) in
                        
                    })
                }
                    
                else {
                    NYAlertContoller.showAlertVC(alert: "Error", msg: "Please change your privacy setting from the setting app and allow access to camera for Surface.", done: "Settings", cancel: "Cancel", success: { (success) in
                        if success{
                            UIApplication.shared.open( URL(string: UIApplicationOpenSettingsURLString)!, options: ["":""], completionHandler: { (success) in
                                
                            })
                        }
                    })
                }
                
            }
            
        }
        
    }
    
    class func checkLibraryPermision2(complition:@escaping (_ success:Bool) -> ()){
        
        let status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
    
        if status == .authorized {
            Global.checkMicrophonePermission(complition: { (success) in
                
                if success{
                    complition(true)
                }else{
                    complition(false)
                }
            })
            
        }else{
            
            if status == .notDetermined {
                
                PHPhotoLibrary.requestAuthorization({ (status) in
                    
                    if status == PHAuthorizationStatus.authorized{
                        
                        Global.checkMicrophonePermission(complition: { (success) in
                            
                            if success{
                                complition(true)
                            }else{
                                complition(false)
                                
                            }
                        })
                        
                    }else{
                        
                    }
                
                })
                
            }else if status == .restricted {
                NYAlertContoller.alert_With_Accept_Action(title: "Error", message: "You've been restricted from using the Photos on this device. Without camera access this feature won't work.", acceptMsg: "Cancel", successBlock: { (success) in
                    
                })

            }  else {
                NYAlertContoller.showAlertVC(alert: "Error", msg: "Please change your privacy setting from the setting app and allow access to Photos for Surface.", done: "Settings", cancel: "Cancel", success: { (success) in
                    if success{
                        UIApplication.shared.open( URL(string: UIApplicationOpenSettingsURLString)!, options: ["":""], completionHandler: { (success) in
                            
                        })
                    }
                })
            }
        }
    }
    
    class func checkLibraryPermision(complition:@escaping (_ success:Bool) -> ()){
        let status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        if (status == .notDetermined) {
            Global.checkMicrophonePermission(complition: { (success) in
                if success{
            
                }
            })
            
        }else {
            if status == .restricted {
                NYAlertContoller.alert_With_Accept_Action(title: "Error", message: "You've been restricted from using the library on this device. Without camera access this feature won't work.", acceptMsg: "Cancel", successBlock: { (success) in
                    
                })
            }
            else {
                
                if status == .denied {
                    NYAlertContoller.showAlertVC(alert: "Error", msg: "Please change your privacy setting from the setting app and allow access to library for Surface.", done: "Settings", cancel: "Cancel", success: { (success) in
                        if success{
                                UIApplication.shared.open( URL(string: UIApplicationOpenSettingsURLString)!, options: ["":""], completionHandler: { (success) in
                                    
                                })
                        }
                    })
    
                }
                    
                else {
                    if status == .authorized {
                        Global.checkMicrophonePermission(complition: { (success) in
                            Global.print_Debug("checkMicrophonePermission...\(success)")
                            if success{
                                complition(true)
                            }else{
                                complition(false)
                            }
                        })
                    }
                }
            }
        }
    }

    class func checkMicrophonePermission(complition:@escaping (_ success:Bool) -> ()){
        
        AVAudioSession.sharedInstance().recordPermission()
        
        AVAudioSession.sharedInstance().requestRecordPermission { (success) in
            
            if success{
                complition(true)
            }else{
                NYAlertContoller.showAlertVC(alert: "Microphone Accessability", msg: "Surface would like to access your Microphone.", done: "Go To Settings", cancel: "Cancel", success: { (success) in
                    if success{
                        UIApplication.shared.open( URL(string: UIApplicationOpenSettingsURLString)!, options: ["":""], completionHandler: { (success) in
                            
                        })
                    }
                })
            }
        }
    }
}

