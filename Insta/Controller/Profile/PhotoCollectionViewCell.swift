//
//  PhotoCollectionViewCell.swift
//  Insta
//
//  Created by admin on 05/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    
    var post : Post?{
        didSet{
            updateView()
        }
    }
    
    
    func updateView(){
        if let photoUrlString = post?.photoUrl{
            let photoUrl = URL(string: photoUrlString)
            self.photo.sd_setImage(with: photoUrl, completed: nil)
        }
    }
    
}
