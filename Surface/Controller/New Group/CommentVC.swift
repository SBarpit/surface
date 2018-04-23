//
//  CommentViewController.swift
//  SocialApp
//
//  Created by Appinventiv Mac on 05/04/18.
//  Copyright © 2018 Appinventiv Mac. All rights reserved.
//

import UIKit
let grayColor:UIColor = UIColor(red: 47/255, green: 47/255, blue: 47/255, alpha: 0.3)
let blueColor:UIColor = UIColor(red: 69/255, green: 123/255, blue: 255/255, alpha: 1.0)

class CommentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    // MARK: IBOutlets
    //================
    
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var commentReplyTextView: UITextView!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var headerView:UIView!
    
    // MARK: Class properties
    //=======================
    
    var type:Int = 0           // NOTE : 0 for comment || 1 for reply
    var data = [String:Any]()
    var comments:Comment!
    var sec:Int!
    var postId:Int = 0
    var comm = ""
    
    // MARK: ViewController Lifecycle methods
    //=======================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        self.setUpView()
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        commentReplyTextView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func loadView() {
        super.loadView()
        self.getUser()
        self.getComments()
    }
    
    // MARK: Method to register the tableviewcell
    //===========================================
    
    private func registerCell(){
        commentsTableView.register(UINib(nibName: "CommentsCell", bundle: nil), forCellReuseIdentifier: "CommentsCell")
        commentsTableView.register(UINib(nibName: "writeCommentCell", bundle: nil), forCellReuseIdentifier: "writeCommentCell")
        commentsTableView.register(UINib(nibName: "ReplyCell", bundle: nil), forCellReuseIdentifier: "ReplyCell")
        self.postButton.layer.cornerRadius = self.postButton.bounds.width/2
        self.headerView.layer.cornerRadius = 12
        self.headerView.clipsToBounds = true
    }
    
    // MARK : To setup refreshController
    //==================================
    
    func setUpView(){
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1) , NSAttributedStringKey.font: AppFonts.regular.withSize(14.0)])
        refreshControl.addTarget(self, action: #selector(self.refresh(refreshControl:)), for: UIControlEvents.valueChanged)
        self.commentsTableView.addSubview(refreshControl)
        self.viewWillLayoutSubviews()
    }
    
    //MARK: Object C method
    //=====================
    
    @objc private  func refresh(refreshControl: UIRefreshControl){
        self.view.endEditing(true)
        self.getComments()
        self.getReply()
        self.commentsTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    // MARK: To add comments
    //======================
    
    func addingComments(){
        var data = [String:Any]()
        data["id"] = self.postId
        data["comment"] = self.comm
        WebServices.add_comment(params: data,success: { (message) in
            Global.showToast(msg: message)
        }, failure: {(msg,code) in
            
        })
    }
    
    
    // MARK: To get the comment list
    //==============================
    
    func getComments(){
        
        var data = [String:Any]()
        data["post_id"] = self.postId
        data["page"] = 1
        WebServices.list_comment(params: data, success: {(comm) in
            DispatchQueue.main.async {
                self.comments = comm
                self.commentsTableView.reloadData()
            }
        }, failure: {(msg,code) in
            
        })
    }
    
    
    // MARK: To add reply to perticular comment
    //=========================================
    
    func addingReply(){
        var data = [String:Any]()
        data["id"] = Int(self.comments.data![sec].id!) ?? 0
        data["comment"] = self.comm
        WebServices.reply_comment(params: data, success: {(json) in
            Global.showToast(msg: json)
        }, failure : {(msg,code) in
            Global.showToast(msg: msg)
        })
    }
    
    
    //MARK: To get the reply list
    //===========================
    
    func getReply(){
        var data = [String:Any]()
        data["id"] = Int(self.comments.data![sec].id!) ?? 0
        data["page"] = 1
        WebServices.list_reply(params: data, success: {(reply) in
            DispatchQueue.main.async {
                self.commentsTableView.reloadData()
            }
            
        }, failure: {(msg,code) in
            
        })
    }
    
    
    func getUser(){
        data["id"] = currentUser.id
    }
    
    @IBAction func popCommentView(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Post comment and reply action
    //===================================
    
    @IBAction func postCommentButton(_ sender: UIButton) {
        self.commentReplyTextView.resignFirstResponder()
        if self.type == 0 {
            self.addingComments()
            self.commentsTableView.reloadData()
            
        }else{
            type = 0
            self.addingReply()
            self.commentsTableView.reloadData()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @objc func reply(){
        
        // MARK: Set type of comment to reply
        self.type = 1
        self.commentReplyTextView.becomeFirstResponder()
    }
    
}
extension CommentViewController{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if comments == nil {
            return 0
        }else{
            return comments.data!.count
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return comments.data![section].replies!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = commentsTableView.dequeueReusableCell(withIdentifier: "ReplyCell", for: indexPath) as? ReplyCell
            else { return UITableViewCell()}
        cell.profileImageView.image = UIImage(named: "2")
        cell.backgroundColor = .white
        cell.userNameLabel.text = self.comments.data![indexPath.section].replies![indexPath.row].user_name
        cell.commentLabel.text = self.comments.data![indexPath.section].replies![indexPath.row].comment
        cell.timeLabel.text = "4 days ago"
//        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.height/2
//        cell.profileImageView.clipsToBounds = true
        cell.timeLabel.textColor = grayColor
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = commentsTableView.dequeueReusableCell(withIdentifier: "CommentsCell") as? CommentsCell
            else { return UITableViewCell()}
        
        cell.profileImageView.image = UIImage(named: "1")  // ====> Hardcoaded
        
        cell.backgroundColor = .white
        cell.usernameLabel.text = self.comments.data![section].user_name
        cell.commentLabel.text = self.comments.data![section].comment
        
        cell.timeLabel.text = "4 days ago" // ====> Hardcoaded
//        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.height/2
//        cell.profileImageView.clipsToBounds = true
        cell.timeLabel.textColor = grayColor
        cell.replyButton.addTarget(self, action: #selector(reply), for: .touchUpInside)
        self.sec = section
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
}

extension CommentViewController : UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            Global.showToast(msg: "Can't post empty comment")
        }
        else{
            self.comm = textView.text
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
    
}
