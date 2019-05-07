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
    let firebaseManager = FireBaseManager.share
    var myProfile: MyProfile?
    var myUid: String?
    let notificationCenter = NotificationCenter.default
    
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var carView: UIView!

    let animationView = AnimationView(name: LottieFile.homeAnimationView.rawValue)

   @objc func changeAvatar(_ notification: NSNotification) {
    self.loadViewIfNeeded()
    let image = notification.userInfo!["avatar"] as? UIImage
    self.avatar.image = image
    
        
    }
    
    func isMemberAction() {
        
        if self.myUid == nil {
            
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
        
        
    }
    
    func getMyAvatar() {
        guard let uid = self.myUid else { return }
        self.firebaseManager.queryUserInfo(userID: uid, completion: { (myProfile) in
            
            self.myProfile = myProfile
            guard let myself = self.myProfile else { return }
                if myself.avatar != "", myself.avatar != nil {
                    if let url = URL(string: myself.avatar) {
                        self.avatar.kf.setImage(with: url)
                        self.avatar.roundCorners(self.avatar.frame.width/2)
                        self.avatar.clipsToBounds = true
                    } else {
                        return
                    }
          
                    
                }
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isMemberAction()
       
       
         NotificationCenter.default.addObserver(self, selector: #selector(changeAvatar(_:)), name: Notification.Name.avatarValue, object: nil)
        animationView.frame = CGRect(x: 0, y: 0, width: carView.frame.width, height:  carView.frame.height)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        
        animationView.animationSpeed = 1
        self.carView.addSubview(animationView)
        animationView.play()
    }

}

extension Notification.Name {
    public static let avatarValue = Notification.Name(rawValue: "avatarValue")
}
