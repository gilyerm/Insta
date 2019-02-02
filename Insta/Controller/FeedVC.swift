//
//  FeedVC.swift
//  Insta
//
//  Created by gil yermiyah on 31/01/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class FeedVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    
    var posts :[Post] = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        
        loadPosts()
    }

    func loadPosts(){
        
        
        Database.database().reference().child("posts").observe(.childAdded) { (snapshot:DataSnapshot) in
            if let dict = snapshot.value as? [String:Any] {
                 print(dict)
                let post : Post = Post(json: dict)
                self.posts.append(post)
                self.tableView.reloadData()
            }
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
}

extension FeedVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        //cell.textLabel?.text = "\(indexPath.row)"
        cell.backgroundColor = UIColor.red
        
        cell.textLabel?.text = self.posts[indexPath.row].caption
        return cell
    }
    
    
}
