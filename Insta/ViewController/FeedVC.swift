//
//  FeedVC.swift
//  Insta
//
//  Created by gil yermiyah on 31/01/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit
import SDWebImage
import ProgressHUD

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
        guard let currentUser = Api.User.CURRENT_USER else {return}
        activityIndicatorView.startAnimating()
        Api.Feed.observeFeed(withId: currentUser.uid) { (post :Post) in
            guard let uid = post.uid else {
                return
            }
            self.fetchUser(uid: uid
                , completed: {
                    self.posts.insert(post, at: 0)
                    self.posts = self.posts.sorted(by: { (post1, post2) -> Bool in /// sort post by date
                        return post1.createAt! > post2.createAt!
                    })
                    self.activityIndicatorView.stopAnimating()
                    self.tableView.reloadData()
            })
        }
        
        Api.Feed.observeFeedRemove(withId: Api.User.CURRENT_USER!.uid) { (post : Post) in
            self.posts = self.posts.filter({ (post1:Post) -> Bool in
                return post1.id != post.id
            })
            self.users = self.users.filter({ (user:User) -> Bool in
                return user.id != post.uid
            })
            self.tableView.reloadData()
        }
       
    }
    
    func fetchUser(uid: String , completed : @escaping () -> Void){
        Api.User.observeUser(withId: uid) { (user) in
            self.users.insert(user, at: 0)
            completed()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue.identifier =\(String(describing: segue.identifier))")
        if segue.identifier == "commentSeque"{
            let commentVC = segue.destination as! CommentVC
            let postId = sender as! String
            commentVC.postId = postId
            print("postId=\(postId)")
            
        }
        if segue.identifier == "HomeToProfileSegue"{
            let visitProfileVC = segue.destination as! VisitProfileVC
            let userId = sender as! String
            visitProfileVC.uid = userId
            print("userId=\(userId)")
            
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
        cell.delegate = self
        return cell
    }
}

extension FeedVC : FeedCellVCDelegate{
    func goToProfileVC(userId: String) {
        self.performSegue(withIdentifier: "HomeToProfileSegue", sender: userId)
    }
    
    func goToCommentVC(postId: String) {
        self.performSegue(withIdentifier: "commentSeque", sender: postId)
    }
}
