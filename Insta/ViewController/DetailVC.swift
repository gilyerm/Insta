 //
//  DetailVC.swift
//  Insta
//
//  Created by admin on 06/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

    var postId = ""
    var post = Post()
    var user = User()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPost()
    }
    
    func loadPost(){
        Api.Post.observePost(withId: postId) { (post : Post) in
            guard let postUid = post.uid else {return}
            self.fetchUser(uid: postUid, completed: {
                self.post = post
                self.tableView.reloadData()
            })
        }
    }
    
    func fetchUser(uid: String , completed : @escaping () -> Void){
        Api.User.observeUser(withId: uid) { (user) in
            self.user = user
            completed()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue.identifier =\(String(describing: segue.identifier))")
        if segue.identifier == "DetailToCommentSegue"{
            let commentVC = segue.destination as! CommentVC
            let postId = sender as! String
            commentVC.postId = postId
            print("postId=\(postId)")
            
        }
        if segue.identifier == "DetailToProfileSegue"{
            let visitProfileVC = segue.destination as! VisitProfileVC
            let userId = sender as! String
            visitProfileVC.uid = userId
            print("userId=\(userId)")
            
        }
    }
    
}

 
 extension DetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : FeedCellVC = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! FeedCellVC
        cell.post = post
        cell.user = user
        cell.delegate = self
        return cell
    }
    
    
 }

 
 extension DetailVC : FeedCellVCDelegate{
    func goToProfileVC(userId: String) {
        self.performSegue(withIdentifier: "DetailToProfileSegue", sender: userId)
    }
    
    func goToCommentVC(postId: String) {
        self.performSegue(withIdentifier: "DetailToCommentSegue", sender: postId)
    }
 }

