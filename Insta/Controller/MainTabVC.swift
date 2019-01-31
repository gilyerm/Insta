//
//  MainTabVC.swift
//  Insta
//
//  Created by gil yermiyah on 31/01/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit

class MainTabVC: UITabBarController , UITabBarControllerDelegate  {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // delegate
        self.delegate = self
     }
     
    
}
