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
    let personalDataManager = PersonalDataManager()
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
        tableView.separatorStyle = .none
        
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
                    self?.sentFriend = friendInfos
                    self?.tableView.reloadData()
            })
            print(error as Any)
        }
    }
   
}

extension FriendSentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sentFriend.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "friendSentTableViewCell",
            for: indexPath) as? FriendSentTableViewCell else { return UITableViewCell()}
        cell.cellLabel.text = self.sentFriend[indexPath.row].userName
        cell.cancleInviteButton.tag = indexPath.row
        cell.cancleInviteButton.addTarget(self, action: #selector(cancelSent(_:)), for: .touchUpInside)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

}
