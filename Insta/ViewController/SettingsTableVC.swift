//
//  SettingsTableVC.swift
//  Insta
//
//  Created by admin on 06/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit
import SDWebImage
import ProgressHUD

protocol SettingsTableVCDelegate {
    func updateUserInfo()
}

class SettingsTableVC: UITableViewController {

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    var delegate : SettingsTableVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchCurrentUser()
        usernameTextField.delegate = self
        emailTextField.delegate = self
    }
    
    func fetchCurrentUser() {
        Api.User.observeCurrentUser { (user:User) in
            self.usernameTextField.text = user.username
            self.emailTextField.text = user.email
            if let photoUrlString = user.profileImageUrl{
                //let photoUrl = URL(string: photoUrlString)
                //self.profileImage.sd_setImage(with: photoUrl, completed: nil)
                Model.instance.getImage(url: photoUrlString) { (uiimage : UIImage?) in
                    self.profileImage.image = uiimage
                }
            }
        }
    }
    
    
    @IBAction func SaveAction(_ sender: Any) {
        if let profileImg = self.profileImage.image , let imageData = profileImg.jpegData(compressionQuality: 0.1){
            ProgressHUD.show("Updating...")
            AuthService.updateUserInfo(username: self.usernameTextField.text!, email: self.emailTextField.text!, imageData: imageData, onSuccess: {
                ProgressHUD.showSuccess("User Profile Updated Successfully")
                self.delegate?.updateUserInfo()
            }) { (errorMsg) in
                ProgressHUD.showError(errorMsg)
            }
        }
    }
    
    @IBAction func LogoutAction(_ sender: Any) {
        print("handle Logout here...")
        // declare alert controller
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        // add alert log out  action
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            // attempt sign out
            AuthService.logout(onSuccess: {
                // present login controller
                let storyboard = UIStoryboard(name: "Log", bundle: nil)
                let signInVC = storyboard.instantiateViewController(withIdentifier: "signInVC")
                self.present(signInVC, animated: true, completion: nil)
                
                print("Successfull logged out")
            }, onError: { (errorMsg) in
                ProgressHUD.showError(errorMsg)
            })
        }))
        // add cancel action
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func changeProfilePhotoAction(_ sender: Any) {
        let pickercontroller = UIImagePickerController()
        pickercontroller.delegate = self
        present(pickercontroller, animated: true, completion: nil)
    }
}

extension SettingsTableVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

extension SettingsTableVC : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
