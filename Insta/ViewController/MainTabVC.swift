//
//  MainTabVC.swift
//  Insta
//
//  Created by gil yermiyah on 31/01/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MainTabVC: UITabBarController , UITabBarControllerDelegate  {

    
    override func viewDidLoad() {
        // user validation
        checkIfUserIsLoggedIn()
        
        super.viewDidLoad()
        
        
        // delegate
        self.delegate = self
        
       
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if snapshot.value as? Bool ?? false {
                print("Connected")
            } else {
                print("Not connected")
            }
        })
        
     }

    func checkIfUserIsLoggedIn() {
        if Api.User.CURRENT_USER == nil {
            print("no current User")
            DispatchQueue.main.async {
                // present login controller
                let storyboard = UIStoryboard(name: "Log", bundle: nil)
                let signInVC = storyboard.instantiateViewController(withIdentifier: "signInVC")
                self.present(signInVC, animated: true, completion: nil)
            }
            return 
        } else {
            print("User is logged in")
        }
        
    }
    
}
