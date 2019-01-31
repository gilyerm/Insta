//
//  MainTabVC.swift
//  Insta
//
//  Created by gil yermiyah on 31/01/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit
import Firebase

class MainTabVC: UITabBarController , UITabBarControllerDelegate  {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // delegate
        self.delegate = self
        
        // user validation
        checkIfUserIsLoggedIn()
        
     }
    
    
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            print("no current User")
        } else {
            print("User is logged in")
        }
    }
    
}
