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
    var postArray: [Post]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        storageRef = Storage.storage().reference()
        databaseRef = Database.database().reference()
        dispatchGroup = DispatchGroup()
        self.title = "NYU"
    
        loadData()
    }
    
    func loadData(){
        
        postArray = Array()
        
        for _ in 1...30 {
            let testPost = Post()
            postArray.append(testPost)
        }
        
        let newestRef = databaseRef.child("Schools").child("NYU").child("Posts").queryLimited(toLast: 30)
        dispatchGroup.enter()
        newestRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            //self.newestPostNum = snapshot.value as? String
            let dict = snapshot.value as! Dictionary<String, Any>
            var count = 0
            for(_, value) in dict {
                let postDict = value as! Dictionary<String, String>
                self.postArray[count].name = postDict["name"]
                self.postArray[count].description = postDict["description"]
                self.postArray[count].email = postDict["email"]
                self.postArray[count].price = postDict["price"]
                self.postArray[count].setImage(url: postDict["imageUrl"]!)
                count += 1
            }
            self.dispatchGroup.leave()
        }) { (error) in
            print(error.localizedDescription)
        }
        
        dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func refreshPosts(_ sender: Any) {
        loadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        
        let post = postArray![indexPath.row]
        postArray[indexPath.row].indexPath = indexPath
        cell.postName.text = post.name
        cell.postPrice.text = post.price
        cell.postDescription.text = post.description
        cell.postImage.image = post.image
        return cell
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
