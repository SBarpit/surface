//
//  ViewsVC.swift
//  Surface
//
//  Created by Appinventiv Mac on 10/04/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class ViewsVC: UIViewController {

    @IBOutlet weak var headerViews: UIView!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var viewsTabelView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        self.setUpViews()

    }
    func registerCells(){
        
        viewsTabelView.register(UINib(nibName: "TagPeopleTVC", bundle: nil), forCellReuseIdentifier: "TagPeopleTVC")
        viewsTabelView.delegate = self
        viewsTabelView.dataSource = self
    }

    func setUpViews(){
        self.headerViews.layer.cornerRadius = 12
        self.headerViews.clipsToBounds = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func popVCButton(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
}

extension ViewsVC:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = viewsTabelView.dequeueReusableCell(withIdentifier: "TagPeopleTVC", for: indexPath) as? TagPeopleTVC else { return UITableViewCell()}
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
