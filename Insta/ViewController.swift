//
//  ViewController.swift
//  Insta
//
//  Created by Gil Yermiyah on 16/11/2018.
//  Copyright © 2018 Gil Yermiyah. All rights reserved.
//

import UIKit
//import Firebase
import FirebaseAuth
import FirebaseDatabase

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
        let email:String = "email@gmail.com",password:String="this is a secret";
        let userref :DatabaseReference = ref.child("users");
        
//        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
//            // ...
//            guard let user = authResult?.user else { return }
//             let url : URL = URL(fileURLWithPath: "https://firebasestorage.googleapis.com/v0/b/insta-6d60c.appspot.com/o/firebaselogo.png?alt=media&token=1442a161-eca2-4f83-9b28-e51e40085130");
//
//            let myuser:User = User(userID: user.uid, username: "username", email: user.email!, followers: ["a","b"], posts: ["1","2"], tags: ["Ω","≈"], profilepic: url, details: ["bio":"Hey","age":"no tell"])
//
//            userref.child(myuser.userID).setValue(myuser.toJson())
//        }
        
        
        if(Auth.auth().currentUser != nil)
        {
            print("User login");
            let fbuser = Auth.auth().currentUser!;
            userref.child(fbuser.uid).observeSingleEvent(of: .value, with: {
                (snapshot) in
                let value : [String: Any] = snapshot.value as! [String:Any];
                let user: User = User(json: value);
                print(user.toJson());
            })
            
        }else{
            print("User Not login");
            
            Auth.auth().signIn(withEmail: email, password: password){
                (authdataresult:AuthDataResult?,error :Error?) in
                print("User login Now");
                let fbuser = authdataresult!.user;
                userref.child(fbuser.uid).observeSingleEvent(of: .value, with: {
                    (snapshot) in
                    let value : [String: Any] = snapshot.value as! [String:Any];
                    let user: User = User(json: value);
                    print(user.toJson());
                })
                
            };
        }
        
        

        
//        ref.child("users").observe(.value, with: {
//            (snapshot) in
//            // Get user value
//            var data = [User]()
//            let value = snapshot.value as! [String:Any]
//            for (_, json) in value{
//                let usr :User = User(json: json as! [String : Any])
//                print(usr.userID)
//                data.append(usr)
//            }
//        })
    }
}

