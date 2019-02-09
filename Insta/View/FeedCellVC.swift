//
//  FeedCellVC.swift
//  Insta
//
//  Created by admin on 02/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit
import ProgressHUD

protocol FeedCellVCDelegate {
    func goToCommentVC(postId : String)
    func goToProfileVC(userId: String)
}


class FeedCellVC: UITableViewCell {
    
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImgView: UIImageView!
    @IBOutlet weak var likeImgView: UIImageView!
    @IBOutlet weak var commentImgView: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    
    
    var delegate : FeedCellVCDelegate?
    
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
        if let photoUrlString = post!.photoUrl{
            Model.instance.getImage(url: photoUrlString) { (uiimage : UIImage?) in
                self.postImgView.image = uiimage
            }
        }
       
        self.updateLike(post: self.post!)
    }
    
    func updateLike(post : Post){
        DispatchQueue.main.async {
            if let isliked = post.isliked {
                //print("isliked= \(isliked)")
                if isliked {
                    self.likeImgView.image = #imageLiteral(resourceName: "like_selected")
                    //print("like")
                } else{
                    self.likeImgView.image = #imageLiteral(resourceName: "like_unselected")
                    //print("unlike")
                }
            }else{
                 self.likeImgView.image = #imageLiteral(resourceName: "like_unselected")
            }
           
            self.likeImgView.setNeedsDisplay()
            
            if let count = post.likeCount {
                if count != 0{
                    self.likeCountButton.setTitle("\(count) likes!", for: .normal)
                } else{
                    self.likeCountButton.setTitle("", for: .normal)
                }
            }
        }
    }
    
    func setupUserInfo(){
        self.nameLabel.text = user!.username
        if let photoUrlString = user!.profileImageUrl{
            Model.instance.getImage(url: photoUrlString) { (uiimage : UIImage?) in
                self.profileImgView.image = uiimage
            }
        }
    }
    

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLabel.text = ""
        self.captionLabel.text = ""
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(commentImgViewAction))
        commentImgView.addGestureRecognizer(tapGesture)
        commentImgView.isUserInteractionEnabled = true
        
        let tapGestureliker = UITapGestureRecognizer(target: self, action: #selector(likeImgViewAction))
        likeImgView.addGestureRecognizer(tapGestureliker)
        likeImgView.isUserInteractionEnabled = true
        
        
        let tapGestureNamelabel = UITapGestureRecognizer(target: self, action: #selector(self.nameLabelAction))
        nameLabel.addGestureRecognizer(tapGestureNamelabel)
        nameLabel.isUserInteractionEnabled = true
    }
    
    @objc func nameLabelAction(){
        if let id = user?.id{
            delegate?.goToProfileVC(userId: id)
        }
    }
    
    @objc func commentImgViewAction(){
        if let id = post?.id{
            delegate?.goToCommentVC(postId: id)
        }
    }
    
    @objc func likeImgViewAction(){
        guard let postId = post?.id else { return  }
        Api.Post.incrementLikes(postId : postId , onSucess: { (post: Post) in
            self.updateLike(post: post)
            self.post?.likes = post.likes
            self.post?.isliked = post.isliked
            self.post?.likeCount = post.likeCount
        }) { (errorMsg) in
            ProgressHUD.showError(errorMsg)
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = ""
        self.captionLabel.text = ""
        self.profileImgView.image = #imageLiteral(resourceName: "male-placeholder.")
        self.likeImgView.image = #imageLiteral(resourceName: "like_unselected")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
