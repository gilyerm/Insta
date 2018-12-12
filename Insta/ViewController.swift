//
//  ViewController.swift
//  Insta
//
//  Created by Gil Yermiyah on 16/11/2018.
//  Copyright © 2018 Gil Yermiyah. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        FirebaseApp.configure()
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
    
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if snapshot.value as? Bool ?? false {
                print("Connected")
            } else {
                print("Not connected")
            }
        })
        var email:String = "fs",password:String="adaw";
        var userid:String = "";
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            // ...
            guard let user = authResult?.user else { return }
            userid = user.providerID
            
        }
        
        let url : URL = URL(fileURLWithPath: "https://firebasestorage.googleapis.com/v0/b/insta-6d60c.appspot.com/o/firebaselogo.png?alt=media&token=1442a161-eca2-4f83-9b28-e51e40085130");
        
        let user:User = User(userID: userid, username: "username", password: "password", followers: ["a","b"], posts: ["1","2"], tags: ["Ω","≈"], profilepic: url, details: ["bio":"Hey","age":"no tell"])

        ref.child("users").child(user.userID).setValue(user.toJson())
        ref.child("users").observe(.value, with: {
            (snapshot) in
            // Get user value
            var data = [User]()
            let value = snapshot.value as! [String:Any]
            for (_, json) in value{
                let usr :User = User(json: json as! [String : Any])
                print(usr.userID)
                data.append(usr)
            }
        })
    }
}

