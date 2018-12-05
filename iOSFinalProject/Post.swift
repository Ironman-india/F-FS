//
//  Post.swift
//  iOSFinalProject
//
//  Created by Michael Anastasio on 12/4/18.
//  Copyright © 2018 Michael Anastasio. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class Post {
    
    var name: String!
    var description: String!
    var imageUrl: String!
    var image: UIImage!
    var price: String!
    var email: String!
    var storage: Storage!
    var storageRef: StorageReference!
    var indexPath: IndexPath!
    
    init() {
        name = ""
        description = ""
        imageUrl = ""
        //image = UIImage(named: "camera.png")
        price = ""
        email = ""
        storage = Storage.storage()
        //let url = "https://firebasestorage.googleapis.com/v0/b/freeandforsale-d7f0f.appspot.com/o/scooter.png?alt=media&token=c85aa5c1-58ff-4329-ac0d-bc2c2b50008a"
        //setImage(url: url)
    }
    
    init(n:String, d:String, p: String, e: String){
        name = n
        description = d
        imageUrl = ""
        //image = UIImage(named: "camera.png")
        price = p
        email = e
        storage = Storage.storage()
    }
    
    func setImage(url: String){
        storageRef = storage.reference(forURL: url)
        storageRef.getData(maxSize: 1*2048*2048) { (data, error) in
            if error == nil {
                self.image = UIImage(data: data!)
            }else{
                print(error?.localizedDescription ?? "")
            }
        }
    }
}
