//
//  NotificationListVC.swift
//
//
//  Created by Appinventiv Mac on 02/04/18.
//  Copyright © 2018 Appinventiv Mac. All rights reserved.
//

import UIKit

class NotificationListVC: UIViewController {

    //MARK:- IBOUTLETS
    //================
    @IBOutlet weak var notificationListTableView: UITableView!
    
    //MARK:- PROPERTIES
    //=================
    var imageArray = ["1","3","2","4","5","6","7","8","9"]
    let refreshController = UIRefreshControl()
    
  
    //MARK:- VIEWDIDLOAD
    //==================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        getNotificationList()
        self.notificationListTableView.delegate = self
        self.notificationListTableView.dataSource = self
    }
    
    func initialSetup() {
        refreshController.addTarget(self, action: #selector(reloadData), for: UIControlEvents.valueChanged)
        notificationListTableView.addSubview(refreshController)
        
    }
    
    //MARK:- @OBJC FUNCTIONS
    //======================
    @objc func reloadData(){
         getNotificationList()
    }
}

//MARK:- EXTENSIONS TABLEVIEW
//===========================
extension NotificationListVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 9
        }else{
            return 9
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderSection") as? HeaderSection
        if section == 0 {
            cell?.headingLB.text = "Recent"
        }
        else{
            cell?.headingLB.text = "Earlier"
        }
        cell?.headingLB.font = AppFonts.regular.withSize(11.5)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell") as? MainCell
        if indexPath.section == 0 {
            cell?.profileImageView.image = UIImage(named: self.imageArray[indexPath.row])
            cell?.userImageView.image = UIImage(named: self.imageArray[indexPath.row])
            cell?.usernameLB.text = "sri.arpit"
            cell?.timeLB.text = "4 hrs"
            cell?.descLable.text = "likes your pics"
        }else{
            cell?.profileImageView.image = UIImage(named: self.imageArray[indexPath.row])
            cell?.userImageView.image = UIImage(named: self.imageArray[indexPath.row])
            cell?.usernameLB.text = "vinu_haye"
            cell?.timeLB.text = "4 hrs"
            cell?.descLable.text = "share your picture"
        }
        cell?.usernameLB.font = AppFonts.medium.withSize(13.5)
        cell?.descLable.font = AppFonts.regular.withSize(13.5)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}


//MARK:- EXTENSIONS TABLEVIEW
//===========================

extension NotificationListVC{
    
    func getNotificationList() {
        let param = ["page":10]
        WebServices.getNotificationList(params: param, loader: true, success: { (results) in
            
            
        }) { (error, code) in
            
            Global.showToast(msg: error.localized)
        }
    }
}
