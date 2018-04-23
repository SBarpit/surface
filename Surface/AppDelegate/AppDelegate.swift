//
//  AppDelegate.swift
//  Surface
//
//  Created by Nandini on 28/02/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import IQKeyboardManagerSwift
import FBSDKCoreKit
import GoogleSignIn
import GooglePlaces
import AWSCore
import AWSS3

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabBarScene:BaseTabBarVC!
    static let shared: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.initialDidFinishLunch(application: application, lunchOptions: launchOptions)
        if !currentUser.did_run_first_time_App{
            sleep(2)
        }
        self.registerForRemoteNotificatio(application: application)
        GMSPlacesClient.provideAPIKey("AIzaSyBZvF0rNWSqfWpdi0OAnCOr454_bcsFALc")
        self.setupAmazonS3()
        return true
    }
    
    //MARK: Google / Facebook Login Url
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        Global.print_Debug("deep link url:- \(url.absoluteString)")
        Global.print_Debug(url.scheme)
        if let scheme = url.scheme ,scheme.hasPrefix("fb"){
            return FBSDKApplicationDelegate.sharedInstance().application(
                application,
                open: url as URL!,
                sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplicationOpenURLOptionsKey.annotation] as Any
            )
        }else if let scheme = url.scheme , scheme == "surface"{
            handle_DeepLinking(url_Str: url.absoluteString)
            return true
        }
        else{
            return GoogleLoginController.shared.handleUrl(url, options: options)
        }
    }
    
    //MARK:- Initial DidFinish Lunch
    func initialDidFinishLunch(application:UIApplication , lunchOptions:[UIApplicationLaunchOptionsKey: Any]?){
        
        //IQKeyboardManager
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        
        //MARK: Facebook related
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: lunchOptions)
        
        //MARK: Google login related...
        GoogleLoginController.shared.configure(withClientId: AppConstants.kClientID.rawValue)
        
        // register for remote Notification
        //self.registerForRemoteNotificatio(application: application)
        
        //Fabric/ Crashlytics
        Fabric.with([Crashlytics.self])
        self.logUser()
        if !currentUser.id.isEmpty{
             self.tabBarScene = BaseTabBarVC.instantiate(fromAppStoryboard: .Home)
            Global.setRootController(vc: self.tabBarScene)
        }
    }
    
    func logUser() {
        // You can call any combination of these three methods
        Crashlytics.sharedInstance().setUserEmail("nandiniyadav088@gmail.com")
        Crashlytics.sharedInstance().setUserIdentifier("12345")
        Crashlytics.sharedInstance().setUserName("Surface User")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func setupAmazonS3(){
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .USEast1 ,identityPoolId:S3Details.amazonPoolId)
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }

}

