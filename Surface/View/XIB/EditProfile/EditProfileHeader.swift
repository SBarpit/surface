//
//  EditProfileHeader.swift
//  Surface
//
//  Created by Arvind Rawat on 03/04/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

protocol ImagePickerDelegate {
    
    func pickImage()
}


class EditProfileHeader: UITableViewHeaderFooterView {

    //MARK:- IBOULETS
    //===============
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var changeBtn: UIButton!
    
    
    //MARK:- PROPERTIES
    //=================
    var delegate : ImagePickerDelegate?
   
    override func awakeFromNib() {
        
        initialSetup()
        
        
    }
    
    
    //MARK:- IBACTIONS
    //================
    @IBAction func changedBtnTapped(_ sender: UIButton) {
        
        delegate?.pickImage()
        
    }
    
    func initialSetup(){
    changeBtn.cornerRadius(radius: changeBtn.h/2)
    }
}
