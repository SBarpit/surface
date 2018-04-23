//
//  writeCommentCell.swift
//  SocialApp
//
//  Created by Appinventiv Mac on 05/04/18.
//  Copyright © 2018 Appinventiv Mac. All rights reserved.
//

import UIKit

class writeCommentCell: UITableViewCell,UITextViewDelegate {

    @IBOutlet weak var commentTextField: UITextView!
    @IBOutlet weak var postComment: UIButton!
    @IBOutlet weak var smileyButton: UIButton!
    override func awakeFromNib() {
        self.commentTextField.becomeFirstResponder()
        super.awakeFromNib()
        self.commentTextField.delegate = self
        self.postComment.layer.cornerRadius = self.postComment.bounds.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        textView.resignFirstResponder()
    }
    
}
