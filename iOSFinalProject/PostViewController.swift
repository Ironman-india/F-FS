//
//  PostViewController.swift
//  iOSFinalProject
//
//  Created by Michael Anastasio on 12/4/18.
//  Copyright © 2018 Michael Anastasio. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class PostViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var uploadPhotoButton: UIButton!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postName: UITextField!
    @IBOutlet weak var postDescription: UITextView!
    @IBOutlet weak var postPrice: UITextField!
    var databaseRef: DatabaseReference!
    var storageRef: StorageReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postName.delegate = self
        storageRef = Storage.storage().reference()
        databaseRef = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func uploadPhoto(_ sender: Any) {
        
    }
    
    @IBAction func postItem(_ sender: Any) {
        if(postName.text != ""){
            if(postDescription.text != "" || postDescription.text != "Write a description"){
                if(postImage != nil){
                    sendPost()
                }else{
                    //alert user to add description
                }
            }else{
                //alert user to add description
            }
        }else{
            //alert user to add a username
        }
    }
    
    func sendPost(){
        let postInfo = ["description": postDescription.text, "name": postName.text, "price": postPrice.text]
        let postRef = databaseRef.child("Schools").child("NYU").child("Posts").childByAutoId()
        postRef.setValue(postInfo)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
