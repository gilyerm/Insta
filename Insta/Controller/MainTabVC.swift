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
        // user validation
        checkIfUserIsLoggedIn()
        
        super.viewDidLoad()
        
        
        // delegate
        self.delegate = self
        
       
        
     }
    
    
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            print("no current User")
            DispatchQueue.main.async {
                // present login controller
                let loginVC = signInVC()
                let navController = UINavigationController(rootViewController: loginVC)
                self.present(navController, animated: true, completion: nil ) 
            }
            return 
        } else {
            print("User is logged in")
        }
        
    }
    
}
