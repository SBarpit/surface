//
//  EditProfileVC.swift
//  Surface
//
//  Created by Arvind Rawat on 02/04/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit
import GooglePlaces




class EditProfileVC: UIViewController,UpdatePhoneNumber {
    
    

    
    //MARK:- IBOUTLET
    //===============
    @IBOutlet weak var editProfileTableView: UITableView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    //MARK:- PROPERTIES
    //=================
    var userInfo: UserInfoModel?
    var proImage:UIImage?
    var imageURL:String = ""
    let editController = EditProfileController()
    let verifyOTPController = VerifyOtpVC()
    
    //MARK:- VIEWDIDLOAD
    //==================
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNibs()
        initialSetup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
      
         verifyOTPController.updatePhoneNumberDelegate = self
    }


    //MARK:- FUNCTIONS
    //================
    
    func initialSetup() {
     
       
    
        if let userData = userInfo{
            editController.userInfo = userData
        }
        editController.configureInputDict()
        editProfileTableView.reloadData()
    }
    
    func setupNibs() {
        
        editProfileTableView.delegate   = self
        editProfileTableView.dataSource = self
        
      
        
        editProfileTableView.sectionHeaderHeight = 0.0;
        editProfileTableView.sectionFooterHeight = 0.0;
        
        let headerCell = UINib(nibName: "EditProfileHeader", bundle: nil)
        self.editProfileTableView.register(headerCell, forHeaderFooterViewReuseIdentifier: "EditProfileHeader")
        
        let headerInfo = UINib(nibName: "Textheader", bundle: nil)
        self.editProfileTableView.register(headerInfo, forHeaderFooterViewReuseIdentifier: "Textheader")
        
        let editInfoNib = UINib(nibName: "EditInfoCell", bundle: nil)
        editProfileTableView.register(editInfoNib, forCellReuseIdentifier: "EditInfoCell")
        
        let textFieldCell = UINib(nibName: "EditProfileTextFieldCell", bundle: nil)
        editProfileTableView.register(textFieldCell, forCellReuseIdentifier: "EditProfileTextFieldCell")
        
        let genderNib = UINib(nibName: "GenderCell", bundle: nil)
        editProfileTableView.register(genderNib, forCellReuseIdentifier: "GenderCell")
        
        editProfileTableView.estimatedRowHeight = 120
        editProfileTableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    func configureAddressSelection() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let searchBarTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue : UIColor.white] as [String : Any]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = searchBarTextAttributes
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func updateNumber(phone: String) {
        editController.userInfo.mobile = phone
        editProfileTableView.reloadSections([4], with: .none)
    }
    
    //MARK:- @objc Functions
    //======================
    @objc func maleBtnTapped(_ sender:UIButton) {
        
        guard let cell = sender.tableViewCell() as? GenderCell else {
            fatalError("GenderCell not initialised")
        }
        
        switch sender {
        case cell.maleBtn:
            cell.maleBtn.setTitleColor(UIColor.black, for: .selected)
            cell.maleBtn.isSelected = true
            cell.femaleBtn.isSelected = false
            editController.userInfo.gender = "1"
            
        default:
            cell.femaleBtn.setTitleColor(UIColor.black, for: .selected)
            cell.femaleBtn.isSelected = true
            cell.maleBtn.isSelected = false
            editController.userInfo.gender = "2"
            
        }
       // self.editProfileTableView.reloadRows(at: [[0,3]], with: .none)
    }
    
    @objc func editingChanged(_ textField:UITextField) {
        
        guard let index = textField.tableViewIndexPath(tableView: self.editProfileTableView) else { return }
        guard let text = textField.text else { return }
        
        switch index.section {
        case 0:
            return
        case 1:
            
            switch index.row{
            case 0:
                editController.userInfo.user_name = text
            case 1:
                editController.userInfo.user_name = text
            case 2:
                editController.userInfo.bio = text
            default:
                return
            }
             editController.userInfoDict[index.section][index.row] = text
            
        case 2:
            
            editController.userInfo.location = text
            editController.userInfoDict[index.section][index.row] = text
       
        case 4:
            
            if index.row == 0{
                 editController.userInfo.email = text
                
            }else{
                 editController.userInfo.mobile = text
            }
            
            editController.userInfoDict[index.section][index.row] = text

        default:
            ()
        }
    }

    
    //MARK:- IBACTIONS
    //================
    @IBAction func saveBtnAction(_ sender: UIButton) {
        
     editProfileTapped()
        
    }
    
    
    @IBAction func backBtnAction(_ sender: UIButton) {
self.navigationController?.popViewController(animated: true)
        
    }
}

