//
//  SingleImagePickerController.swift
//  Hopper
//
//  Created by Appinventiv on 10/07/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import UIKit
import Photos

class SingleImagePickerController : UIImagePickerController {
    
    weak var target : UIViewController?
    
    func startProcessing() {
        
        let chooseOptionAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cameraOption = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { (_) in
            self.openCamera()
        }
        
        let galleryOption = UIAlertAction(title:  "Gallery", style: UIAlertActionStyle.default) { (_) in
            self.openGallery()
        }
        
        let cancelOption = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
       chooseOptionAlertController.addAction(cameraOption)
        chooseOptionAlertController.addAction(galleryOption)
        chooseOptionAlertController.addAction(cancelOption)
        
//        if let vcObj = self.target {
//
//            vcObj.present(chooseOptionAlertController, animated: true, completion: nil)
//
//        } else {
//
//            shared.window?.rootViewController?.present(chooseOptionAlertController, animated: true, completion: nil)
//        }
    
        AppDelegate.shared?.window?.rootViewController?.present(chooseOptionAlertController, animated: true, completion: nil)
     //  self.present(chooseOptionAlertController, animated: true, completion: nil)
    }
 
    private func openCamera() {

        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authorizationStatus {
        case .notDetermined:
            // permission dialog not yet presented, request authorization
            AVCaptureDevice.requestAccess(for: AVMediaType.video,
                                          completionHandler: { (granted : Bool) -> Void in
                                            if granted {

                                                self.sourceType = UIImagePickerControllerSourceType.camera

                                               // self.allowsEditing = true

                                                AppDelegate.shared?.window?.window?.rootViewController?.present(self, animated: true, completion: nil)
                                            }})
        case .authorized:

            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){

                self.sourceType = UIImagePickerControllerSourceType.camera

               // self.allowsEditing = true

                AppDelegate.shared?.window?.rootViewController?.present(self, animated: true, completion: nil)

            } else {

                //Alternate option for camera is opening photoLibrary
                let alert = UIAlertController(title:"Camera Not Found",message: "OPEN GALLERY", preferredStyle: .alert)
            
                let gallery = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default) { (_) in
                    self.openGallery()
                }
                
                let cancelOption = UIAlertAction(title:"Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            
                 alert.addAction(gallery)
                 alert.addAction(cancelOption)
                
                 AppDelegate.shared?.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }

        case .denied, .restricted:
            self.alertToEncourageCameraAccessWhenApplicationStarts()
        }
    }
    
    //function to open the library
    private func openGallery(){
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized
        {
            
            self.sourceType = UIImagePickerControllerSourceType.photoLibrary
            
           // self.allowsEditing = true
            
            AppDelegate.shared?.window?.rootViewController?.present(self, animated: true, completion: nil)
        } else {
            PHPhotoLibrary.requestAuthorization(self.requestAuthorizationHandler)
        }
    }
}

//MARK:-
//MARK:- UINavigationControllerDelegate, UIAlertViewDelegate, UIPopoverControllerDelegate
extension SingleImagePickerController : UINavigationControllerDelegate, UIAlertViewDelegate, UIPopoverControllerDelegate{
    
    private func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            
            self.sourceType = UIImagePickerControllerSourceType.photoLibrary
            
//            self.allowsEditing = true
            
            AppDelegate.shared?.window?.rootViewController?.present(self, animated: true, completion: nil)
            
        } else {
            self.alertToEncouragePhotoLibraryAccessWhenApplicationStarts()
        }
    }
    
    //CAMERA & GALLERY NOT ALLOWING ACCESS - ALERT
    private func alertToEncourageCameraAccessWhenApplicationStarts() {
       
        //Camera not available - Alert
        let cameraUnavailableAlertController = UIAlertController (title: "Camera Not Available", message: "", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .destructive) { (_) -> Void in
            
            if let settingsUrl = URL(string : UIApplicationOpenSettingsURLString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        
        cameraUnavailableAlertController.addAction(settingsAction)
        cameraUnavailableAlertController.addAction(cancelAction)
        
        AppDelegate.shared?.window?.rootViewController?.present(cameraUnavailableAlertController, animated: true, completion: nil)
    }
    
    private func alertToEncouragePhotoLibraryAccessWhenApplicationStarts() {
       
        //Photo Library not available - Alert
        let galleryUnavailableAlertController = UIAlertController (title: "Gallery Not Available", message: "", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Go To Settings", style: .destructive) { (_) -> Void in
            
            if let settingsUrl = URL(string : UIApplicationOpenSettingsURLString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        galleryUnavailableAlertController .addAction(settingsAction)
        galleryUnavailableAlertController .addAction(cancelAction)
        
        AppDelegate.shared?.window?.rootViewController?.present(galleryUnavailableAlertController, animated: true, completion: nil)
    }
}
