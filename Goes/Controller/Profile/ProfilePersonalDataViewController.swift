//
//  ProfilePersonalDataViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/7.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfilePersonalDataViewController: UIViewController {
    
   let firebaseManager = FireBaseManager()
    let personalDataManager = PersonalDataManager()
//
//    var db = Firestore.firestore()
    
    var myProfile: MyProfile?
    
    typealias CompletionHandler = (MyProfile?) -> Void
    var handler: CompletionHandler?
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        personalDataManager.getPersonalData { (myProfile, err) in
            
            self.myProfile = myProfile
            self.tableView.reloadData()
            self.handler!(myProfile)
            
        }
        tableViewSetting()
        
//        showUserInfo(handler: { [weak self] name in
//
//            self?.handler?(name)
//        })
    }
//
//    typealias CompletionHandler = (String) -> Void
    
//    func showUserInfo(handler: @escaping CompletionHandler) {
//
//        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
//
//            guard user != nil else { return }
//
//            guard let userID = user?.uid else { return }
//
//            let userProfile =  self?.db.collection("users").document(userID)
            
//            userProfile?.getDocument { (document, error) in
//
//                if let profile = document.flatMap({
//                    $0.data().flatMap({ (data) in
//                        return Profile(dictionary: data)
//
//                    })
//                }) {
//                    self?.myProfile = MyProfile(
//                    email: profile.email,
//                    userID: profile.userID,
//                    userName: profile.userName,
//                    phoneNumber: profile.phoneNumber,
//                    avatar: profile.avatar)
//                    handler(profile.userName)
//                    print("Profile: \(profile)")
//                    self?.tableView.reloadData()
//                } else {
//                    print("Document does not exist")
//                }
//
//            }
//        }
//    }
    
    fileprivate func tableViewSetting() {
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.register(
            UINib(
                nibName: "ProfilePersonalTableViewCell",
                bundle: nil
            ),
            forCellReuseIdentifier: "profilePersonalTableViewCell"
        )
        
        tableView.separatorStyle = .none
    }
}

extension ProfilePersonalDataViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = ["姓名", "email", "手機"]
        let content = [myProfile?.userName, myProfile?.email, myProfile?.phoneNumber]
        let image = ["name_icon_24x", "email_icon_24x", "phone_icon_24x"]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "profilePersonalTableViewCell",
            for: indexPath) as? ProfilePersonalTableViewCell else { return UITableViewCell() }
        cell.cellTitle.text = title[indexPath.row]
        cell.cellContent.text = content[indexPath.row]
        
        cell.cellImageView.image = UIImage(named: image[indexPath.row] )
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.editImageView.isHidden = true

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 0 {
//            showEditingBox(title: "編輯姓名", message: "請輸入您的姓名", placeholder: "在此輸入姓名") { (action) in
//                print("hello")
//            }
//        }
//        
//        if indexPath.row == 1 {
//            showEditingBox(title: " 編輯 email ", message: "請輸入您的電子信箱", placeholder: "在此輸入電子信箱") { (action) in
//                print("cool")
//            }
//        }
//        
//        if indexPath.row == 2 {
//            showEditingBox(title: "編輯手機號碼", message: "請輸入您的手機號碼", placeholder: "在此輸入手機號碼") { (action) in
//                print("cool")
//            }
//        }
//    }
    
    func showEditingBox(title: String, message: String, placeholder: String, handler:((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title,
                                                message: message, preferredStyle: .alert)
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = placeholder
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "確定", style: .default, handler: handler)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }

}
