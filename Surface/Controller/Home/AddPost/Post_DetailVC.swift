//
//  Post_DetailVC.swift
//  Surface
//
//  Created by Nandini Yadav on 23/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class Post_DetailVC: BaseSurfaceVC {

    //MARK:- Properties
    
    // properties when edit post
    var postData: Featured_List?
    weak var delegate : editPostProtocol?
    var videoAsset : AVAsset?
    var videoUrl: URL?
    
    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    
    //MARK:- @IBOutlets
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var overLayView: UIView!
    @IBOutlet weak var post_descLabel: UILabel!
    @IBOutlet weak var viewCountButton: UIButton!
    @IBOutlet weak var commentCountButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var sideMenuOption: UIButton!
    @IBOutlet weak var videoPreview: UIView!
    @IBOutlet weak var playVideoButton: UIButton!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        overLayView.isUserInteractionEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.overLayView.vertical_Gradient_Color(colors: [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3769263698).cgColor , #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor , #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4138484589).cgColor], locations: [0.0 , 0.50 , 0.90])
        self.profileImage.cornerRadius(radius: profileImage.h/2)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    //MARK:- Private Methods
    private func initialSetup(){
       
        if  let postData = self.postData , let mediaData = postData.media_arr.first{
            self.post_descLabel.text = postData.desc
            commentCountButton.setTitle("\(postData.comments_count)", for: .normal)
            viewCountButton.setTitle("\(postData.views_count)", for: .normal)
            userName.text = postData.user_name.capitalizedFirst()
            profileImage.kf.setImage(with: URL(string:mediaData.media_thumbnail))
            
            if mediaData.media_type == "1"{
                 self.coverImage.contentMode = .scaleAspectFit
                self.coverImage.kf.setImage(with: URL(string:mediaData.media_thumbnail))
                self.videoPreview.isHidden = true
                self.playVideoButton.isHidden = true
               
            }else{
                self.coverImage.isHidden = true
                videoUrl = URL(string: mediaData.media_url)
                let asset = AVAsset(url: videoUrl!)
                videoAsset = asset
                
                // Add Player view
                Global.print_Debug(" filter_video URl:- \(videoUrl?.absoluteString ?? "")")
                
                self.avpController = AVPlayerViewController()
                avpController.view.frame = self.videoPreview.frame
                self.addChildViewController(avpController)
              
                
                self.videoPreview.addSubview(avpController.view)
                self.playVideo()
                
                NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)),
                                                       name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
            }
        }
    }
    
    fileprivate func playVideo() {
        guard let avAsset = self.videoAsset else {return}
        
        let item = AVPlayerItem(asset: avAsset)
        
        self.player = AVPlayer(playerItem: item)
        self.avpController.player = self.player
        self.player.play()
        self.playVideoButton.isSelected = true
    }
    
    @objc private func playerDidFinishPlaying(_ note: NSNotification) {
        Global.print_Debug("Video Finished")
        //self.playVideoButton.isSelected = false
        self.player.play()
        self.player.seek(to: CMTime(seconds: 0.0, preferredTimescale: 1))
        self.view.layoutIfNeeded()
    }
    
    //MARK:- @IBActions & Methods
    @IBAction func playVideoButtonTapped(_ sender: UIButton) {
        if self.player != nil , !self.playVideoButton.isSelected{
            self.player.play()
            self.playVideoButton.isSelected = true
        }else{
            self.player.pause()
            self.playVideoButton.isSelected = false
        }
    }
    
    @IBAction func viewButtonTapped(_ sender: UIButton) {
        Global.showToast(msg: "Under Development")
    }
    
    @IBAction func commentButtonTapped(_ sender: UIButton) {
        
         let storyboard: UIStoryboard = UIStoryboard(name: "Comments", bundle: nil)
         let vc = storyboard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
         if let id = self.postData?.featured_id{
            print(id)
            vc.postId = Int(id)!
        }
         self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        Global.showToast(msg: "Under Development")
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sideMenuOptionButtonTapped(_ sender: UIButton) {
        Global.showToast(msg: "Under Development")
    }
}
