//
//  SignUpViewController.swift
//  iOSFinalProject
//
//  Created by Michael Anastasio on 12/3/18.
//  Copyright © 2018 Michael Anastasio. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        signUp()
    }
    
    func parseEmail(email: String) -> Bool{
        var newEmail = ""
        var isEmailName = false
        var exists = true
        for index in email.indices {
            if(!isEmailName) {
                if(email[index] == "@") {
                    isEmailName = true
                }
            }else {
                if(email[index] == ".") {
                    isEmailName = false
                }else {
                    newEmail = newEmail + String(email[index])
                }
            }
        }
        newEmail = newEmail.uppercased()
        let dbRef = Database.database().reference().child("Schools").child(newEmail)
        dbRef.observeSingleEvent(of: .value) { (snapshot) in
            if(snapshot.value is NSNull) {
                //There is no school in the database associated with the email
                print("No school associated to the email")
                let alertController = UIAlertController(title: "Sorry", message: "There isn't a school created for that email yet.", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                exists = false
            }
        }
        return exists
    }
    
    func signUp() {
        if(usernameText.text == "" || emailText.text == "" || passwordText.text == ""){
            let alertController = UIAlertController(title: "Error", message: "Please enter your email, username, and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }else {
            let email = emailText.text!
            var newEmail = ""
            var isEmailName = false
            for index in email.indices {
                if(!isEmailName) {
                    if(email[index] == "@") {
                        isEmailName = true
                    }
                }else {
                    if(email[index] == ".") {
                        isEmailName = false
                    }else {
                        newEmail = newEmail + String(email[index])
                    }
                }
            }
            newEmail = newEmail.uppercased()
            let dbRef = Database.database().reference().child("Schools").child(newEmail)
            dbRef.observeSingleEvent(of: .value) { (snapshot) in
                if(snapshot.value is NSNull) {
                    //There is no school in the database associated with the email
                    print("No school associated to the email")
                    let alertController = UIAlertController(title: "Sorry", message: "There isn't a school created for that email yet.", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }else {
                    
                    Auth.auth().createUser(withEmail: self.emailText.text!, password: self.passwordText.text!) { (user, error) in
                        if(error != nil){
                            print(error?.localizedDescription ?? "No descriptno")
                            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                            
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            self.present(alertController, animated: true, completion: nil)
                        }else {
                            print("Signed up user: " + (user?.user.email)!)
                            if let user = user?.user {
                                let changeRequest = user.createProfileChangeRequest()
                                
                                changeRequest.displayName = newEmail
                                //changeRequest.photoURL = URL(string: "https://example.com/jane-q-user/profile.jpg")
                                changeRequest.commitChanges { error in
                                    if let error = error {
                                        print(error.localizedDescription)
                                        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                                        
                                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                        alertController.addAction(defaultAction)
                                        self.present(alertController, animated: true, completion: nil)
                                    } else {
                                        print("Profile updated")
                                        let newUser = ["username": self.usernameText.text, "email": self.emailText.text]
                                        
                                        dbRef.child("Users").childByAutoId().setValue(newUser, withCompletionBlock: { (error, ref) in
                                            if let error = error {
                                                print(error.localizedDescription)
                                                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                                                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                                alertController.addAction(defaultAction)
                                                self.present(alertController, animated: true, completion: nil)
                                            }else {
                                                print("Woo!")
                                                self.performSegue(withIdentifier: "SuccessSignUpSegue", sender: self)
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
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
