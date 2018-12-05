//
//  ViewPostViewController.swift
//  iOSFinalProject
//
//  Created by Michael Anastasio on 12/4/18.
//  Copyright © 2018 Michael Anastasio. All rights reserved.
//

import UIKit

class ViewPostViewController: UIViewController {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var postPrice: UILabel!
    @IBOutlet weak var postName: UILabel!
    
    var name = ""
    var price = ""
    var desc = ""
    var image:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        postName.text = name
        postDescription.text = desc
        postPrice.text = price
        postImage.image = image
    }
    
}
