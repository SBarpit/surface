//
//  AddPostVC.swift
//  Surface
//
//  Created by Nandini Yadav on 21/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SCRecorder
import AVFoundation
import AVKit

protocol editPostProtocol:class{
    func editPost_protocol(isUpdate:Bool)
}

class AddPostVC: BaseSurfaceVC {
    enum editPost{
        case edit
        case none
    }

    //MARK:- Properties
    private var textMax_height: CGFloat = 0
    var postImage: UIImage!
    var mediaType:String!
    var videoAsset : AVAsset?
    var videoUrl: URL?
    var videoComposition : AVVideoComposition?

    var add_postType = PostType.None
    
    // properties when edit post
    var post_descriptin:String?
    var edit_PostType = editPost.none
    var editPostData: Media_List?
    var post_id:String?
    weak var delegate : editPostProtocol?
    //
    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    
    //MARK:- @IBOutlets
    @IBOutlet weak var videoPreviewVIew: UIView!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var descriptionView: IQTextView!
    @IBOutlet weak var descriptionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var descriptionViewBottom: NSLayoutConstraint!
    @IBOutlet weak var playVideoButton: UIButton!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // Hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        descriptionView.cornerRadius(radius: 6)
        postButton.layer.borderColor = Global.getGradientImage_Color(size: postButton.size)?.cgColor
        postButton.cornerRadius(radius: postButton.h/2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Private Methods
    private func initialSetup(){
        if mediaType == "1"{
             self.videoPreviewVIew.isHidden = true
             self.playVideoButton.isHidden = true
        }else{
             self.imagePreview.isHidden = true
        }
        
        if  let postData = self.editPostData , edit_PostType == .edit{
            self.descriptionView.text = post_descriptin
            postButton.setTitle(ConstantString.k_Update.localized, for: .normal)
            
            if postData.media_type == "1"{
                 self.imagePreview.kf.setImage(with: URL(string: postData.media_url))
            }else{
                videoUrl = URL(string: postData.media_url)
                let asset = AVAsset(url: videoUrl!)
                videoAsset = asset
            }
        
        }else{
            self.imagePreview.image = postImage
        }
        
        descriptionView.placeholder = ConstantString.k_descrip_placeholder.localized
        descriptionView.delegate = self
        
        descriptionView.returnKeyType = .next
        descriptionView.isScrollEnabled = false
        
        // set gradient color on login border
        postButton.backgroundColor = .white
        postButton.layer.borderWidth = 1.0
        let textSize = Global.textSizeCount(postButton.currentTitle, font: (postButton.titleLabel?.font)!, bundingSize: CGSize(width: 60, height: 1000))
        postButton.setTitleColor(Global.getGradientImage_Color(size: textSize), for: .normal)
        
       self.playVideoButton.isSelected = true
        
        // Add Player view
        if let videoAsset = self.videoAsset {
            Global.print_Debug(" filter_video _Assets:- \(videoAsset)")
            Global.print_Debug(" filter_video URl:- \(videoUrl?.absoluteString ?? "")")
            
            self.avpController = AVPlayerViewController()
            avpController.view.frame = self.videoPreviewVIew.frame
            self.addChildViewController(avpController)
            self.videoPreviewVIew.addSubview(avpController.view)
            self.playVideo()
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
        }
    }
    
    fileprivate func playVideo() {
        guard let avAsset = self.videoAsset else {return}
    
        let item = AVPlayerItem(asset: avAsset)
        item.videoComposition = self.videoComposition
       
        self.player = AVPlayer(playerItem: item)
        self.avpController.player = self.player
        self.player.play()
        self.playVideoButton.isSelected = true
    }

    //MARK:- @IBActions & Methods
    
//    @objc private func keyboardDidShow(_ notification:Notification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            Global.print_Debug(keyboardSize.height)
//            self.descriptionViewBottom.constant =  keyboardSize.height
//        }
//    }
    
//    @objc private func keyboardWillShow(_ notification: Notification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            Global.print_Debug(keyboardSize.height)
//            self.descriptionViewBottom.constant =  keyboardSize.height
//        }
//    }
    
    @objc private func keyboardWillHide(_ notification : Notification ){
        //self.descriptionViewBottom.constant =  25
    }
    
    @objc private func playerDidFinishPlaying(_ note: NSNotification) {
        Global.print_Debug("Video Finished")
       // self.playVideoButton.isSelected = false
        self.player.play()
        self.player.seek(to: CMTime(seconds: 0.0, preferredTimescale: 1))
        self.view.layoutIfNeeded()
    }
   
    @IBAction func playVideoButtonTapped(_ sender: UIButton) {
        if self.player != nil , !self.playVideoButton.isSelected{
            self.player.play()
            self.playVideoButton.isSelected = true
        }else{
            self.player.pause()
            self.playVideoButton.isSelected = false
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        if self.player != nil , !self.playVideoButton.isSelected{
            self.player.pause()
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func postButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.player != nil , !self.playVideoButton.isSelected{
            self.player.pause()
        }
        if edit_PostType == .edit{
           self.updateUserPost()
        }else{
             self.addNew_Post()
        }
    }
    
    @IBAction func facebookButtonTap(_ sender:UIButton) {
        Global.showToast(msg: "Under Development")
    }
    
    @IBAction func twitterButtonAction(_ sender:UIButton) {
        Global.showToast(msg: "Under Development")
    }
}

// MARK:- UITextViewDelegate
extension AddPostVC : UITextViewDelegate{
    
   
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

//        if text.containsEmoji{
//            return false
//        }
//        let currentCharacterCount = textView.text?.length ?? 0
//        if (range.length + range.location > currentCharacterCount){
//            return false
//        }
//        let textHeight = Global.textSizeCount(textView.text, font: AppFonts.regular.withSize(13.5), bundingSize: CGSize(width: Global.screenWidth-20, height: 1000)).height
//        guard let lineHeight = textView.font?.lineHeight else{ return false }
//
//        let numOfLine = textHeight / lineHeight
//
//        if numOfLine > 2 && numOfLine <= 4{
//            self.textMax_height = textHeight
//            self.descriptionViewHeight.constant = textMax_height + 35
//        }else if numOfLine > 4 {
//            self.descriptionViewHeight.constant = textMax_height + 35
//        }
//        else{
//            self.descriptionViewHeight.constant = 45
//        }
//        self.view.layoutIfNeeded()
        
        
        let numberOfLines = textView.contentSize.height/(textView.font?.lineHeight ?? 1);
        textView.isScrollEnabled =  numberOfLines >= 5;
        self.view.layoutIfNeeded()
        return  textView.text.count + (text.count - range.length) <= 350
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
       textView.keyboardToolbar.isHidden  = true
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.layoutIfNeeded()
    }
    
    func textViewShouldReturn(_ textView:UITextView){
        self.view.endEditing(true)
        
    }
}

//MARK:- Add Post Functionality
extension AddPostVC{
    
    func addNew_Post(){
        
        if self.mediaType == "1"{
            var multipleImages = [String : (orignal : Data , compressed : Data)]()
            let imageData = self.getOrignalAndCompressedImageData(image: self.imagePreview.image! , quality: 0.6)
            multipleImages["0"] = imageData
            self.uploadAndpopToAlbum(type: self.mediaType, imageTouple : multipleImages)
        }
        else{
            self.uploadAndpopToAlbum(type: self.mediaType, videoData: self.videoUrl)
        }
        
    }
    
    func getOrignalAndCompressedImageData(image : UIImage , quality : CGFloat) -> (orignal : Data , compressed : Data){
        
        var imageToupple : (orignal : Data , compressed : Data) = (Data(),Data())
        
        if let data  = UIImageJPEGRepresentation(image, 0){
            
            imageToupple.orignal = data
            
        }else if let data = UIImagePNGRepresentation(image){
            imageToupple.orignal = data
        }
        
        if let data  = UIImageJPEGRepresentation(image, quality){
            
            imageToupple.compressed = data
            
        }else if let data = UIImagePNGRepresentation(image){
            
            imageToupple.compressed = data
        }
        return imageToupple
    }
    
    func uploadAndpopToAlbum(type : String, imageTouple : [String : (orignal : Data , compressed : Data)]? = nil , videoData:URL? = nil){
        
        let finalCaption = (self.descriptionView.text ?? "").condensedWhitespace
    
        var value : JSONDictionary = ["type" : type ,"description" : finalCaption]
        
        guard let vcs = AppDelegate.shared?.tabBarScene.getHomeVC() else { return }
        if let images = imageTouple {
            value["images"] = images
            vcs.beginUploading(data: value)
            
        } else if let videos = videoUrl{
            Global.print_Debug("is video from camera :- \(add_postType == .Video)")
            value["videoUrl"] = videos
            vcs.beginUploading(data: value , isFromCamera: add_postType == .Video)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // update post
    func updateUserPost(){

        var params: JSONDictionary = ["id": post_id ?? "" , "description": self.descriptionView.text.condensedWhitespace ]
        
        var mediaArray = JSONDictionaryArray()
        let dict : JSONDictionary = ["type": self.editPostData?.media_type ?? "" , "url": self.editPostData?.media_url ?? "" , "thumbnail": self.editPostData?.media_thumbnail ?? "" ]
        mediaArray.append(dict)
        
        if let objectData = try? JSONSerialization.data(withJSONObject: mediaArray, options: JSONSerialization.WritingOptions(rawValue: 0)) {
            let objectString = String(data: objectData, encoding: .utf8)
            params["media"] = objectString
        }
        
        WebServices.update_UserPost(params: params, success: { (result) in
            guard let data = result  else {
                return
            }
            Global.showToast(msg: data["msg"].stringValue)
            self.delegate?.editPost_protocol(isUpdate: true)
            _ = self.navigationController?.popViewController(animated: true)
            
        }) { (error, code) in
            Global.showToast(msg: error)
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}
