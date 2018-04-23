//
//  ProfileVC.swift
//  Surface
//
//  Created by Arvind Rawat on 31/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit
import SwiftyJSON



class ProfileVC: UIViewController {
    
   
    //MARK:- ProfileType
    //==================
    enum ProfileType{
        case userProfile
        case otherProfile
    }

    
    
    //MARK:- IBOUTLET
    //===============
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var naviagtionSettingBtn: UIButton!
    @IBOutlet weak var profileTableView: UITableView!
    
    
    //MARK:- PROPERTIES
    //=================
    var userInfo :UserInfoModel?
    var profileType = ProfileType.userProfile
    var otherUserId:String = ""
    
    
    //MARK:- VIEWDIDLOAD
    //==================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         getProfileInfo(otherUserId: self.otherUserId)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- PRIVATE FUNCTION
    //=======================
    private func initialSetup() {
        
        self.navigationTitle.text = "Alice James"
        self.naviagtionSettingBtn.setImage(#imageLiteral(resourceName: "icMyProfileSettings"), for: .normal)
        setTableViewDelegates()
        self.profileTableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setupNibs()
    
    }
    
    private func setTableViewDelegates() {
        self.profileTableView.delegate  = self
        self.profileTableView.dataSource = self
    }
    
    
    private func setupNibs(){
        
        let headerCell = UINib(nibName: "ProfileHeader", bundle: nil)
        self.profileTableView.register(headerCell, forHeaderFooterViewReuseIdentifier: "ProfileHeader")
        
        let profileInfoNib = UINib(nibName: "ProfileInfoCell", bundle: nil)
        profileTableView.register(profileInfoNib, forCellReuseIdentifier: "ProfileInfoCell")
        
        let linkCell = UINib(nibName: "WebsiteLinkCellTableViewCell", bundle: nil)
        profileTableView.register(linkCell, forCellReuseIdentifier: "WebsiteLinkCellTableViewCell")
    
        let editBtnNib = UINib(nibName: "EditProfileButton", bundle: nil)
        profileTableView.register(editBtnNib, forCellReuseIdentifier: "EditProfileButton")
      
        profileTableView.estimatedRowHeight = 150
        profileTableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    @objc func editButtonTapped(_ sender:UIButton){
        
        let editProfileVC = EditProfileVC.instantiate(fromAppStoryboard: .Profile)
        editProfileVC.hidesBottomBarWhenPushed  = true
        editProfileVC.userInfo = userInfo
        self.navigationController?.pushViewController(editProfileVC, animated: true)
        
      //  Global.showToast(msg: "EditButton Tapped")
    }
}






//EXTENSION:- TABLEVIEW DELEGATES & DATASOURCE
//============================================
extension ProfileVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch indexPath.row {
        case 3:
            return 130
            
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let infoCell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfoCell") as? ProfileInfoCell else{
            fatalError("ProfileInfoCell not found")
        }
        
        switch indexPath.row{
        case 0:
            
            infoCell.populateCell(data:userInfo,index: indexPath.row)
     
            
            return infoCell
        case 1:
            guard let linkCell = tableView.dequeueReusableCell(withIdentifier: "WebsiteLinkCellTableViewCell") as? WebsiteLinkCellTableViewCell else{
                fatalError("EditProfileButton not found")
            }
            
            if let link = userInfo?.weblink{
                  linkCell.populateData(data:link, index: indexPath.row)
            }
            
            return linkCell
       
        case 2:
            guard let editBtnCell = tableView.dequeueReusableCell(withIdentifier: "EditProfileButton") as? EditProfileButton else{
                fatalError("EditProfileButton not found")
            }
            if profileType == .userProfile{
                 editBtnCell.editProfileBtn.isHidden = false
                 editBtnCell.editProfileBtn.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
            }else{
                 editBtnCell.editProfileBtn.isHidden = true
                
            }
           
            
            return editBtnCell
        default:
            fatalError()
        }
       
    }
  
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ProfileHeader") as? ProfileHeader else{
            
            fatalError("ProfileHeader not found:")
            
        }

        if profileType == .userProfile{
            header.addFriendBtn.isHidden = true
            header.messageBtn.isHidden   = true
            
        }else{
            header.addFriendBtn.isHidden = false
            header.messageBtn.isHidden   = false
        }
        
        header.populateHeader(data: userInfo)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 350
    }
}





//EXTENSION:- ProfileINFO API
//===========================
extension ProfileVC {
    
    func getProfileInfo(otherUserId:String){
         var param = JSONDictionary()
        if profileType == .userProfile{
            param[ApiKeys.id.string] = currentUser.id
      
        }else{
            param[ApiKeys.id.string] = otherUserId
        }
        
        WebServices.get_Profile_API(params: param, loader: true, success: { (results) in
            
            if let result = results?.dictionaryValue{
                if let data = result["data"]{
                    self.userInfo = UserInfoModel.init(data)
                }
            }
            self.profileTableView.reloadData()
        }) { (error, code) in
            Global.showToast(msg: error.localized)
        }
    }
}

