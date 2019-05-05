//
//  LobbyViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/2.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import Lottie
import Kingfisher

class LobbyViewController: UIViewController {
//4966-onboarding-car
    
    let fireAuthManager = FireAuthManager.share
    let firebaseManager = FireBaseManager()
    var myProfile: MyProfile?
    var myUid: String?
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var carView: UIView!

    let animationView = AnimationView(name: "animation-w300-h300-2")
//        LOTAnimationView(name: "animation-w300-h300-2")
    
    func isMemberAction() {
        
        fireAuthManager.addSignUpListener { (isMember, user) in
            if isMember {
                guard let uid = user?.uid else { return }
                let pushManager = PushNotificationManager(userID: uid)
                pushManager.registerForPushNotifications()
                self.myUid = uid
                self.getMyAvatar()
                
            } else {
                return
            }
        }
    }
    
    func getMyAvatar() {
        guard let uid = self.myUid else { return }
        self.firebaseManager.queryUserInfo(userID: uid, completion: { (myProfile) in
            
            self.myProfile = myProfile
            guard let myself = self.myProfile else { return }
            print("-------")
            print(myself)

                if myself.avatar != "" {
                    let url = URL(string: myself.avatar)
                    self.avatar.kf.setImage(with: url)
                    self.avatar.roundCorners(self.avatar.frame.width/2)
                    self.avatar.clipsToBounds = true
                }
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isMemberAction()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        getMyAvatar()
        
        animationView.frame = CGRect(x: 0, y: 0, width: carView.frame.width, height:  carView.frame.height)
        animationView.contentMode = .scaleAspectFit
//        animationView.loopAnimation = true
        animationView.loopMode = .loop
        
        animationView.animationSpeed = 1
        self.carView.addSubview(animationView)
        animationView.play()
    }

}
