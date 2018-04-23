//
//  AppDelegate+RemoteNotification.swift
//  Surface
//
//  Created by Nandini Yadav on 13/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import UserNotifications

extension AppDelegate: UNUserNotificationCenterDelegate{
    
    //MARK:-  RegisterForRemoteNotification
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        Global.print_Debug("device token = \(deviceTokenString)")
        USER_DEVICE_TOKEN = deviceTokenString
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Global.print_Debug("fail for notification = \(error.localizedDescription)")
    }
    
    //MARK:- registerForRemoteNotification
    func registerForRemoteNotificatio(application: UIApplication){
        let notification = UNUserNotificationCenter.current()
        notification.delegate = self
        notification.requestAuthorization(options: [.sound , .alert], completionHandler: {(success , error) in
            if error == nil{
                Global.getMainQueue {
                    UIApplication.shared.registerForRemoteNotifications()
                    Global.print_Debug(success)
                }
            }else{
                Global.print_Debug((error?.localizedDescription)! + "====================")
            }
        })
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        guard let userInfo : [String:Any] = notification.request.content.userInfo as? [String:Any] else { return }
        Global.print_Debug(userInfo)
        let state: UIApplicationState = UIApplication.shared.applicationState
        if state != .active {
            self.handlePushNotification(userInfo: userInfo["aps"] as? [String:Any])
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        completionHandler([.alert ,.badge ,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard let userInfo : [String:Any] = response.notification.request.content.userInfo as? [String:Any] else { return }
        Global.print_Debug(userInfo)
        self.handlePushNotification(userInfo: userInfo["aps"] as? [String:Any])
        completionHandler()
    }
    
    //MARK:- handle Push Notification
    func handlePushNotification(userInfo : [String:Any]?){
        guard let user_Info = userInfo else {return}
        Global.print_Debug(user_Info)
    }
    
    func handle_DeepLinking(url_Str:String){
        let split_str = url_Str.components(separatedBy: "token_")
        Global.print_Debug(split_str)
        let loginScene = LoginVC.instantiate(fromAppStoryboard: .PreLogin)
        loginScene.reset_token = split_str.last
        Global.setRootController(vc: loginScene)
    }
}
