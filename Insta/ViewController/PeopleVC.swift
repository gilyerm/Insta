//
//  PeopleVC.swift
//  Insta
//
//  Created by admin on 05/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit

class PeopleVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        loadUsers()
    }
    
    
    func loadUsers(){
        Api.User.observeUsers { (user: User) in
            if Api.User.CURRENT_USER!.uid != user.id{
                self.isFollowing(userId: user.id!, completed: { (isfollowing:Bool) in
                    user.isFollowing = isfollowing
                    self.users.append(user)
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    func isFollowing(userId : String , completed : @escaping (Bool)->Void){
        Api.Follow.isFollowing(userId: userId, completed: completed)
    }
    
}

extension PeopleVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! PeopleTableViewCell
 
        cell.user = users[indexPath.row]
        
        return cell
    }
    
    
}
