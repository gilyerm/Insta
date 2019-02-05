//
//  CommentVC.swift
//  Insta
//
//  Created by gil yermiyah on 03/02/2019.
//  Copyright © 2019 Gil Yermiyah. All rights reserved.
//

import UIKit
import ProgressHUD

class CommentVC: UIViewController {

   
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var constraintToButton: NSLayoutConstraint!
    
    
    var postId : String!
    var comments :[Comment] = [Comment]()
    var users :[User] = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.estimatedRowHeight = 77
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        
        empty() 
        handleTextField()
        loadComments()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    @objc func keyboardWillShow(_ notification : NSNotification){
        print(notification)
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        UIView.animate(withDuration: 0.3) {
            self.constraintToButton.constant = keyboardFrame!.height
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification : NSNotification){
        print(notification)
        UIView.animate(withDuration: 0.3) {
            self.constraintToButton.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func loadComments(){
        let postCommentRef =  Api.Post_Comment.REF_POST_COMMENTS.child(self.postId)
        
        postCommentRef.observe(.childAdded) { (snapshot) in
            print("observe key:\(snapshot.key)")
            
            Api.Comment.observeComments(withPostId: snapshot.key, completion: { (comment :Comment) in
                print("comment=\(comment.uid!)")
                self.fetchUser(uid: comment.uid!
                    , completed: {
                        self.comments.append(comment)
                        self.tableView.reloadData()
                })
            }) 
        }
    }
    
    func fetchUser(uid: String , completed : @escaping () -> Void){
        Api.User.observeUser(withId: uid) { (user) in
            self.users.append(user)
            completed()
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func handleTextField(){
        commentTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(){
        if let comment = commentTextField.text , !comment.isEmpty {
            sendButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            sendButton.isEnabled = true
            return
        }
        sendButton.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
        sendButton.isEnabled = false
    }

    
    @IBAction func sendButtonAction(_ sender: UIButton) {
        ProgressHUD.show("Sending...")
        print("send Button Action")
        let commentsReference = Api.Comment.REF_COMMENTS
        let newCommentID = commentsReference.childByAutoId().key
        let newCommentReference = commentsReference.child(newCommentID!)
        guard let currentUserId : String = Api.User.CURRENT_USER?.uid else { return }
        let comment : Comment = Comment(uid: currentUserId, commentText: commentTextField.text)
        
        newCommentReference.setValue(Comment.transformCommentToJson(comment: comment)) { (error, databaseRef) in
            if error != nil{
                ProgressHUD.showError(error.debugDescription)
                return
            }
            
            let postCommentRef =  Api.Post_Comment.REF_POST_COMMENTS.child(self.postId)
                .child(newCommentID!)
            postCommentRef.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    ProgressHUD.showError(error.debugDescription)
                    return
                }
                
            })
            
            
            self.empty()
            self.view.endEditing(true)
            ProgressHUD.showSuccess("Success")
        }
    }
    func empty(){
        self.commentTextField.text = ""
        sendButton.isEnabled = false
        sendButton.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)

    }
    
}


extension CommentVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CommentTVCell = tableView.dequeueReusableCell(withIdentifier: "CommentTVCell", for: indexPath) as! CommentTVCell
        
        let comment = self.comments[indexPath.row]
        let user = self.users[indexPath.row]
        cell.comment = comment
        cell.user = user
        return cell
    }
    
    
}
