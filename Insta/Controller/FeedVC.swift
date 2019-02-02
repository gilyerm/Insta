//
//  FeedVC.swift
//  Insta
//
//  Created by gil yermiyah on 31/01/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
    }

    
    @IBAction func handleLogout(_ sender: Any) {
        print("handle Logout here...")
        // declare alert controller
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        // add alert log out  action
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do{
                // attempt sign out
                try Auth.auth().signOut()
                // present login controller
                let storyboard = UIStoryboard(name: "Log", bundle: nil)
                let signInVC = storyboard.instantiateViewController(withIdentifier: "signInVC")
                self.present(signInVC, animated: true, completion: nil)

                print("Successfull logged out")
            } catch{
                // handle error
                print("failed to sign out")
                
            }
        }))
        // add cancel action
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
}
