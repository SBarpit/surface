//
//  ViewController.swift
//  
//
//  Created by Appinventiv Mac on 02/04/18.
//  Copyright © 2018 Appinventiv Mac. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController,UIScrollViewDelegate {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var youBT: UIButton!
    @IBOutlet weak var friendsBT: UIButton!
    @IBOutlet weak var youBTView: UIView!
    @IBOutlet weak var friendsBTView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: Let/Var Properties
    
    var innerVC:UIViewController!
    var friendsVC:UIViewController!
    var tap:Bool = false
    let grayColor:UIColor = UIColor(red: 47/255, green: 47/255, blue: 47/255, alpha: 0.3)
    let blueColor:UIColor = UIColor(red: 69/255, green: 123/255, blue: 255/255, alpha: 1.0)
    
    // MARK:VIEWDIDLOAD
    //=================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.friendsBTView.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.friendsBT.titleLabel?.textColor = grayColor
       // self.youBT.titleLabel?.gradient(color1,color2,color3)
       // self.friendsBT.titleLabel?.gradient(color1,color2,color3)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpView(){
        
        self.scrollView.isPagingEnabled = true
        self.scrollView.delegate = self
        self.youBT.titleLabel?.font = AppFonts.semibold.withSize(13.5)
        self.friendsBT.titleLabel?.font = AppFonts.semibold.withSize(13.5)
        navigationController?.navigationBar.backgroundColor = UIColor.white
        
        let notificationVC = NotificationListVC.instantiate(fromAppStoryboard: .Home)
        self.innerVC = notificationVC
        
        let friendControllerVC = FriendsViewController.instantiate(fromAppStoryboard: .Home)
        self.friendsVC = friendControllerVC
        
    }
    
    private func setUpNavigationbar(){
        let title = UILabel()
        title.frame = CGRect(x: 0, y: 0, width: 116.5, height: 15)
        title.font = AppFonts.semibold.withSize(18)
        navigationItem.titleView = title
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
    }
    
    
    @IBAction func youActionBT(_ sender: UIButton) {
        self.tap = false
        self.friendsBT.titleLabel?.textColor = grayColor
        UIView.animate(withDuration: 0.8) {
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }
        self.youBTView.isHidden = false
        self.friendsBTView.isHidden = true
    }
    
    @IBAction func friendsActionBT(_ sender: UIButton) {
        self.tap = true
        self.youBT.titleLabel?.textColor = grayColor
        UIView.animate(withDuration: 0.8) {
            self.scrollView.contentOffset = CGPoint(x:self.friendsVC.view.bounds.width , y: 0)
        }
        self.youBTView.isHidden = true
        self.friendsBTView.isHidden = false
    }
    
    @IBAction func FriendRequests(_ sender: UIBarButtonItem) {
        
        //guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "FriendRequest") as? FriendRequest
          //  else { return }
        //self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UILabel{
    func gradient(_ color1:UIColor,_ color2:UIColor,_ color3:UIColor){
        let graidientLayer = CAGradientLayer()
        graidientLayer.colors = [color1.cgColor,color2.cgColor,color3.cgColor]
        graidientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        graidientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        graidientLayer.frame = self.bounds
        self.font = AppFonts.semibold.withSize(13.5)
        self.clipsToBounds = true
        self.layer.addSublayer(graidientLayer)
    }
}

extension NotificationVC{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 {
            UIView.animate(withDuration: 0.7, animations: {
                self.youBT.titleLabel?.textColor = self.grayColor
                 self.friendsBT.titleLabel?.textColor = self.blueColor
                self.youBTView.isHidden = false
                self.friendsBTView.isHidden = true
            })
        }else if scrollView.contentOffset.x == self.view.frame.width {
           UIView.animate(withDuration: 0.7, animations: {
            self.youBT.titleLabel?.textColor = self.grayColor
            self.friendsBT.titleLabel?.textColor = self.blueColor
            self.youBTView.isHidden = true
            self.friendsBTView.isHidden = false
        })
    }
}
}

