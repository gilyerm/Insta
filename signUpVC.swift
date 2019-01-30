//
//  signUpVC.swift
//  Insta
//
//  Created by admin on 29/01/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit
import Firebase

class signUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    //image
    @IBOutlet weak var avaImg: UIImageView!
    
    //textFields
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var repeatpasswordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var bioTxt: UITextField!
    
    //scrollView
    @IBOutlet weak var scrollView: UIScrollView!
  
    //reset default size
    var scrollViewHeight : CGFloat = 0
    
    //keyboard frame size
    var keyboard = CGRect()
    
    //buttons
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //scrollview frame size
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = scrollView.frame.size.height
        
        //check notification if keyboard is shown or not
        NotificationCenter.default.addObserver(self, selector: #selector(signUpVC.showKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
       
        NotificationCenter.default.addObserver(self, selector: #selector(signUpVC.hideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        // declare hide keyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(signUpVC.hideKeyboardTap))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        //round image
        avaImg.layer.cornerRadius = avaImg.frame.width/2
        avaImg.clipsToBounds = true
        
        //declare select image tap
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(signUpVC.loadImg(recognizer:)))
        avaTap.numberOfTapsRequired = 1
        avaImg.isUserInteractionEnabled = true
        avaImg.addGestureRecognizer(avaTap)

    }
    
    //calling picker to select image
    @objc func loadImg(recognizer: UITapGestureRecognizer){
        let picker = UIImagePickerController()
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate //current vc
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    //Connect selected image to our image view
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("imagepickercontroller")
        avaImg.image = (info[UIImagePickerController.InfoKey.editedImage]! as! UIImage)
        //picker.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    // hide keyboard if tapped
    @objc func hideKeyboardTap(recoginizer : UITapGestureRecognizer){
        print("hideKeyboardTap")
        self.view.endEditing(true)
    }
    
    // show keyboard
    @objc func showKeyboard(notification: NSNotification){
        print("showKeyboard")
        print(notification.name)
        // define keyboard size
        keyboard = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        // move up UI
        UIView.animate(withDuration: 0.4) {
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.height
        }
    }
    
    // hide keyboard func
    @objc func hideKeyboard(notification: NSNotification){
        print("hideKeyboard")
        print(notification.name)
        // move down UI
        UIView.animate(withDuration: 0.4) {
            self.scrollView.frame.size.height = self.view.frame.height
        }
        
    }
    
    //clickedSignUp
    @IBAction func signUpBtn_click(_ sender: Any) {
        print("sign up pressed")
        
        //dismiss keyboard
        self.view.endEditing(true)
        
        //case fields are empty
        if(usernameTxt.text == "" || passwordTxt.text == "" || repeatpasswordTxt.text == "" || usernameTxt.text == "" || emailTxt.text == ""){
            
            // alert message "fill all fields"
            let alert = UIAlertController(title: "PLEASE", message: "fill all fields", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        //case different password
        if passwordTxt.text != repeatpasswordTxt.text{
            //alert message
            let alert = UIAlertController(title: "PASSWORD", message: "do not match", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
            guard let email = emailTxt.text else {return}
            guard let password = passwordTxt.text else {return}
            print("email is: \(email) and password is: \(password)")
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            //handle error
            if let error = error {
                print("Failed to creat user with error: ", error.localizedDescription)
                return
            }
            
            //success
            print("Successfully created user with Firebase")
        }
        }

    
    //clickedCancel
    @IBAction func cancelBtn_click(_ sender: Any) {
        print("cancel pressed")
        self.dismiss(animated: true, completion: nil)
    }
}

