//
//  AskLogInViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/27.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AskLogInViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func toPassword(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let passwordVC = storyboard.instantiateViewController(withIdentifier: "password")
            as? ResetPasswordViewController
        
        addChild(passwordVC!)
        
        passwordVC?.loadViewIfNeeded()
        
        passwordVC?.view.frame = view.frame
        
        passwordVC?.view.backgroundColor = UIColor.clear
        
        self.view.addSubview(passwordVC!.view)
        
    }
    
    @IBAction func toSignUp(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let signVC = storyboard.instantiateViewController(withIdentifier: "SignUp")
            as? SignUpViewController
        
        addChild(signVC!)
    
        signVC?.loadViewIfNeeded()
//        signVC!.squareView.frame = self.whiteView.frame
        
        signVC?.view.frame = view.frame
        
        signVC?.view.backgroundColor = UIColor.clear
        
        self.view.addSubview(signVC!.view)
        
//        self.whiteView.clipsToBounds = true
       
    }
    
    @IBAction func dismissBtn(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var whiteView: UIView! {
        didSet {
            self.whiteView.roundCorners(20)
        }
    }
    @IBOutlet weak var loginBtn: UIButton! {
        didSet {
            self.loginBtn.roundCorners(5)
        }
    }
    
    @IBAction func loginAction(_ sender: AnyObject) {
        
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    
                    //Go to the HomeViewController if the login is sucessful
                   
                    
                    
                    self.dismiss(animated: false, completion: nil)
                

                    
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }

}
