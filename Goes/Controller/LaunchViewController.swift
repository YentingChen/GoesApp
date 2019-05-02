//
//  LaunchViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/11.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LaunchViewController: UIViewController {
//    let fireAuthManager = FireAuthManager.share

    @IBOutlet weak var testes: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 3, animations: {
             self.testes.alpha = 0.0
        }) { (_) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Goes")
            self.present(vc, animated: true, completion: nil)

        }
        
    

//        UIView.animate(
//            withDuration: 3,
//            animations: {
//                self.testes.alpha = 0.0
//            }, completion: { _ in
//                self.fireAuthManager.addSignUpListener(listener: { (login) in
//                    if login == false {
        
//                        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
//                        let vc = storyboard.instantiateViewController(withIdentifier: "LogIn")
//                        self.present(vc, animated: true, completion: nil)
                        
//                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                        let vc = storyboard.instantiateViewController(withIdentifier: "Goes")
//                        self.present(vc, animated: true, completion: nil)
//
//                    } else {
//                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                        let vc = storyboard.instantiateViewController(withIdentifier: "Goes")
//                        self.present(vc, animated: true, completion: nil)
//                    }
//                })
//
//            }
//        )
//
//
    }

}
