//
//  PeopleTableViewCell.swift
//  Insta
//
//  Created by admin on 05/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit


protocol PeopleTableViewCellDelegate {
    func goToProfileVC(userId:String)
}

class PeopleTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var delegate : PeopleTableViewCellDelegate?
    
    var user: User?{
        didSet{
            updateView()
        }
    }
    
    func updateView(){
        nameLabel.text = user?.username
        if let photoImageUrl = user?.profileImageUrl{
//            let photoUrl = URL(string: photoImageUrl)
//            self.profileImage.sd_setImage(with: photoUrl, completed: nil)
            Model.instance.getImage(url: photoImageUrl) { (uiimage : UIImage?) in
                self.profileImage.image = uiimage
            }
        }
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
        }
    }
    
    @objc func unFollowAction(){
        if user!.isFollowing == true {
            Api.Follow.unFollowAction(withUser: user!.id!)
            configureFollowButton()
            user!.isFollowing = !(user!.isFollowing!)
        }
    }

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.nameLabelAction))
        nameLabel.addGestureRecognizer(tapGesture)
        nameLabel.isUserInteractionEnabled = true
    }
    
    @objc func nameLabelAction(){
        if let id = user?.id{
            delegate?.goToProfileVC(userId: id)
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
