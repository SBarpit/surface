//
//  HomeVC.swift
//  Surface
//
//  Created by Nandini Yadav on 09/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.

import UIKit

class HomeVC: BaseSurfaceVC {
    
    //MARK:- Properties
    var nextCount:Int? = 1
    var total_Count:Int?
    var post_listArr = [Featured_List]()
    var featured_Arr = [Featured_List]()
    
    //MARK:- @IBOutlets
    
    @IBOutlet weak var heightConstraintFeaturedView: NSLayoutConstraint!
    @IBOutlet weak var progressView: ASProgressPopUpView!
    @IBOutlet weak var thumbnilImageView: UIImageView!
    @IBOutlet weak var progressContainerView: UIView!
    @IBOutlet weak var progressContainerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var compressionActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cancelRetryBackViewWidth: NSLayoutConstraint!
    @IBOutlet weak var cancelRetryBackView: UIView!
    @IBOutlet weak var uploadStatusLabel: UILabel!
    @IBOutlet weak var navigationBarSubView: UIView!
    @IBOutlet weak var featuredSubView: UIView!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var featuredTitleLabel: UILabel!
    @IBOutlet weak var featuredCollectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        progressView.cornerRadius(radius: progressView.h/2)
        thumbnilImageView.cornerRadius(radius: 3.0)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Private Methods
    private func initialSetup(){
        collectionView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        self.view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        featuredSubView.layer.shadowOffset = CGSize(width: 0, height: 4)
        featuredSubView.layer.shadowOpacity = 0.20
        featuredSubView.layer.shadowRadius = 3.0
        featuredSubView.layer.shadowColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        
        navigationBarSubView.layer.shadowOffset = CGSize(width: 0, height: 4)
        navigationBarSubView.layer.shadowOpacity = 0.11
        navigationBarSubView.layer.shadowRadius = 4.0
        navigationBarSubView.layer.shadowColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        
        collectionView.register(UINib(nibName: AppClassID.feedCell.rawValue , bundle: nil), forCellWithReuseIdentifier: AppClassID.feedCell.cellID)
        featuredCollectionView.register(UINib(nibName: AppClassID.featuredCell.rawValue , bundle: nil), forCellWithReuseIdentifier: AppClassID.featuredCell.cellID)
        
        featuredCollectionView.delegate = self
        featuredCollectionView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //self.featuredCollectionView.prefetchDataSource = self
        self.collectionView.emptyDataSetSource = self
        self.collectionView.emptyDataSetDelegate = self
        
       // self.collectionView.prefetchDataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1) , NSAttributedStringKey.font: AppFonts.regular.withSize(14.0)])
        refreshControl.addTarget(self, action: #selector(self.refresh(refreshControl:)), for: UIControlEvents.valueChanged)
        self.collectionView.addSubview(refreshControl)
        
        self.uploadingStatus(status: .None)
        self.featuredTitleLabel.isHidden = true
        self.getPostList(pageNo: 1 , isShowLoader: true)
        
        self.featuredCollectionView.isHidden = true
        self.heightConstraintFeaturedView.constant = 0
        
        self.view.layoutIfNeeded()
    }
    
    // Refresh Table View Data
    @objc private  func refresh(refreshControl: UIRefreshControl){
        self.view.endEditing(true)
        if Global.isNetworkAvailable(){
            self.getPostList(pageNo: 1)
        } else {
            Global.showToast(msg: ConstantString.no_internet.localized)
        }
        refreshControl.endRefreshing()
    }
    
    @objc func editPostButtonTapped(_ sender: UIButton){
        guard let index = sender.collectionViewIndexPath(collectionView: self.collectionView) else {
            Global.print_Debug("index not found")
            return
        }
        self.addActionSheet(index)
    }
    
    //MARK:- @IBActions & Methods
    
    //MARK:- IBActions
    //=================
    @IBAction func retryButtonTapped(_ sender: UIButton) {
        
        (AlamofireReachability.sharedInstance.isNetworkConnected())
            ?
                self.startUploading(objData: AWS3Controller.shared.dataToUpload)
            : Global.showToast(msg: "Please check internet")
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        
        AWS3Controller.shared.uploadingStatus = .None
        AWS3Controller.shared.totalBytes = 0
        AWS3Controller.shared.totalBytesSent = 0
        CommonFunctions.clearTempDirectory()
        CommonFunctions.removeChahe()
        self.uploadingStatus(status : AWS3Controller.shared.uploadingStatus)
        
    }
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        self.showLogoutConfirmationAlert()
    }
    
