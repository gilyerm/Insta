//
//  PeopleTableViewCell.swift
//  Insta
//
//  Created by admin on 05/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    
    var user: User?{
        didSet{
            updateView()
        }
    }
    
    func updateView(){
        nameLabel.text = user?.username
        if let photoImageUrl = user?.photoImageUrl{
            let photoUrl = URL(string: photoImageUrl)
            self.profileImage.sd_setImage(with: photoUrl, completed: nil)
        }
        followButton.addTarget(self, action: #selector(self.followAction), for: .touchUpInside)
        followButton.addTarget(self, action: #selector(self.unFollowAction), for: .touchUpInside)
    }
    
    @objc func followAction(){
        Api.Follow.REF_FOLLOWERS.child(user!.id!).child(Api.User.CURRENT_USER!.uid).setValue(true)
        Api.Follow.REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child(user!.id!).setValue(true)
    }
    
    @objc func unFollowAction(){
        Api.Follow.REF_FOLLOWERS.child(user!.id!).child(Api.User.CURRENT_USER!.uid).removeValue()
        Api.Follow.REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child(user!.id!).removeValue()
    }

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
