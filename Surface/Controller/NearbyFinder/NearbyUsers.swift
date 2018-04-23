//
//  NearbyUsers.swift
//  Surface
//
//  Created by Appinventiv Mac on 10/04/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class NearbyUsers: UIViewController , GetMyLocation {
    
    // MARK: IBOUTLETS
    // ===============
    
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nearbyTabelView: UITableView!
    
    // MARK: CLASS PROPERTIES
    // ======================
    
    var data = [String:Any]()
    var nearby:NearBy!
    var cLocation = CurrentLocation()
    var lat,lng:Float?
    
    // MARK: LIFECYCLE METHOD
    // =======================
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cLocation.delegate = self
        self.registerCells()
        self.setUpViews()
        self.getNearbyUsers()
        self.nearbyTabelView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: METHOD TO REGISTER CELL
    // =============================
    
    func registerCells(){
        nearbyTabelView.register(UINib(nibName: "TagPeopleTVC", bundle: nil), forCellReuseIdentifier: "TagPeopleTVC")
    }
    
    // MARK: PROTOCOL METHOD TO GET LAT. AND LNG. OF DEVICE
    // ====================================================
    
    func coordinates(_ lat:Float, _ lng:Float){
        self.lat = lat
        self.lng = lng
    }
    
    
    func setUpViews(){
        self.loaderView.alpha = 0.0
        self.navigationView.layer.shadowColor = UIColor.gray.cgColor
        self.navigationView.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        self.navigationView.clipsToBounds = false
        self.navigationView.layer.masksToBounds = false
        self.navigationView.layer.shadowOpacity = 0.7
        nearbyTabelView.delegate = self
        nearbyTabelView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to search again", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1) , NSAttributedStringKey.font: AppFonts.regular.withSize(11.0)])
        refreshControl.addTarget(self, action: #selector(self.refresh(refreshControl:)), for: UIControlEvents.valueChanged)
        self.nearbyTabelView.addSubview(refreshControl)
        self.viewWillLayoutSubviews()
        
    }
    
    // MARK: METHOD TO GET THE NEAR BY USER'S LIST
    // ===========================================
    
    func getNearbyUsers(){
        
        self.data["longitude"] =  self.lat ??  77.367783
        self.data["lattitude"] = self.lng ?? 28.628151
        self.data["page"] = 1
        WebServices.user_byLocation(params: data, success: { (nearby) in
            self.nearby = nearby
            
        }, failure: {(mess,code) in
            
        })
    }
    
    // MARK: ONJECT C METHOD
    // =====================
    
    @objc private  func refresh(refreshControl: UIRefreshControl){
        self.view.endEditing(true)
        self.loaderView.alpha = 1.0
        UIView.animate(withDuration: 2.0, animations: {
            self.loaderView.alpha = 0.0
        })
        self.nearbyTabelView.reloadData()
        refreshControl.endRefreshing()
    }
    
    @IBAction func popVCButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: TABLEVIEW DELEGATE AND DATASOURCES METHODS
// ================================================

extension NearbyUsers:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if nearby == nil {
            return 0
        }else{
            return (nearby.data?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = nearbyTabelView.dequeueReusableCell(withIdentifier: "TagPeopleTVC", for: indexPath) as? TagPeopleTVC else { return UITableViewCell()}
        cell.userNameLabel.text = nearby.data?[indexPath.row].user_name
        cell.nameLabel.text = nearby.data?[indexPath.row].user_name
        cell.profileImageView.image = UIImage(named: "1")
        cell.selectImageView.image = UIImage(named: "icFriendListAddFriend")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? TagPeopleTVC
            else { return }
        cell.backgroundColor = .white
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
