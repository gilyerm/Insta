//
//  signInVC.swift
//  Insta
//
//  Created by admin on 29/01/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit

class signInVC: UIViewController {

    
    //images
    @IBOutlet weak var logoImage: UIImageView!
    
    //textFields
    @IBOutlet weak var usernameTxt: UITextField!
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
    }
    
    @IBAction func signUpBtn_click(_ sender: Any) {
        print("sign up pressed")
    }
    
}
