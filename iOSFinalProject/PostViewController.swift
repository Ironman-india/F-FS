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

class PostViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

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
        postDescription.delegate = self
        storageRef = Storage.storage().reference()
        databaseRef = Database.database().reference()
        postDescription.layer.borderWidth = 1
        postDescription.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        postDescription.layer.cornerRadius = 5.0
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //self.view.frame.origin.y -= keyboardSize.height
    }
    
    func  textFieldDidEndEditing(_ textField: UITextField) {
        self.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        postDescription.selectAll(self)
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y -= 150
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y += 150
        }
        self.resignFirstResponder()
    }
    
    @IBAction func uploadPhoto(_ sender: Any) {
        showActionSheet()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            postImage.image = image
            postImage.image = resizeImage(image: postImage.image!, targetSize: CGSize(width: 500, height: 500))
        }
        uploadPhotoButton.setTitle("", for: .normal)
        uploadPhotoButton.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion: nil)
    }
    
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
        }
        
    }
    
    func photoLibrary()
    {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        }
        
    }
    
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func postItem(_ sender: Any) {
        if(postName.text != ""){
            if(postPrice.text != "") {
                if(postDescription.text != "" || postDescription.text != "Write a description"){
                    if(postImage != nil){
                        sendPost()
                    }else{
                        sendAlert(alert: "You need to add an image")
                    }
                }else{
                    sendAlert(alert: "You need to write a description")
                }
            }else{
                sendAlert(alert: "How much do you want for your item?")
            }
        }else{
            sendAlert(alert: "What's the name of your item?")
        }
    }
    
    func sendAlert(alert:String) {
        let alert = UIAlertController(title: "Can't post item", message: alert, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    func sendPost(){
        
        let resizedImage = resizeImage(image: postImage.image!, targetSize: CGSize(width: 500, height: 500))
        
        if let data = resizedImage.pngData() {
            let photoRef = storageRef.child(postName.text! + ".png")
            let uploadTask = photoRef.putData(data, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                //let size = metadata.size
                // You can also access to download URL after upload.
                photoRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    let newUrl = downloadURL.absoluteString
                    let desc = self.postDescription.text
                    let name = self.postName.text
                    let price = self.postPrice.text
                    let postInfo = ["description": desc, "name": name, "price": price, "imageUrl": newUrl]
                    let postRef = self.databaseRef.child("Schools").child("NYU").child("Posts").childByAutoId()
                    postRef.setValue(postInfo)
                    self.dismissView()
                }
            }
        }
        self.dismissView()
        
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        print(size)
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        print(newImage?.size)
        return newImage!
    }
}
