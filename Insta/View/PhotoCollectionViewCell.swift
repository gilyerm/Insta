//
//  PhotoCollectionViewCell.swift
//  Insta
//
//  Created by admin on 05/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit

protocol PhotoCollectionViewCellDelegate {
    func goToDetailVC(postId: String)
}

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    
    var delegate: PhotoCollectionViewCellDelegate?
    
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
        
        let tapGestureForPhoto = UITapGestureRecognizer(target: self, action: #selector(self.photoTouchUp))
        photo.addGestureRecognizer(tapGestureForPhoto)
        photo.isUserInteractionEnabled = true
    }
    
    @objc func photoTouchUp(){
        if let id = post?.id{
            delegate?.goToDetailVC(postId: id)
        }
    }
    
    
}