//EXTENSION:- EditProfileVC
//==========================
extension EditProfileVC: UITableViewDelegate,UITableViewDataSource,ImagePickerDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return editController.inputDataDict.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return editController.inputDataDict[section].count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 1:
            if indexPath.row == 5{
                
                return 110
            }else{
                return 60
            }
            
        default:
            return 60
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let editTextFieldCell = tableView.dequeueReusableCell(withIdentifier: "EditProfileTextFieldCell") as? EditProfileTextFieldCell else{
            fatalError("ProfileInfoCell not found")
        }
        
        let placeHolder = editController.inputDataDict[indexPath.section]
        let infoData = editController.userInfoDict[indexPath.section]
        
        switch indexPath.section{
        case 0:
            return UITableViewCell()
            
        case 1:
            
            if indexPath.row == 5{
                
                guard let genderCell = tableView.dequeueReusableCell(withIdentifier: "GenderCell") as? GenderCell else{
                    fatalError("GenderCell not found")
                }
                genderCell.genderLabel.text = "GENDER"
                genderCell.maleBtn.addTarget(self, action: #selector(maleBtnTapped(_:)), for: .touchUpInside)
                genderCell.femaleBtn.addTarget(self, action: #selector(maleBtnTapped(_:)), for: .touchUpInside)
                return genderCell
         
            }else{
                editTextFieldCell.infoTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
                editTextFieldCell.infoTextField.delegate = self
                editTextFieldCell.populateData(index: indexPath, data: infoData[indexPath.row], placeHolder: placeHolder[indexPath.row])
                return editTextFieldCell
            }
            
        case 2,3,4:
            editTextFieldCell.infoTextField.delegate = self
            editTextFieldCell.infoTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
            editTextFieldCell.populateData(index: indexPath, data: infoData[indexPath.row], placeHolder: placeHolder[indexPath.row])
            return editTextFieldCell
            
        default:
            fatalError()
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerInfo = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Textheader") as? Textheader else{
            fatalError("ProfileHeader not found:")
        }
        
        switch section {
        case 0:
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "EditProfileHeader") as? EditProfileHeader else{
                
                fatalError("ProfileHeader not found:")
                
            }
             header.delegate = self
            if let profileImage = userInfo?.profile_image,!profileImage.isEmpty{
                if let url = URL(string: profileImage) {
                    header.headerImage.kf.setImage(with: url, placeholder: nil)
                }
            }else{
                
                header.headerImage.image = #imageLiteral(resourceName: "icTabBarProfileInactive")
            }
            return header
            
        case 1:
            headerInfo.headerInfoLabel.text = "Basic details"
            return headerInfo
        case 2:
            headerInfo.headerInfoLabel.text = "Location"
            return headerInfo
        case 3:
            headerInfo.headerInfoLabel.text = "Links"
            return headerInfo
        case 4:
            headerInfo.headerInfoLabel.text = "Contact Information"
            return headerInfo
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0{
            
            return 300
        }else{
            
            return 50
        }
    }
}

//MARK: extension GMSAutocompleteViewControllerDelegate methods
//============================================================
extension EditProfileVC: GMSAutocompleteViewControllerDelegate {

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let index = IndexPath(row: 0, section: 1)
        if let formattedAdd = place.formattedAddress {
            editController.userInfo.location = formattedAdd
           // signupController.userInfo.user_lat = String(place.coordinate.latitude)
         //   signupController.userInfo.user_long = String(place.coordinate.longitude)
            editController.userInfoDict[2][0] = formattedAdd
        }
        self.editProfileTableView.reloadSections([2], with: .none)
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }

    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        //   configureSubmitButton()
        dismiss(animated: true, completion: nil)
    }
}

