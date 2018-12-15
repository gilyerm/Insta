//
// Created by admin on 15/12/2018.
// Copyright (c) 2018 Gil Yermiyah. All rights reserved.
//

import Foundation
import FirebaseAuth

extension ModelFirebase {

    lazy let auth : Auth = Auth.auth();

    func Login(email:String,password :String) ->Bool {
        auth.signIn(withEmail: email, password: password){
            (authdataresult:AuthDataResult?,error :Error?) in
            if error != nil {
                print(error!);
            }else{
                let fbuser = authdataresult!.user;
                userref.child(fbuser.uid).observeSingleEvent(of: .value, with: {
                    (snapshot) in
                    let value : [String: Any] = snapshot.value as! [String:Any];
                    let user: User = User(json: value);
                    print(user.toJson());
                })
            }
        };
    }

    func Register(email:String,password :String){
        auth.createUser(withEmail: email, password: password) {
            (authdataresult: AuthDataResult?, error: Error?) in
            if (error! = nil){
                print(error!);
            }
            else{
                let fbUser = authdataresult!.user;
                let myUser:User = User(userID: fbUser.uid, email: fbUser.email);
                self.addNewUser(user: myUser);
            }
        }
    }


}
