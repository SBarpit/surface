//
//  SearchHeaderCell.swift
//  Surface
//
//  Created by Appinventiv Mac on 10/04/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class SearchHeaderCell: UITableViewCell {

    @IBOutlet weak var saperatorView: UIView!
    @IBOutlet weak var titleHeadingLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
    }
    
    func setUpView(){
        self.searchView.layer.cornerRadius = self.searchView.bounds.height / 4
        self.titleHeadingLabel.font = AppFonts.semibold.withSize(18)
        self.backgroundColor = .white

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