//EXTENSION:- CameraPicker
//===========================

extension EditProfileVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let imagePicked = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.proImage = imagePicked
 
            
          //  let indexPath = IndexPath(row: 0, section: 0)
           
            editController.profileImage = imagePicked
             editProfileTableView.reloadSections([0], with: .fade)
        }
        if #available(iOS 11.0, *) {
            if let imageUrl = info[UIImagePickerControllerImageURL] as? URL{
                
                self.imageURL = String(describing: imageUrl)
                uploadToS3()
            }
        } else {
            // Fallback on earlier versions
        }

        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func pickImage() {
        
        let imagePicker = SingleImagePickerController()
        imagePicker.delegate = self
        imagePicker.target = self
        imagePicker.startProcessing()
    }
    func check_usernameAndPhoneNum(_ params :JSONDictionary , indexpath : IndexPath){
        WebServices.check_username(params: params, success: {  [weak self] (result) in
            guard let result = result else {return }
            
            self?.error_Messages_forUniqueCheck(indexpath: indexpath, isExists: result["status"].boolValue)
            
        }) {(error, code) in
            Global.showToast(msg: error)
        }
    }
    
    func error_Messages_forUniqueCheck(indexpath:IndexPath , isExists:Bool){
        if let cell = self.editProfileTableView.cellForRow(at: indexpath) as? EditProfileTextFieldCell {
            if isExists{
  
                cell.infoTextField.addRightIcon(nil , imageSize: CGSize.zero)
            }
            else{
                
                cell.infoTextField.addRightIcon(#imageLiteral(resourceName: "icUsernameTick"), imageSize: CGSize(width: 30, height: 30))
                
            }
        }
        
            editProfileTableView.beginUpdates()
            editProfileTableView.endUpdates()
  
    }
}


//EXTENSION:- UITEXTFIELDELEGATES
//===============================
extension EditProfileVC: UITextFieldDelegate{
    
  
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        guard let index = textField.tableViewIndexPath(tableView: self.editProfileTableView) else {return }
    
        
        switch index.section {
        case 1:
            if index.row == 1{
                if let text = textField.text,!text.isEmpty{
                    check_usernameAndPhoneNum(["username":text], indexpath: index)
                }
            }
            
        default:
            return
        }
        textField.layoutIfNeeded()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        guard let indexPath = textField.tableViewIndexPath(tableView: editProfileTableView) else{
            
            fatalError("error")
        }
        
        switch indexPath.section {
        case 2:
            configureAddressSelection()
            return false
        case 4:
            
            if indexPath.row == 0{
                let changeEmailVC = ChangeEmailVC.instantiate(fromAppStoryboard: .Profile)
                self.navigationController?.pushViewController(changeEmailVC, animated: true)
            }else{
                
                let phoneNumberVC = ChangePhoneNumberVC.instantiate(fromAppStoryboard: .Profile)
                self.navigationController?.pushViewController(phoneNumberVC, animated: true)
                
            }
            return false
        default:
            return true
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if string.containsEmoji{
            return false
        }
        
        return true
    }
    
}

//MARK:- API

extension EditProfileVC{
    
    func uploadToS3() {
        
        self.proImage?.uploadImageToS3(imageurl: "", uploadFolderName: "", compressionRatio: 0.5, success: { (boolValue, urlString) in
            
            self.editController.userInfo.profile_image = urlString
            
            self.editProfileTableView.reloadSections([0], with: .none)
            
        }, progress: { (value) in
            
            print(value)
        }, failure: { (error) in
            Global.showToast(msg:error.localizedDescription )
        })
    }
    
    
    
    func editProfileTapped(){
     
       let param = userInfo?.convertToDictionary(true)
        WebServices.update_UserProfile(params: param!, success: {  [weak self] (result) in
            guard result != nil else {return }
            
           
        }) {(error, code) in
            Global.showToast(msg: error)
        }
    }
    
}



