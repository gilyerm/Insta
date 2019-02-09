//
//  CommentTVCell.swift
//  Insta
//
//  Created by gil yermiyah on 03/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit

protocol CommentTVCellDelegate {
    func goToProfileVC(userId: String)
}

class CommentTVCell: UITableViewCell {

    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    var delegate : CommentTVCellDelegate?
    
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
        if let photoUrlString = user!.profileImageUrl{
//            let photoUrl = URL(string: photoUrlString)
//            self.profileImgView.sd_setImage(with: photoUrl, completed: nil)
            Model.instance.getImage(url: photoUrlString) { (uiimage : UIImage?) in
                self.profileImgView.image = uiimage
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.nameLabel.text = ""
        self.commentLabel.text = ""
        
        let tapGestureNamelabel = UITapGestureRecognizer(target: self, action: #selector(self.nameLabelAction))
        nameLabel.addGestureRecognizer(tapGestureNamelabel)
        nameLabel.isUserInteractionEnabled = true
    }
    
    @objc func nameLabelAction(){
        if let id = user?.id{
            delegate?.goToProfileVC(userId: id)
        }
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
