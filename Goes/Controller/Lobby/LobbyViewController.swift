//
//  LobbyViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/2.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import Lottie

class LobbyViewController: UIViewController {
//4966-onboarding-car
    
    let fireAuthManager = FireAuthManager.share
    
    @IBOutlet weak var carView: UIView!

    let animationView = AnimationView(name: "animation-w300-h300-2")
//        LOTAnimationView(name: "animation-w300-h300-2")
    
    func isMemberAction() {
        fireAuthManager.addSignUpListener { (isMember, user) in
            if isMember {
                guard let uid = user?.uid else { return }
                let pushManager = PushNotificationManager(userID: uid)
                pushManager.registerForPushNotifications()
            } else {
                return
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isMemberAction()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        animationView.frame = CGRect(x: 0, y: 0, width: carView.frame.width, height:  carView.frame.height)
        animationView.contentMode = .scaleAspectFit
//        animationView.loopAnimation = true
        animationView.loopMode = .loop
        
        animationView.animationSpeed = 1
        self.carView.addSubview(animationView)
        animationView.play()
    }

}
