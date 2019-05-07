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

    @IBOutlet weak var loadingView: UIImageView!
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 3, animations: {
            
             self.loadingView.alpha = 0.0
            
        }) { (_) in
            
            self.presentHomeVC()
            
            FireAuthManager.share.addSignUpListener(listener: { (isMember, user) in
                guard let member = user else { return }
                if isMember {
                    self.userDefaults.set("\(member.uid)", forKey: UserdefaultKey.memberUid.rawValue)
                    
                } else {
                    self.userDefaults.set("", forKey: UserdefaultKey.memberUid.rawValue)
                }
            })

        }
        
    }
    
    fileprivate func presentHomeVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let fristVC = storyboard.instantiateViewController(
            withIdentifier: "Goes")
        self.present(fristVC, animated: true, completion: nil)
    }

}
