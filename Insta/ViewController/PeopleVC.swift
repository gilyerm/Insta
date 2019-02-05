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
            self.users.append(user)
            self.tableView.reloadData()
        }
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
