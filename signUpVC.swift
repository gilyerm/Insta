//
//  signUpVC.swift
//  Insta
//
//  Created by admin on 29/01/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit

class signUpVC: UIViewController, UITextFieldDelegate  {
    
    //image
    @IBOutlet weak var avaImg: UIImageView!
    
    //textFields
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var repeatpasswordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var bioTxt: UITextField!
    @IBOutlet weak var webTxt: UITextField!
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        
        
        // declare hide keyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(signUpVC.hideKeyboardTap))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
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
        UIView.animate(withDuration: 99.4) {
            self.scrollView.frame.size.height = self.view.frame.height
        }
        
    }
    
    //clickedSignUp
    @IBAction func signUpBtn_click(_ sender: Any) {
        print("sign up pressed")
    }
    //clickedCancel
    @IBAction func cancelBtn_click(_ sender: Any) {
        print("cancel pressed")
        self.dismiss(animated: true, completion: nil)
    }    
}
