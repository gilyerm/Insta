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
    
    var postsUsers : [Post: User] = [Post: User]()
    
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
                , completed: { user in
                    self.postsUsers.updateValue(user, forKey: post)

                    self.activityIndicatorView.stopAnimating()
                    self.tableView.reloadData()
            })
        }
        
        Api.Feed.observeFeedRemove(withId: Api.User.CURRENT_USER!.uid) { (post : Post) in
    
            self.postsUsers = self.postsUsers.filter({ (arg0) -> Bool in
                let (post1, _) = arg0
                return post1.id != post.id
            }).filter({ (arg0) -> Bool in
                let (_, user1) = arg0
                return user1.id != post.uid
            }).toDictionary(byTransforming: { (arg0) -> (Post, User) in
                return arg0
            })
            self.tableView.reloadData()
        }
       
    }
    
    func fetchUser(uid: String , completed : @escaping (User) -> Void){
        Api.User.observeUser(withId: uid) { (user) in
            completed(user)
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
//        return self.posts.count
        return self.postsUsers.values.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : FeedCellVC = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! FeedCellVC
        
        let sortarr = self.postsUsers.sorted(by: { (arg0, arg1) -> Bool in
            let (post1, _) = arg0
            let (post2, _) = arg1
            return post1.createAt! > post2.createAt!
        })
        
        let post = sortarr[indexPath.row].key
        let user = sortarr[indexPath.row].value
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






extension Array
{
    func toDictionary<H:Hashable, T>(byTransforming transformer: (Element) -> (H, T)) -> Dictionary<H, T>
    {
        var result = Dictionary<H,T>()
        self.forEach({ element in
            let (key,value) = transformer(element)
            result[key] = value
        })
        return result
    }
}
