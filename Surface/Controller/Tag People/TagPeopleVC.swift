//
//  TagPeopleVC.swift
//  Surface
//
//  Created by Appinventiv Mac on 10/04/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class TagPeopleVC: UIViewController {
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var tagPeopleTableview: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var navigationDoneButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBAction func popViewButton(_ sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        self.setUpView()
    }
    
    func registerCell(){
        
        tagPeopleTableview.register(UINib(nibName: "TagPeopleTVC", bundle: nil), forCellReuseIdentifier: "TagPeopleTVC")
    }
    
    func setUpView(){
        self.headerView.layer.cornerRadius = 12
        self.searchView.layer.cornerRadius = 15
        tagPeopleTableview.delegate = self
        tagPeopleTableview.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

extension TagPeopleVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tagPeopleTableview.dequeueReusableCell(withIdentifier: "TagPeopleTVC", for: indexPath) as? TagPeopleTVC else { return UITableViewCell()}
        cell.userNameLabel.text = "sri_arpit"
        cell.nameLabel.text = "Arpit Srivastava"
        cell.profileImageView.image = UIImage(named: "1")
        cell.selectImageView.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