    private func  showLogoutConfirmationAlert() {
        
        let alert = UIAlertController(title: nil, message: "Are you sure to logout?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Logout", style: .default, handler: { (action) in
            self.logout()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func logout() {
        WebServices.logout(success: { (result) in
            if result != nil{
                Global.logOut()
            }
        }) { (err, code) in
            Global.showToast(msg: err)
        }
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        Global.showToast(msg: "under development")
    }
    
    @IBAction func messageButtonTapped(_ sender: UIButton) {
         Global.showToast(msg: "under development")
    }
}

//MARK:- UICollection View delegate/ datesource
extension HomeVC: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === self.collectionView{
            return self.post_listArr.count
        }else{
            return self.featured_Arr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView === self.collectionView{
            let width = (Global.screenWidth/2)-2.5
            let height = width*1.35
            return CGSize(width: width , height: height)
        }else{
            return CGSize(width: 53.5, height: self.featuredCollectionView.bounds.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === self.collectionView{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppClassID.feedCell.cellID, for: indexPath) as? FeedCell else {
                fatalError("HomeCollectionCell not found")
            }
            cell.load_feedCell(index: indexPath.item, data: post_listArr)
            cell.sideOptionButton.addTarget(self, action: #selector(self.editPostButtonTapped(_:)), for: .touchUpInside)
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppClassID.featuredCell.cellID, for: indexPath) as? FeaturedCell else {
                fatalError("featuredCell not found")
            }
            cell.load_featuredCell(index: indexPath.item, data: featured_Arr)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView === self.collectionView{
            show_Post_Details(index: indexPath)
        } else {
            Global.showToast(msg: "Under Development")
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
        if scrollView == self.collectionView{
            let endScrolling = scrollView.contentOffset.y + scrollView.contentSize.height
            if endScrolling > scrollView.contentSize.height {
                if let count = self.nextCount  ,let totalCount = self.total_Count , post_listArr.count < totalCount {
                    self.getPostList(pageNo:count+1)
                }
            }
        }
    }
}

//MARK:- Extension for Empty DataSet For Table viewWillLayoutSubviews
extension HomeVC : DZNEmptyDataSetSource , DZNEmptyDataSetDelegate{
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        if scrollView === self.collectionView{
             return NSAttributedString(string: "No data available", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1) , NSAttributedStringKey.font: AppFonts.semibold.withSize(12.0)])
        }else{
             return nil
        }
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return -10
    }
}

//MARK:- show Action Sheet
//========================
extension HomeVC {
    
    func addActionSheet(_ index: IndexPath) {
        
        let action_arr = [ConstantString.k_SharetoFacebook.localized , ConstantString.k_SharetoTwitter.localized, ConstantString.k_CopyLink.localized]
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for action in action_arr {
            let actionButton = UIAlertAction(title: action , style: .default, handler: {(alertAction) in
               Global.showToast(msg: "Under Development")
            })
            actionSheet.addAction(actionButton)
        }
        
        if let id = self.post_listArr[index.row].user_id , id == currentUser.id{
            let actionButton1 = UIAlertAction(title: ConstantString.k_Edit.localized, style: .default, handler: {(alertAction) in
                self.edit_UserPost(index)
            })
            let actionButton2 = UIAlertAction(title: ConstantString.k_Delete.localized, style: .destructive, handler: {(alertAction) in
              self.deletePost_Alert(index)
            })
              actionSheet.addAction(actionButton1)
              actionSheet.addAction(actionButton2)
        }
        else{
            let actionButton1 = UIAlertAction(title: ConstantString.k_TurnonPostNotifications.localized,  style: .default, handler: {(alertAction) in
                Global.showToast(msg: "Under Development")
            })
            let actionButton2 = UIAlertAction(title: ConstantString.k_Report.localized, style: .destructive, handler: {(alertAction) in
               Global.showToast(msg: "Under Development")
            })
            actionSheet.addAction(actionButton1)
            actionSheet.addAction(actionButton2)
        }
        
        let actionButtonCancel = UIAlertAction(title: ConstantString.k_Cancel.localized, style: .cancel, handler: nil)
        actionSheet.addAction(actionButtonCancel)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func deletePost_Alert(_ index:IndexPath){
        self.showAlert(alert: ConstantString.k_Delete_post.localized, msg: ConstantString.k_Delete_post_message.localized, done: ConstantString.k_Yes.localized, cancel: ConstantString.k_No.localized) { (success) in
            if success{
                 self.post_delete(index: index)
            }
        }
    }
    
    func edit_UserPost(_ index :IndexPath){
        let addPostScene = AddPostVC.instantiate(fromAppStoryboard: .Home)
        addPostScene.editPostData = post_listArr[index.row].media_arr.first
        addPostScene.edit_PostType = .edit
        addPostScene.post_id = post_listArr[index.row].featured_id
        addPostScene.post_descriptin = post_listArr[index.row].desc
        addPostScene.mediaType = post_listArr[index.row].media_arr.first?.media_type
        addPostScene.delegate = self
        self.tabBarController?.navigationController?.pushViewController(addPostScene, animated: true)
    }
    
    func show_Post_Details(index:IndexPath){
        let postDetailScene = Post_DetailVC.instantiate(fromAppStoryboard: .Home)
        postDetailScene.postData = post_listArr[index.row]
        postDetailScene.delegate = self
        let navigationController = UINavigationController(rootViewController: postDetailScene)
        navigationController.isNavigationBarHidden = true
        self.present(navigationController, animated: true, completion: nil)
    }
}

// MARK:- editPostProtocol
extension HomeVC : editPostProtocol{
    func editPost_protocol(isUpdate: Bool) {
        if isUpdate{
            self.getPostList(pageNo: 1 , isShowLoader: false)
        }
    }
}

extension HomeVC{
    
    //MARK:- Begin Uploading
    //========================
    func beginUploading(data : JSONDictionary? , isFromCamera:Bool = false){
        guard let objData = data else{ return }
        AWS3Controller.shared.dataToUpload = objData
        AWS3Controller.shared.isVideoFrom_Camera = isFromCamera
        self.startUploading(objData: AWS3Controller.shared.dataToUpload)
    }
    
    func startUploading(objData : JSONDictionary){
        
        AWS3Controller.shared.uploadingStatus = .Uploaded
        self.uploadingStatus(status: AWS3Controller.shared.uploadingStatus)
        
        if let type = objData["type"] as? String , type == "2"{
            
            guard let strUrl = objData["videoUrl"] as? URL else {
                return
            }
            
            Global.print_Debug("video url for p[ost :- \(strUrl)")
            guard let imgData = strUrl.getDataFromUrl() else{ return }
            self.setUploadingThumbNil(imgData: imgData)
            
            let tempDir = NSTemporaryDirectory()
            let tmpUrl = URL(fileURLWithPath: tempDir.appending("tmporary.mp4"))
            
            AWS3Controller.shared.compressVideo(inputURL: strUrl, outputURL: tmpUrl, handler: { (seccion) in
                
                AWS3Controller.shared.uploadVideo(url : strUrl)
            })
            
        }else{
            guard let images = objData["images"] as? JSONDictionary else {
                return
            }
            AWS3Controller.shared.uploadImages(dict: images)
        }
    }
    
    //MARK:- set uploading thumbnail
    //================================
    func setUploadingThumbNil(imgData : Data){
        Global.getMainQueue {
             self.thumbnilImageView.image =  UIImage(data: imgData, scale: 1.0) //UIImage(data: imgData)
        }
    }
    
    //Display uploading status on view
    //===================================
    func uploadingStatus(status : UploadingStatus){
        
        guard let _ = self.progressContainerViewHeight else { return }
        
        switch status{
            
        case .Compressing:
            
            UIView.animate(withDuration: 0.5, animations: {
                self.progressContainerViewHeight.constant = 70
                self.cancelRetryBackViewWidth.constant = 0
                self.view.layoutIfNeeded()
                
            })
            self.retryButton.isHidden = true
            self.cancelButton.isHidden = true
            self.thumbnilImageView.isHidden = false
            self.progressView.isHidden = false
            self.uploadStatusLabel.isHidden = false
            self.uploadStatusLabel.text = "Compressing"
            self.compressionActivityIndicator.isHidden = false
            self.compressionActivityIndicator.startAnimating()
            
        case .InProgress :
            
            UIView.animate(withDuration: 0.5, animations: {
                self.progressContainerViewHeight.constant = 70
                self.cancelRetryBackViewWidth.constant = 0
                
                self.view.layoutIfNeeded()
                
            })
            
            if let data = AWS3Controller.shared.imageUploadingData{ self.setUploadingThumbNil(imgData: data) }
            
            self.retryButton.isHidden = true
            self.cancelButton.isHidden = true
            self.thumbnilImageView.isHidden = false
            self.progressView.trackTintColor = AppColors.progressViewColor
            self.progressView.isHidden = false
            self.uploadStatusLabel.isHidden = false
            self.uploadStatusLabel.text = "Uploading....."
            self.compressionActivityIndicator.isHidden = true
            self.compressionActivityIndicator.stopAnimating()
            
        case .Posting:
            
            UIView.animate(withDuration: 0.5, animations: {
                self.progressContainerViewHeight.constant = 70
                self.cancelRetryBackViewWidth.constant = 0
                self.view.layoutIfNeeded()
                
            })
            
            self.retryButton.isHidden        = true
            self.cancelButton.isHidden       = true
            self.thumbnilImageView.isHidden  = false
            self.progressView.isHidden       = false
            self.progressView.trackTintColor = AppColors.postingProgressViewColor
            self.uploadStatusLabel.isHidden  = false
            self.uploadStatusLabel.text      = "Posting..."
            self.compressionActivityIndicator.isHidden = true
            self.compressionActivityIndicator.stopAnimating()
            
        case .Uploaded :
            UIView.animate(withDuration: 0.5, animations: {
                self.progressContainerViewHeight.constant = 0
                self.cancelRetryBackViewWidth.constant = 0
                self.view.layoutIfNeeded()
            })
            
            self.retryButton.isHidden = true
            self.cancelButton.isHidden = true
            self.thumbnilImageView.isHidden = true
            self.progressView.isHidden = true
            self.uploadStatusLabel.isHidden = true
            self.compressionActivityIndicator.isHidden = true
            self.compressionActivityIndicator.stopAnimating()
            
            // get update Posts
            self.getPostList(pageNo: 1)
            
        case .failed :
            
            UIView.animate(withDuration: 0.5, animations: {
                self.progressContainerViewHeight.constant = 70
                self.cancelRetryBackViewWidth.constant = 100
                self.view.layoutIfNeeded()
                
            })
            
            self.retryButton.isHidden = false
            self.cancelButton.isHidden = false
            self.thumbnilImageView.isHidden = false
            self.progressView.isHidden = false
            self.uploadStatusLabel.isHidden = true
            self.compressionActivityIndicator.isHidden = true
            self.compressionActivityIndicator.stopAnimating()
            
        case .None :
            
            self.progressContainerViewHeight.constant = 0
            self.cancelRetryBackViewWidth.constant = 0
            self.view.layoutIfNeeded()
            self.retryButton.isHidden = true
            self.cancelButton.isHidden = true
            self.thumbnilImageView.isHidden = true
            self.progressView.isHidden = true
            self.uploadStatusLabel.isHidden = true
            self.compressionActivityIndicator.isHidden = true
            self.compressionActivityIndicator.stopAnimating()
        }
    }
}

//MARK:- Services
extension HomeVC {
    
    func getPostList(pageNo:Int , isShowLoader:Bool = false){
        let params :JSONDictionary = ["page":pageNo]
        
        WebServices.get_home_postList(params: params, loader: isShowLoader, success: { [weak self] (result) in
            guard let data = result?["data"] else {
                Global.print_Debug("result not found")
                return
            }
            self?.featuredTitleLabel.isHidden = false
            self?.nextCount = pageNo
            self?.total_Count = result?["total"].intValue
           
            if pageNo == 1{
                self?.post_listArr = []
                self?.featured_Arr = []
            }
            
            if let arr = data["featured"].array{
                for value in arr{
                    guard let data = Featured_List(json: value) else {return}
                    self?.featured_Arr.append(data)
                }
            }
            //hide the featured collectionview if no featured posts available
            
            
            guard let featuredArrayEmpty = self?.featured_Arr.isEmpty else {
                return
            }
            self?.featuredCollectionView.isHidden = featuredArrayEmpty
            self?.heightConstraintFeaturedView.constant = featuredArrayEmpty ? 0 : 112
            
            let deadlineTime = DispatchTime.now() + .seconds(1)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self?.featuredCollectionView.reloadData()
            }

            if let arr = data["home"].array{
                for value in arr{
                    guard let data = Featured_List(json: value) else {return}
                    self?.post_listArr.append(data)
                }
                 self?.collectionView.reloadData()
            }
        
            if self?.post_listArr.count == 0 {
                self?.featuredTitleLabel.isHidden = true
                self?.collectionView.reloadEmptyDataSet()
            }
            
        }) { [weak self] (error, code) in
            if self?.post_listArr.count == 0 {
                 self?.featuredTitleLabel.isHidden = true
                self?.collectionView.reloadEmptyDataSet()
            }else {
                 self?.featuredTitleLabel.isHidden = false
            }
            
            guard let featuredArrayEmpty = self?.featured_Arr.isEmpty else {
                return
            }
            self?.featuredCollectionView.isHidden = featuredArrayEmpty
            self?.heightConstraintFeaturedView.constant = featuredArrayEmpty ? 0 : 112
            
            Global.showToast(msg: error.localized)
        }
    }
    
    func post_delete(index :IndexPath){
        let params : JSONDictionary = ["id": self.post_listArr[index.row].featured_id ?? ""]
        
        WebServices.delete_userPost(params: params, success: {  [weak self] (result) in
            if let data = result{
                Global.print_Debug(data)
                self?.post_listArr.remove(at: index.row)
                if self?.post_listArr.count == 0{
                    self?.collectionView.reloadEmptyDataSet()
                }
                self?.collectionView.reloadData()
            }
        }) {  (error, code) in
              Global.showToast(msg: error.localized)
        }
    }
}
