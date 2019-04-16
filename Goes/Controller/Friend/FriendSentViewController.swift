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
    var myProfile : MyProfile?
    var sentFriend = [MyProfile]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        personalDataManager.getPersonalData { (myProfile, error) in
            self.myProfile = myProfile
            self.fireBaseManager.querymyFriends(myUid: (self.myProfile?.userID)!, status: 1, completionHandler: { (friendInfos) in
                self.sentFriend = friendInfos
                self.tableView.reloadData()
            })
            
        }

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "FriendSentTableViewCell", bundle: nil), forCellReuseIdentifier: "friendSentTableViewCell")
        tableView.separatorStyle = .none
        
    }

    @objc func cancleSent(_ sendr: UIButton) {
        self.fireBaseManager.deleteFriend(myUid: (self.myProfile?.userID)!, friendUid: self.sentFriend[sendr.tag].userID) {
             self.viewDidLoad()
             self.tableView.reloadData()
        }
        
    }
   
}

extension FriendSentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sentFriend.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendSentTableViewCell", for: indexPath) as? FriendSentTableViewCell else { return UITableViewCell()}
        cell.cellLabel.text = self.sentFriend[indexPath.row].userName
        cell.cancleInviteButton.tag = indexPath.row
        cell.cancleInviteButton.addTarget(self, action: #selector(cancleSent(_:)), for: .touchUpInside)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

}
