//
//  signInVC.swift
//  Insta
//
//  Created by admin on 29/01/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit
import Firebase

class signInVC: UIViewController {

    
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

    }
    @IBAction func signInBtn_click(_ sender: Any) {
        print("sign in pressed")
        
        // properties
        guard
            let email = emailTxt.text,
            let password = passwordTxt.text
                else {return}
        
        // sign user in with email and password
    
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            // handle error
            if let error = error {
                print("Unable to sign user in with error",separator: error.localizedDescription)
                return
            }
            
            // handle sucsses
            print("Successfully signed user in" )
            
            let mainTabVC = MainTabVC()
            
            self.present(mainTabVC, animated:  true, completion: nil)
        }
    }
    
    @IBAction func signUpBtn_click(_ sender: Any) {
        print("sign up pressed")
    }

    @IBAction func formValidation(_ sender: Any) {
        print("Editing did change")
        
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
    
}
