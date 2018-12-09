//
//  FeedViewController.swift
//  iOSFinalProject
//
//  Created by Michael Anastasio on 12/3/18.
//  Copyright © 2018 Michael Anastasio. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var dispatchGroup: DispatchGroup!
    var databaseRef: DatabaseReference!
    var storageRef: StorageReference!
    var postArray = [Post]()
    var sendingPost: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        storageRef = Storage.storage().reference()
        databaseRef = Database.database().reference()
        dispatchGroup = DispatchGroup()
        self.title = Auth.auth().currentUser?.displayName
        loadPosts()
        //loadData()
    }
    
    func loadPosts() {
        databaseRef.child("Schools").child((Auth.auth().currentUser?.displayName)!).child("Posts").observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let name = dict["name"] as! String
                let description = dict["description"] as! String
                //let email = dict["email"] as! String
                let price = dict["price"] as! String
                let imageUrl = dict["imageUrl"] as! String
                let storRef = Storage.storage().reference(forURL: imageUrl)
                storRef.getData(maxSize: 1*2560*2560) { (data, error) in
                    if error == nil {
                        let image = UIImage(data: data!)
                        let post = Post(n: name, d: description, p: price, e: "", im: image!)
                        self.postArray.append(post)
                        self.tableView.reloadData()
                    }else{
                        print(error?.localizedDescription ?? "")
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        sendingPost = postArray[indexPath.row]
        self.performSegue(withIdentifier: "FeedPostSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        
        let post = postArray[indexPath.row]
        cell.postName.text = post.name
        cell.postPrice.text = post.price
        cell.postDescription.text = post.description
        cell.postImage.image = post.image
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ViewPostViewController {
            vc.post = sendingPost
            vc.name = sendingPost.name
            vc.price = sendingPost.price
            vc.desc = sendingPost.description
            vc.image = sendingPost.image
        }
    }
}




/*dispatchGroup.notify(queue: .main) {
 let postRef = Int(self.newestPostNum!)! - indexPath.row
 let stringRef = String(postRef)
 if let cellImage = self.imageDictionary[stringRef] {
 cell.postImage.image = cellImage
 if cell.postDescription.text != self.descriptionDictionary[stringRef] {
 cell.postDescription.text = self.descriptionDictionary[stringRef]
 }
 }else{
 //cell.postImage.image = UIImage(named: "EmptyPhoto.jpg")
 let group = DispatchGroup()
 cell.group = group
 cell.number = indexPath.row
 cell.hasGottenPost = false
 cell.getPost(postReference: stringRef)
 group.notify(queue: .main, execute: {
 self.imageDictionary[stringRef] = cell.postImage.image
 self.descriptionDictionary[stringRef] = cell.postDescription.text
 })
 
 }
 }*/
