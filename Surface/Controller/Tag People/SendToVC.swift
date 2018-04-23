//
//  SendToVC.swift
//  Surface
//
//  Created by Appinventiv Mac on 10/04/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class SendToVC: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var sendToTabelView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        self.setUpViews()

    }
    
    func setUpViews(){
        
        self.headerView.layer.cornerRadius = 12
        self.searchView.layer.cornerRadius = self.searchView.bounds.height / 3.5
    }
    
    func registerCells(){
        
        sendToTabelView.register(UINib(nibName: "TagPeopleTVC", bundle: nil), forCellReuseIdentifier: "TagPeopleTVC")
        sendToTabelView.delegate = self
        sendToTabelView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        
    }
    
    @IBAction func popVCButton(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
    }

}

extension SendToVC:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = sendToTabelView.dequeueReusableCell(withIdentifier: "TagPeopleTVC", for: indexPath) as? TagPeopleTVC else { return UITableViewCell()}
        cell.userNameLabel.text = "sri_arpit"
        cell.nameLabel.text = "Arpit Srivastava"
        cell.profileImageView.image = UIImage(named: "1")
        cell.selectImageView.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? TagPeopleTVC
        else { return }
        if cell.selectImageView.isHidden{
        cell.selectImageView.isHidden = false
        }else{
            cell.selectImageView.isHidden = true
        }
        cell.selectImageView.image = UIImage(named: "icHomeShareWithinAppPopupSelected")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
