//
//  FriendsViewController.swift
//  SocialApp
//
//  Created by Appinventiv Mac on 04/04/18.
//  Copyright © 2018 Appinventiv Mac. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {
    
    //MARK:- IBOUTLETS
    //================
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK:- VIEWDIDLOAD
    //==================
    override func viewDidLoad() {
        super.viewDidLoad()
        getFriendList()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    //MARK:- VIEWWILLAPPEAR
    //======================
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getFriendList()
    }
}


//MARK:- EXTENSION TABLEVIEWDELEGATES
//===================================
extension FriendsViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell", for: indexPath) as? FriendsTableViewCell else{
            fatalError()
        }
        cell.profileImageView.image = UIImage(named: "1")
        cell.descLable.text = "liks your pic"
        cell.usernameLB.text = "annu_khanna"
        cell.userImageView.image = UIImage(named: "4")
        cell.timeLB.text = "4 days"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}

//MARK:- EXTENSION API
//=====================
extension FriendsViewController{
    
    func getFriendList() {
        
        var param = JSONDictionary()
        param["id"] = currentUser.id
        param["page"] = 10
        param["search"] = ""
        WebServices.getFriendList(params: param, loader: true, success: { (results) in
            

        }) { (error, code) in
            
            Global.showToast(msg: error.localized)
        }
    }
}

