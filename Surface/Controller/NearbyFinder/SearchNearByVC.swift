//
//  SearchNearByVC.swift
//  Surface
//
//  Created by Appinventiv Mac on 11/04/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class SearchNearByVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchTabelView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViews()
        self.registerCells()

    }
    
    func setUpViews(){
        
        self.searchView.layer.cornerRadius = self.searchView.bounds.height/2
        self.navigationView.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        self.navigationView.layer.shadowColor = UIColor.gray.cgColor
        self.navigationView.layer.shadowOpacity = 0.5
        self.navigationView.clipsToBounds = false
        self.searchTabelView.dataSource = self
        self.searchTabelView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func registerCells(){
        searchTabelView.register(UINib(nibName: "TagPeopleTVC", bundle: nil), forCellReuseIdentifier: "TagPeopleTVC")
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
    }
    @IBAction func searchNearBy(_ sender: UIButton) {
        
        let vc = NearbyUsers.instantiate(fromAppStoryboard: .SearchNearby)
    }
    
}


extension SearchNearByVC {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = searchTabelView.dequeueReusableCell(withIdentifier: "TagPeopleTVC", for: indexPath) as? TagPeopleTVC else { return UITableViewCell()}
        cell.userNameLabel.text = "sri_arpit"
        cell.nameLabel.text = "Arpit Srivastava"
        cell.profileImageView.image = UIImage(named: "1")
        cell.selectImageView.isHidden = true
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
