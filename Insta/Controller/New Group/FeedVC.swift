//
//  FeedVC.swift
//  Insta
//
//  Created by gil yermiyah on 31/01/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

private let reuseIdentifier = "Cell"

class FeedVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    
    var posts :[Post] = [Post]()
    var users :[User] = [User]()
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 521
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        
        loadPosts()
    }
    
    func loadPosts(){
        
        activityIndicatorView.startAnimating()
        
        Api.Post .observePosts { (post) in
            self.fetchUser(uid: post.uid!
                , completed: {
                    self.posts.append(post)
                    self.activityIndicatorView.stopAnimating()
                    self.tableView.reloadData()
            })
        }
       
    }
    
    func fetchUser(uid: String , completed : @escaping () -> Void){
        Api.User.observeUser(withId: uid) { (user) in
            self.users.append(user)
            completed()
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue.identifier =\(String(describing: segue.identifier))")
        if segue.identifier == "commentSeque"{
            let commentVC = segue.destination as! CommentVC
            let postId = sender as! String
            commentVC.postId = postId
            print("postId=\(postId)")
            
        }
    }
}

extension FeedVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : FeedCellVC = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! FeedCellVC
        
        let post = self.posts[indexPath.row]
        let user = self.users[indexPath.row]
        cell.post = post
        cell.user = user
        cell.feedVC = self
        return cell
    }
    
    
}
