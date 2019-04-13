//
//  SignUpViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/11.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
     var db : Firestore!
     var ref: DocumentReference? = nil
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var squareView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    //Sign Up Action for email
    @IBAction func createAccountAction(_ sender: AnyObject) {
        if emailTextField.text == "" {
            let alertController = UIAlertController(
                title: "Error",
                message: "Please enter your email and password",
                preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    print(user?.user.uid)
                    guard let userID = user?.user.uid else { return }
                    guard let userName = self.userNameTextField.text else { return }
                    guard let userPhone = self.phoneNumberTextField.text else { return }
                    guard let userEmail = user?.user.email else { return }
                    self.db.collection("users").document(userID).setData(
                        [SetProfile.CodingKeys.userID.rawValue : userID,
                         SetProfile.CodingKeys.userName.rawValue : userName,
                         SetProfile.CodingKeys.email.rawValue : userEmail,
                         SetProfile.CodingKeys.avatar.rawValue : "",
                         SetProfile.CodingKeys.phoneNumber.rawValue : userPhone])
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "Goes")
                    self.present(vc, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore() 
        
        addShadow()
        roundCorner()
       
    }
    
    func postUserProfile(_ userProfile: SetProfile, uid: String) {
        
    }
    
    
    func addShadow() {
        self.squareView.dropShadow(color: UIColor.gray, opacity: 0.3, offSet: CGSize(width: 20, height: 20), radius:20 , scale: true)
        self.signUpBtn.dropShadow(color: UIColor.gray, opacity: 0.3, offSet: CGSize(width: 20, height: 20), radius: 20, scale: true)
    }
    
    func roundCorner() {
        self.squareView.roundCorners(20)
        self.signUpBtn.roundCorners(20)
    }

}
