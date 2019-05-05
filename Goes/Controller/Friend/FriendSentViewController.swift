//
//  FriendSentViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/7.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import Firebase

class FriendSentViewController: UIViewController {
    let personalDataManager = PersonalDataManager.share
    let fireBaseManager = FireBaseManager()
    var myProfile: MyProfile?
    var sentFriend = [MyProfile]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataLoadFromDB()

        tableView.dataSource = self
        
        tableView.delegate = self
        
        tableView.register(
            UINib(nibName: "FriendSentTableViewCell",
                  bundle: nil), forCellReuseIdentifier: "friendSentTableViewCell")
        
        tableView.register(
            UINib(nibName: "FriendPlaceholderTableViewCell",
                  bundle: nil),
            forCellReuseIdentifier: "friendPlaceholderTableViewCell")
        
        tableView.separatorStyle = .none
        
        tableView.backgroundColor = .white
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        dataLoadFromDB()
//    }
//
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        dataLoadFromDB()
    }
    
    @objc func cancelSent(_ sendr: UIButton) {
        self.fireBaseManager.deleteFriend(
        myUid: (self.myProfile?.userID)!,
        friendUid: self.sentFriend[sendr.tag].userID) {
             self.sentFriend.remove(at: sendr.tag)
             self.tableView.reloadData()
        }
        
    }
    
    func dataLoadFromDB() {
        
        personalDataManager.getPersonalData { [weak self]  (myProfile, error) in
            self?.myProfile = myProfile
            self?.fireBaseManager.querymyFriends(
                myUid: (self?.myProfile?.userID)!,
                status: 1,
                completionHandler: { (friendInfos) in
                    guard let myfriendInfos = friendInfos else { return }
                   
                    self?.sentFriend = myfriendInfos
                    self?.tableView.reloadData()
            })
            print(error as Any)
        }
    }
   
}

extension FriendSentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if sentFriend.count == 0 {
            
            return 1 
            
        } else {
            
            return sentFriend.count
        }
    
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            if sentFriend.count == 0 {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendPlaceholderTableViewCell") as? FriendPlaceholderTableViewCell else { return UITableViewCell() }
                
                 cell.selectionStyle = .none
                
                return cell
                
            } else {
                
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "friendSentTableViewCell",
                    for: indexPath) as? FriendSentTableViewCell else { return UITableViewCell()}
                
                cell.cellLabel.text = self.sentFriend[indexPath.row].userName
                
                cell.cancleInviteButton.tag = indexPath.row
                
                cell.cancleInviteButton.addTarget(self, action: #selector(cancelSent(_:)), for: .touchUpInside)
                if self.sentFriend[indexPath.row].avatar != "" {
                    let url = URL(string: self.sentFriend[indexPath.row].avatar)
                    cell.cellImageView.kf.setImage(with: url)
                    cell.cellImageView.roundCorners(cell.cellImageView.frame.width/2)
                    cell.cellImageView.clipsToBounds = true
                }
                
                 cell.selectionStyle = .none
                
                return cell
                
            }
        
      
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
        
    }

}
