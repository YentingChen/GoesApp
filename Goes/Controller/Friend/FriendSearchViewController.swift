//
//  FriendSearchViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/8.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class FriendSearchViewController: UIViewController {
    
    @IBOutlet weak var searchFriend: UITextField!
    var personalDataManager = PersonalDataManager.share
    var firebaseManager = FireBaseManager.share
    var myProfile: MyProfile?
    var friendInfo: MyProfile?
  
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var friendView: UIView!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var addFriendBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchFriend.delegate = self
        searchFriend.clearButtonMode = UITextField.ViewMode.whileEditing
        self.friendView.isHidden = true
        personalDataManager.getPersonalData { (myProfile, error) in
            self.myProfile = myProfile
        }

    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "錯誤",
                                                message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "確認", style: .cancel, handler: nil)
       
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func searchBtn(_ sender: Any) {
        
        searchFriendFromDB()
    }
    
    func searchFriendFromDB() {
        
        guard let myUid = self.myProfile?.userID else { return }
        
        guard let friendEmail = self.searchFriend.text else { return }
        
        guard let myEmail = self.myProfile?.email else { return }
        
        firebaseManager.queryUsers(email: friendEmail) { (isUser, friUid) in
            
            if isUser == false {
                self.friendInfo = nil
                self.showFriendView(addBtnEnable: false, btnTitle: "無此會員")
            }
            
            if isUser == true {
                
                if myEmail == friendEmail {
                    print("It's me")
                    guard let myInfo = self.myProfile else {
                        return
                    }
                    if myInfo.avatar != "" {
                        let url = URL(string: myInfo
                            .avatar)
                        self.avatar.kf.setImage(with: url)
                        self.avatar.roundCorners(self.avatar.frame.width/2)
                        self.avatar.clipsToBounds = true
                    }
                    
                    self.showFriendView(addBtnEnable: false, btnTitle: "這是我自己")
                }else {
                    self.firebaseManager.queryUserInfo(userID: friUid, completion: { (userInfo) in
                        
                        self.friendInfo = userInfo
                        
                        guard let friendInfo = self.friendInfo else {
                            return
                        }
                        if friendInfo.avatar != "" {
                            let url = URL(string: friendInfo
                                .avatar)
                            self.avatar.kf.setImage(with: url)
                            self.avatar.roundCorners(self.avatar.frame.width/2)
                            self.avatar.clipsToBounds = true
                        }
                        
                        self.firebaseManager.queryFriendStatus(friendUid: friUid, myUid: myUid, completionHandler: { (status) in
                            switch status {
                            case 1 : print("已經送出")
                            self.showFriendView(addBtnEnable: false, btnTitle: "已經送出")
                            case 2 : print("尚未回復")
                            self.showFriendView(addBtnEnable: false, btnTitle: "尚未回復")
                            case 3 : print ("已經是好友")
                            self.showFriendView(addBtnEnable: false, btnTitle: "已經是好友")
                            case 4 : print("已經是摯友")
                            self.showFriendView(addBtnEnable: false, btnTitle: "已經是好友")
                            default : print("prepare 加好友")
                            self.showFriendView(addBtnEnable: true, btnTitle: "成為好友")
                                
                            }
                        })
                    })
                    
                }
                
            }
        }
    }
    
    func showFriendView( addBtnEnable: Bool, btnTitle: String) {
        
        self.friendView.isHidden = false
        self.friendName.text = self.friendInfo?.userName
        self.addFriendBtn.isEnabled = addBtnEnable
        if addBtnEnable == false {
            self.addFriendBtn.setTitle(btnTitle, for: .disabled)
            self.addFriendBtn.backgroundColor = UIColor.white
            self.addFriendBtn.setTitleColor(UIColor.gray, for: .disabled)
        } else {
            self.addFriendBtn.setTitle(btnTitle, for: .normal)
             self.addFriendBtn.backgroundColor = UIColor.G1
            self.addFriendBtn.titleLabel?.textColor = UIColor.white
        }
       
    }
        
    @IBAction func addFriend(_ sender: Any) {
        guard let myUid = self.myProfile?.userID else { return }
        guard let friendUid = self.friendInfo?.userID else { return }
        guard let friendFcmToken = self.friendInfo?.fcmToken else { return }
        guard let myName = self.myProfile?.userName else { return }
       self.firebaseManager.makeFriend(friendUid: friendUid, myUid: myUid)
        let sender = PushNotificationSender()
        sender.sendPushNotification(to: friendFcmToken, title: "您收一則好友邀請請", body: "您收到來自\(myName)的好友邀請，快去回覆吧！")

        searchFriendFromDB()
    }
    
}

extension FriendSearchViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.friendView.isHidden = true
        }
       
    }
   
}
