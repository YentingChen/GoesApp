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

    let firebaseManager = FireBaseManager.share
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton! {
        didSet {
            self.signUpBtn.roundCorners(5)
        }
    }
    @IBOutlet weak var squareView: UIView! {
        didSet {
            self.squareView.roundCorners(20)
        }
    }
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func toLogin(_ sender: Any) {
        
        view.removeFromSuperview()
        
        removeFromParent()
        
        didMove(toParent: nil)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        
      self.parent?.presentingViewController?.dismiss(animated: false, completion: nil)

    }
    
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
                    
                    guard let userID = user?.user.uid else { return }
                    
                    guard let userName = self.userNameTextField.text else { return }
                    
                    guard let userPhone = self.phoneNumberTextField.text else { return }
                    
                    guard let userEmail = user?.user.email else { return }
                    
                    self.firebaseManager.buildUserInfo(
                        userID: userID,
                        userName: userName,
                        userEmail: userEmail,
                        avatar: "",
                        userPhone: userPhone)
                    
//                    self.db.collection("users").document(userID).setData(
//                        [SetProfile.CodingKeys.userID.rawValue : userID,
//                         SetProfile.CodingKeys.userName.rawValue : userName,
//                         SetProfile.CodingKeys.email.rawValue : userEmail,
//                         SetProfile.CodingKeys.avatar.rawValue : "",
//                         SetProfile.CodingKeys.phoneNumber.rawValue : userPhone])
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "Goes")
//                    self.present(vc, animated: true, completion: nil)
                    
                    self.dismiss(animated: false, completion: nil)
                    
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
        
//        db = Firestore.firestore()
       
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
