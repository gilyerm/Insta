//
//  CommentTVCell.swift
//  Insta
//
//  Created by gil yermiyah on 03/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit

class CommentTVCell: UITableViewCell {

    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    
    var comment: Comment?{
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
        self.commentLabel.text = comment?.commentText
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
        // Initialization code
        self.nameLabel.text = ""
        self.commentLabel.text = ""
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = ""
        self.commentLabel.text = ""
        self.profileImgView.image = UIImage(named: "male-placeholder.")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}