//
//  FeedCellVC.swift
//  Insta
//
//  Created by admin on 02/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class FeedCellVC: UITableViewCell {
    
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImgView: UIImageView!
    @IBOutlet weak var likeImgView: UIImageView!
    @IBOutlet weak var commentImgView: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    var feedVC : FeedVC?
    
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
        
        Api.Post.REF_POSTS.child(post!.id!).observeSingleEvent(of: .value) { (snapshot :DataSnapshot) in
            if let dict = snapshot.value as? [String: Any]{
                let post = Post.transformPostFromJson(json: dict, key: snapshot.key)
                self.updateLike(post: post)
            }
        }
        
        Api.Post.REF_POSTS.child(post!.id!).observe(.childChanged) { (snapshot :DataSnapshot) in
            print(snapshot)
            
            if let count = snapshot.value as? Int {
                if count != 0{
                    self.likeCountButton.setTitle("\(count) likes!", for: .normal)
                } else{
                    self.likeCountButton.setTitle("", for: .normal)
                }
            }
        }
        
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
        if let photoUrlString = user!.photoImageUrl{
            let photoUrl = URL(string: photoUrlString)
            self.profileImgView.sd_setImage(with: photoUrl, completed: nil)
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
        
        
    }
    
    @objc func commentImgViewAction(){
        if let id = post?.id{
            //print("commentSeque post id =\(id)")
            feedVC?.performSegue(withIdentifier: "commentSeque", sender: id)
        }
    }
    
    @objc func likeImgViewAction(){
        guard let postId = post?.id else { return  }
        incrementLikes(forRef: Api.Post.REF_POSTS.child(postId))
    }
    
    func incrementLikes(forRef ref : DatabaseReference ){
        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = Auth.auth().currentUser?.uid {
                //print("value 1:\(String(describing: currentData.value))")
                var likes: Dictionary<String, Bool>
                likes = post["likes"] as? [String : Bool] ?? [:]
                var likeCount = post["likeCount"] as? Int ?? 0
                if let _ = likes[uid] {
                    // Unslike the post and remove self from likes
                    likeCount -= 1
                    likes.removeValue(forKey: uid)
                } else {
                    // Like the post and add self to likes
                    likeCount += 1
                    likes[uid] = true
                }
                post["likeCount"] = likeCount  as AnyObject?
                post["likes"] = likes as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
            //print("value 2:\(String(describing: snapshot?.value))")
            
            if let dict = snapshot?.value as? [String: Any]{
                let post = Post.transformPostFromJson(json: dict, key: snapshot!.key)
                self.updateLike(post: post)
            }
            
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
