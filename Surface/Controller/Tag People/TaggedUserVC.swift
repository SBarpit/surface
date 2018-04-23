//
//  TaggedUserVC.swift
//  Surface
//
//  Created by Appinventiv Mac on 10/04/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class TaggedUserVC: UIViewController {
    
    @IBOutlet weak var taggedTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var popViewControllerButtion: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        self.setUpView()
    }
    
    func registerCells(){
        
        taggedTableView.register(UINib(nibName: "TagPeopleTVC", bundle: nil), forCellReuseIdentifier: "TagPeopleTVC")
        taggedTableView.delegate = self
        taggedTableView.dataSource = self
    }
    
    func setUpView(){
        
        self.headerView.layer.cornerRadius = 12
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func popVCButton(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
}

extension TaggedUserVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = taggedTableView.dequeueReusableCell(withIdentifier: "TagPeopleTVC", for: indexPath) as? TagPeopleTVC else { return UITableViewCell()}
        cell.userNameLabel.text = "sri_arpit"
        cell.nameLabel.text = "Arpit Srivastava"
        cell.profileImageView.image = UIImage(named: "1")
        cell.selectImageView.isHidden = true
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TagPeopleTVC else {
            return
        }
        cell.selectImageView.isHidden = false
        cell.selectImageView.image = UIImage(named: "icHomeFeaturedTaggedUsersUntag")
    }
}
