//
//  SettingsTableVC.swift
//  Insta
//
//  Created by admin on 06/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit
import SDWebImage

class SettingsTableVC: UITableViewController {

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchCurrentUser()
        
        
    }
    
    func fetchCurrentUser() {
        Api.User.observeCurrentUser { (user:User) in
            self.usernameTextField.text = user.username
            self.emailTextField.text = user.email
            if let photoUrlString = user.profileImageUrl{
                let photoUrl = URL(string: photoUrlString)
                self.profileImage.sd_setImage(with: photoUrl, completed: nil)
            }
        }
    }
    
    
    @IBAction func SaveAction(_ sender: Any) {
    }
    
    @IBAction func LogoutAction(_ sender: Any) {
    }
    
}
