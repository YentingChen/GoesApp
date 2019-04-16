//
//  FriendInviteViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/7.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import Firebase

class FriendInviteViewController: UIViewController {
    let personalDataManager = PersonalDataManager()
    let fireBaseManager = FireBaseManager()
    var myProfile : MyProfile?
    var inviteFriend = [MyProfile]()
    @IBOutlet weak var tableView: UITableView!
    var db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        personalDataManager.getPersonalData { (myProfile, error) in
            self.myProfile = myProfile
            self.fireBaseManager.querymyFriends(myUid: (self.myProfile?.userID)!, status: 2, completionHandler: { (friendInfos) in
                self.inviteFriend = friendInfos
                self.tableView.reloadData()
            })
        }

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FriendInviteTableViewCell", bundle: nil), forCellReuseIdentifier: "friendInviteTableViewCell")

    }

}

extension FriendInviteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inviteFriend.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendInviteTableViewCell", for: indexPath) as? FriendInviteTableViewCell else { return  UITableViewCell() }

        cell.checkBtn.tag = indexPath.row
        cell.deleteBtn.tag = indexPath.row
        cell.cellLabel.text = self.inviteFriend[indexPath.row].userName
        cell.checkBtn.addTarget(self, action: #selector(makeFriend(_:)), for: .touchUpInside)
        cell.deleteBtn.addTarget(self, action: #selector(cancelInvite(_:)), for: .touchUpInside)
        
        return cell

    }
    
    @objc func cancelInvite(_ sendr: UIButton) {
        self.fireBaseManager.deleteFriend(myUid: (self.myProfile?.userID)!, friendUid: self.inviteFriend[sendr.tag].userID) {
            self.viewDidLoad()
            self.tableView.reloadData()
        }
        
    }
    
    @objc func makeFriend(_ sendr: UIButton) {
        self.fireBaseManager.becomeFriend(myUid: (self.myProfile?.userID)!, friendUid: self.inviteFriend[sendr.tag].userID) {
            self.viewDidLoad()
            self.tableView.reloadData()
        }
    
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

}
