//
//  HeaderProfileCollectionReusableView.swift
//  Insta
//
//  Created by admin on 04/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit

protocol HeaderProfileCollectionReusableViewDelegate {
    func updateFollowButton(forUser user:User)
}

class HeaderProfileCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var myPostCountLable: UILabel!
    @IBOutlet weak var myFollowerCountLable: UILabel!
    @IBOutlet weak var myFollowingCountLable: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var delegate : HeaderProfileCollectionReusableViewDelegate?
    
    var user: User? {
        didSet{
            updateView()
        }
    }
//    var postCount : String?{
//        didSet{
//            myPostCountLable.text = postCount
//        }
//    }
    func updateView(){
        self.nameLable.text = user!.username
        if let photoUrlString = user!.profileImageUrl{
            let photoUrl = URL(string: photoUrlString)
            self.profileImage.sd_setImage(with: photoUrl, completed: nil) //to display the photo downloaded from this URL
        }
        
        Api.UserPosts.fechCountUserPosts(userId: user!.id!) { (count:Int) in
            self.myPostCountLable.text = "\(count)"
        }
        
        Api.Follow.fechCountFollowers(userId: user!.id!) { (count:Int) in
            self.myFollowerCountLable.text = "\(count)"
        }
        Api.Follow.fechCountFollowing(userId: user!.id!) { (count:Int) in
            self.myFollowingCountLable.text = "\(count)"
        }
        
        
        
        if user?.id == Api.User.CURRENT_USER?.uid{
            followButton.setTitle("edit profile", for: .normal)
            followButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            followButton.layer.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        } else{
            updateStateFollowButton()
        }
        
    }
    
    func updateStateFollowButton(){
        
        self.followButton.layer.borderWidth = 1
        self.followButton.layer.cornerRadius = 5
        self.followButton.clipsToBounds = true
        self.followButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6)
        if user!.isFollowing == false {
            configureFollowButton()
        } else {
            configureUnFollowButton()
        }
    }
    
    
    func configureFollowButton(){
        self.followButton.layer.borderColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        self.followButton.setTitleColor(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1), for: .normal)
        self.followButton.setTitle("Follow", for: .normal)
        self.followButton.addTarget(self, action: #selector(self.followAction), for: .touchUpInside)
    }
    func configureUnFollowButton(){
        self.followButton.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        self.followButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        self.followButton.setTitle("Following", for: .normal)
        self.followButton.addTarget(self, action: #selector(self.unFollowAction), for: .touchUpInside)
    }
    
    @objc func followAction(){
        if user!.isFollowing == false {
            Api.Follow.followAction(withUser: user!.id!)
            configureUnFollowButton()
            user!.isFollowing = !(user!.isFollowing!)
            self.delegate?.updateFollowButton(forUser: user!)
        }
    }
    
    @objc func unFollowAction(){
        if user!.isFollowing == true {
            Api.Follow.unFollowAction(withUser: user!.id!)
            configureFollowButton()
            user!.isFollowing = !(user!.isFollowing!)
            self.delegate?.updateFollowButton(forUser: user!)
        }
    }
}
