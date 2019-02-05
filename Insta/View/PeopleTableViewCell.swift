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
