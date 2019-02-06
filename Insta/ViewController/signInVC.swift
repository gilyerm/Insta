//
//  signInVC.swift
//  Insta
//
//  Created by admin on 29/01/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit
import ProgressHUD

class signInVC: UIViewController,SignUpDelegate {
    func onComplete(success: Bool) {
        print("on Complete signInOut \(success)")
        if success {
            print("on Complete signInOut success")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: "MainTabVC")
            self.present(signInVC, animated: true, completion: nil)
//            self.dismiss(animated: true, completion: ())
        }
    }
    

    
    //images
    @IBOutlet weak var logoImage: UIImageView!
    
    //textFields
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    //buttons
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var forgotBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("at signInVC")
        
        emailTxt.delegate = self
        passwordTxt.delegate = self

    }
    @IBAction func signInBtn_click(_ sender: Any) {
        //print("sign in pressed")
        
        ProgressHUD.show("Waiting...",interaction: false)
        
        // properties
        guard
            let email = emailTxt.text,
            let password = passwordTxt.text
                else {
                    ProgressHUD.showError("fill all fields")
                    return}
        
        // sign user in with email and password
        AuthService.signIn(email: email, password: password, onSuccess: {
            print("Successfully signed user in" )
            ProgressHUD.showSuccess("Success")
            self.onComplete(success: true)
            //self.dismiss(animated: true, completion: nil )
        }) { (errorMsg) in
            print(errorMsg!)
            ProgressHUD.showError(errorMsg!)
            return
        }
    }
    
    @IBAction func signUpBtn_click(_ sender: Any) {
        //print("sign up pressed")
    }

    @IBAction func formValidation(_ sender: Any) {
        //print("Editing did change")
        
        // ensures that email and password text fields have text
        guard
            emailTxt.hasText,
            passwordTxt.hasText else {
                //handle case for above conditions not met
                signInBtn.isEnabled = false
                signInBtn.backgroundColor =  UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
                return
        }
        //handle case for above conditions were met
        signInBtn.isEnabled = true
        signInBtn.backgroundColor =   UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUpID" {
            let vc:signUpVC = segue.destination as! signUpVC
            vc.delegate = self;
        }
    }
}

extension signInVC : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
