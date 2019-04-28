//
//  ResetPasswordViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/11.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ResetPasswordViewController: UIViewController {
    @IBOutlet weak var submitBtn: UIButton! {
        didSet {
            self.submitBtn.roundCorners(5)
        }
    }
    @IBOutlet weak var whiteView: UIView! {
        didSet {
            self.whiteView.roundCorners(20)
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.parent?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func toLogIn(_ sender: Any) {
        view.removeFromSuperview()
        
        removeFromParent()
        
        didMove(toParent: nil)
    }
    // Outlets
    @IBOutlet weak var emailTextField: UITextField!
    
    // Reset Password Action
    @IBAction func submitAction(_ sender: AnyObject) {
        
        if self.emailTextField.text == "" {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().sendPasswordReset(withEmail: self.emailTextField.text!, completion: { (error) in
                
                var title = ""
                var message = ""
                
                if error != nil {
                    title = "Error!"
                    message = (error?.localizedDescription)!
                } else {
                    title = "Success!"
                    message = "Password reset email sent."
                    self.emailTextField.text = ""
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
    
    
}
