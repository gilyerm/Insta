//
//  ViewController.swift
//  Insta
//
//  Created by Gil Yermiyah on 16/11/2018.
//  Copyright © 2018 Gil Yermiyah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    var userListener:NSObjectProtocol?
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        userListener = ModelNotification.userListNotification.observe(){
            (data:Any) in
            print("get data!!!")
            let data = data as! [User]
            print("data size : \(data.count)")
            data.forEach({ (user : User) in
                print("userID= \(user.userID)")
            })
            self.activityIndicator.stopAnimating();
        }
        
        activityIndicator.center = self.view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.color = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1);
        view.addSubview(activityIndicator);
        
        activityIndicator.startAnimating();
        Model.instance.getAllUsers()
        
        
    }
    
    deinit{
        if userListener != nil{
            ModelNotification.userListNotification.remove(observer: userListener!)
        }
    }
}

