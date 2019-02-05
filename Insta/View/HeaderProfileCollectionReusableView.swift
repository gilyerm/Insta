//
//  HeaderProfileCollectionReusableView.swift
//  Insta
//
//  Created by admin on 04/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit
class HeaderProfileCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var myPostCountLable: UILabel!
    @IBOutlet weak var myFollowerCountLable: UILabel!
    @IBOutlet weak var myFollowingCountLable: UILabel!
    
    var user: User? {
        didSet{
            updateView()
        }
    }
    
    func updateView(){
            self.nameLable.text = user!.username
            if let photoUrlString = user!.photoImageUrl{
            let photoUrl = URL(string: photoUrlString)
            self.profileImage.sd_setImage(with: photoUrl, completed: nil) //to display the photo downloaded from this URL
        }
    }
}

