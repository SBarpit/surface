//
//  BaseTabBarVC.swift
//  Surface
//
//  Created by Nandini Yadav on 09/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class BaseTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        Global.print_Debug(item)
    }

    //MARK:- Check permission for camers
    private func isPermission_Allowed(){
        Global.getMainQueue {

            Global.checkCameraPermission(complition: { (success) in
                if success{
                    Global.getMainQueue {
                        let createPostScene = CreatePostVC.instantiate(fromAppStoryboard: .Home)
                        let navigationController = UINavigationController(rootViewController: createPostScene)
                        navigationController.isNavigationBarHidden = true
                        self.present(navigationController, animated: true, completion: nil)
                    }
                } else {
                    self.alert_With_Ok_Action(msg: "Camera permission is not allowed", done: ConstantString.k_OK.localized, success: { (success) in

                    })
                }
            })
        }
    }
    
    func getHomeVC() -> HomeVC?{
        if let vcs = AppDelegate.shared?.tabBarScene?.viewControllers ,
            let nav = vcs.first as? UINavigationController ,
            let vc = nav.viewControllers.first as? HomeVC {
            return vc
        }else{
            return nil
        }
    }
    
    func gotoUserProfile() {
        let profileVC = ProfileVC.instantiate(fromAppStoryboard: .Profile)
        let navigationController = UINavigationController(rootViewController: profileVC)
        navigationController.isNavigationBarHidden = true
        self.present(navigationController, animated: false, completion: nil)
       
    }
    func gotoNearBy() {
        
        let nearby = NearbyUsers.instantiate(fromAppStoryboard: .SearchNearby)
        let navigationController = UINavigationController(rootViewController: nearby)
        navigationController.isNavigationBarHidden = true
        self.present(navigationController, animated: false, completion: nil)
    }
}

//MARK:- UITabBarControllerDelegate
extension BaseTabBarVC:  UITabBarControllerDelegate{
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        if viewController == tabBarController.viewControllers?[2]{
            
            if AWS3Controller.shared.uploadingStatus == .InProgress{
                let alert = UIAlertController(title: nil, message: "Uploading in Progress...", preferredStyle: UIAlertControllerStyle.alert)
                // add the actions (buttons)
           
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        
                self.present(alert, animated: true, completion: nil)
                
            }else{
                isPermission_Allowed()
            }
            // check permission for create post
            
            return false
        }
        
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
      
       
//        if selectedIndex == 4{
        
  //      gotoUserProfile()
//            
//        }
        if selectedIndex == 1 {
            gotoNearBy()
        }
        
        if selectedIndex != 0 || selectedIndex != 1 || selectedIndex != 3{
        }
    }
    
}
