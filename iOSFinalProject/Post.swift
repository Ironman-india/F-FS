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
    var dispatchGroup: DispatchGroup!
    
    init(n:String, d:String, p: String, e: String, im: UIImage){
        name = n
        description = d
        imageUrl = ""
        //image = UIImage(named: "camera.png")
        price = p
        email = e
        self.image = im
    }
    
    func setImage(url: String){
        storageRef = storage.reference(forURL: url)
        storageRef.getData(maxSize: 1*2560*2560) { (data, error) in
            if error == nil {
                self.image = UIImage(data: data!)
                self.dispatchGroup.leave()
            }else{
                print(error?.localizedDescription ?? "")
            }
        }
    }
}
