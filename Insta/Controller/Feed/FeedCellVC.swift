//
//  FeedCellVC.swift
//  Insta
//
//  Created by admin on 02/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FeedCellVC: UITableViewCell {
    
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImgView: UIImageView!
    @IBOutlet weak var likeImgView: UIImageView!
    @IBOutlet weak var commentImgView: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    var post: Post?{
        didSet{
            updateView()
        }
    }
    
    var user: User?{
        didSet{
            setupUserInfo()
        }
    }
    
    func updateView(){
       self.captionLabel.text = post?.caption
        if let photoUrlString = post?.photoUrl{
            let photoUrl = URL(string: photoUrlString)
            self.postImgView.sd_setImage(with: photoUrl, completed: nil)
        }
        
        //setupUserInfo()
        
        
    }
    
    func setupUserInfo(){
        self.nameLabel.text = user!.username
        if let photoUrlString = user!.photoImageUrl{
            let photoUrl = URL(string: photoUrlString)
            self.profileImgView.sd_setImage(with: photoUrl, completed: nil)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLabel.text = ""
        self.captionLabel.text = ""
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = ""
        self.captionLabel.text = ""
        self.profileImgView.image = UIImage(named: "male-placeholder.")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
