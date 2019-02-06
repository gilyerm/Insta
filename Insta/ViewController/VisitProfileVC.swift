//
//  VisitProfileVC.swift
//  Insta
//
//  Created by admin on 06/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit

class VisitProfileVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var user: User!
    var posts: [Post]! = []
    
    var uid : String?
    
    var delegate : HeaderProfileCollectionReusableViewDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let _ = uid else {return}
        print("user id =\(uid!)")
        
        fetchUser()
        fetchUserPosts()
    }
    
    func fetchUserPosts(){
        Api.UserPosts.fechUserPosts(userId: uid!) { (key) in
            Api.Post.observePost(withId: key, completion: { (post) in
                //for fast loading - kind of cache
                self.posts.append(post)
                self.collectionView.reloadData()
            })
        }
    }
    
    func fetchUser(){
        Api.User.observeUser(withId: uid!) { (user: User) in
            self.isFollowing(userId: self.uid!, completed: { (isfollowing : Bool) in
                user.isFollowing = isfollowing
                self.user = user
                self.navigationItem.title = user.username
                self.collectionView.reloadData()
            })
            
        }
    }
    func isFollowing(userId : String , completed : @escaping (Bool)->Void){
        Api.Follow.isFollowing(userId: userId, completed: completed)
    }

}

extension VisitProfileVC: UICollectionViewDataSource  //for collection view data source protocol
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        let post = posts[indexPath.row]
        cell.post = post
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderProfileCollectionReusableView", for: indexPath) as! HeaderProfileCollectionReusableView
        if let user = self.user {
            headerViewCell.user = user
            headerViewCell.delegate = self.delegate
            headerViewCell.delegateSetting = self
        }
//        headerViewCell.postCount = (String)(self.posts.count)
        // headerViewCell.updateView()
        return headerViewCell
    }
}

extension VisitProfileVC : UICollectionViewDelegateFlowLayout {
    
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

extension VisitProfileVC : HeaderProfileCollectionReusableViewDelegateSwitchSettingVC{
    func goToSettingVC() {
        performSegue(withIdentifier: "VisitProfileToSettingSegue", sender: nil)
    }
}
