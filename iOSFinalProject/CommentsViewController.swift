//
//  CommentsViewController.swift
//  iOSFinalProject
//
//  Created by Michael Anastasio on 12/9/18.
//  Copyright © 2018 Michael Anastasio. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    var itemName:String!
    var commentArray = [Comment]()
    var postKey: String!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentText: UITextField!
    
    var dbRef: DatabaseQuery!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        commentText.delegate = self
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = itemName
        
        dbRef = Database.database().reference().child("Schools").child((Auth.auth().currentUser?.displayName)!).child("Posts").queryOrdered(byChild: "name").queryEqual(toValue: itemName)
        dbRef.observeSingleEvent(of: .value) { (snapshot) in
            print("asdfasdfasdfasdfsa")
            //print(snapshot.value)
            if let dict = snapshot.value as? Dictionary<String, Any>{
                print(dict)
                print(dict.keys)
                self.postKey = dict.keys.first
                let newRef = Database.database().reference().child("Schools").child((Auth.auth().currentUser?.displayName)!).child("Posts").child(self.postKey).child("comments")
                newRef.observe(.childAdded, with: { (snapshot) in
                    if let dict = snapshot.value as? Dictionary<String, Any> {
                        let text = dict["text"] as! String
                        let user = dict["user"] as! String
                        let comment = Comment(com: text, use: user)
                        self.commentArray.append(comment)
                        self.tableView.reloadData()
                    }
                })
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dbRef.removeAllObservers()
    }
    
    @IBAction func sendComment(_ sender: Any) {
        postComment()
    }
    
    func postComment() {
        let commentInfo = ["text": commentText.text!, "user": (Auth.auth().currentUser?.email)!] as [String : Any]
        
        let commentRef = Database.database().reference().child("Schools").child((Auth.auth().currentUser?.displayName)!).child("Posts").child(self.postKey).child("comments").childByAutoId()
        commentRef.setValue(commentInfo)
        self.commentText.text = ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        
        let comment = commentArray[indexPath.row]
        
        cell.commentText.text = comment.comment
        cell.userText.text = comment.user
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y -= 250
        }
    }
    
    func  textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y += 250
        }
        self.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        postComment()
        commentText.resignFirstResponder()
        return true
    }
}
