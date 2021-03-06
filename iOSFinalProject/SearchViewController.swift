//
//  SearchViewController.swift
//  iOSFinalProject
//
//  Created by Michael Anastasio on 12/3/18.
//  Copyright © 2018 Michael Anastasio. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    var databaseRef: DatabaseReference!
    var sendingPost:Post!
    var postArray = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        databaseRef = Database.database().reference()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        postArray = [Post]()
        tableView.reloadData()
        loadPosts()
        searchBar.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchBar.selectAll(self)
    }
    
    /*func  textFieldDidEndEditing(_ textField: UITextField) {
        postArray = [Post]()
        tableView.reloadData()
        loadPosts()
        searchBar.resignFirstResponder()
    }*/
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        postArray = [Post]()
        tableView.reloadData()
        loadPosts()
        searchBar.resignFirstResponder()
        return true
    }
    

    func loadPosts() {
        databaseRef.child("Schools").child((Auth.auth().currentUser?.displayName)!).child("Posts").queryOrdered(byChild: "name").queryEqual(toValue: searchBar.text).observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let name = dict["name"] as! String
                let description = dict["description"] as! String
                //let email = dict["email"] as! String
                let price = dict["price"] as! String
                let imageUrl = dict["imageUrl"] as! String
                let email = dict["email"] as? String ?? ""
                let storRef = Storage.storage().reference(forURL: imageUrl)
                storRef.getData(maxSize: 1*2560*2560) { (data, error) in
                    if error == nil {
                        let image = UIImage(data: data!)
                        let post = Post(n: name, d: description, p: price, e: email, im: image!)
                        self.postArray.append(post)
                        self.tableView.reloadData()
                    }else{
                        print(error?.localizedDescription ?? "")
                    }
                }
            }
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        sendingPost = postArray[indexPath.row]
        self.performSegue(withIdentifier: "SearchPostSegue", sender: self)
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
