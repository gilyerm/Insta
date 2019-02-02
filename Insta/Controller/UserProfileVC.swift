 //
//  UserProfileVC.swift
//  Insta
//
//  Created by gil yermiyah on 31/01/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit
import Firebase
 
private let reuseIdentifier = "Cell"
private let headerIdentifier = "HeaderView"
 
 
class UserProfileVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var navbar: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        
        
        self.collectionView?.backgroundColor = .white
        //fetch user data
        fetchCurrentUserData()

    }
//
//
//    // MARK: UICollectionViewDataSource
//
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: view.frame.width, height: 200)
//    }
//
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier, for: indexPath) as? HeaderView ?? HeaderView()
        
//        header.fullnameLbl.text = Auth.auth().currentUser?.email
        
        /**
         
         TODO:: enter user profile here
  
         **/
        
        //header.button.setTitle("edit profile", for: .n)
        
        
        
        return header
    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
//
//        return cell
//    }

    // MARK: API
    
    func fetchCurrentUserData(){
        guard let currentId = Auth.auth().currentUser?.uid else {return}
        print("Current User ID is: \(currentId)")
        Database.database().reference().child("users").child(currentId).child("username").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let username = snapshot.value as? String else {return}
            self.navbar.title = username
        })
    }
 }
