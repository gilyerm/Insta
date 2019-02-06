//
//  UserProfileVC.swift
//  Insta
//
//  Created by gil yermiyah on 04/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit
class UserProfileVC: UIViewController {
  
    @IBOutlet weak var collectionView: UICollectionView!
    var user: User!
    var posts: [Post]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchUser()
        fetchUserPosts()
    }
    
    func fetchUserPosts(){ //profile vc shouldnt work directly with the DB so it will send it to UserPostApi
        guard let currentUser = Api.User.CURRENT_USER else {return}
        
        Api.UserPosts.REF_USER_POSTS.child(currentUser.uid).observe(.childAdded) { (snapshot) in
            print(snapshot)
            Api.Post.observePost(withId: snapshot.key, completion: { (post) in
                    //for fast loading - kind of cache
                self.posts.append(post)
                self.collectionView.reloadData()
            })
        }
    }
    
    func fetchUser(){
        Api.User.observeCurrentUser{ (user) in
            self.user = user
            self.navigationItem.title = user.username
            self.collectionView.reloadData()
          }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue.identifier =\(String(describing: segue.identifier))")
        if segue.identifier == "ProfileToSettingSegue"{
            let settingsTableVC = segue.destination as! SettingsTableVC
            settingsTableVC.delegate = self
        }
        if segue.identifier == "ProfileToDetailSegue"{
            let detailVC = segue.destination as! DetailVC
            let postId = sender as! String
            detailVC.postId = postId
        }
    }
    
}


extension UserProfileVC: UICollectionViewDataSource  //for collection view data source protocol
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        guard let currentUser = Auth.auth().currentUser else {return 0}
//        print("user \(String(describing: currentUser.email)) has \(posts.count) posts")
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        let post = posts[indexPath.row]
        cell.post = post
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderProfileCollectionReusableView", for: indexPath) as! HeaderProfileCollectionReusableView
        if let user = self.user {
            headerViewCell.user = user
            headerViewCell.delegateSetting = self
        }
        
        //headerViewCell.postCount = (String)(self.posts.count)
           // headerViewCell.updateView()
        return headerViewCell
    }
}

extension UserProfileVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // space between rows
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // space between columns
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3 , height: collectionView.frame.size.width / 3)
    }
}

extension UserProfileVC : HeaderProfileCollectionReusableViewDelegateSwitchSettingVC{
    func goToSettingVC() {
        performSegue(withIdentifier: "ProfileToSettingSegue", sender: nil)
    }
}

extension UserProfileVC : SettingsTableVCDelegate{
    func updateUserInfo() {
        self.fetchUser()
    }
}

extension UserProfileVC : PhotoCollectionViewCellDelegate{
    func goToDetailVC(postId: String) {
        performSegue(withIdentifier: "ProfileToDetailSegue", sender: postId)
    }
}
