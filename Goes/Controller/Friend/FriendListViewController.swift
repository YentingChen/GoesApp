//
//  FriendViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/6.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import Firebase

class FriendListViewController: UIViewController {
    
    let personalDataManager = PersonalDataManager()
    let fireBaseManager = FireBaseManager()
    var myProfile : MyProfile?
    var myFriends = [MyProfile]()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        personalDataManager.getPersonalData { (myProfile, error) in
            self.myProfile = myProfile
            self.fireBaseManager.querymyFriends(myUid: (self.myProfile?.userID)!, status: 3, completionHandler: { (friendInfos) in
                self.myFriends = friendInfos
                self.tableView.reloadData()
            })
        }

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: "FriendListTableViewCell",
                  bundle: nil),
            forCellReuseIdentifier: "friendListTableViewCell")

    }
    
    @objc func deleteFriend(_ sendr: UIButton) {
        self.fireBaseManager.deleteFriend(myUid: (self.myProfile?.userID)!, friendUid: self.myFriends[sendr.tag].userID) {
            self.viewDidLoad()
            self.tableView.reloadData()
        }
        
    }


}

extension FriendListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return myFriends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "friendListTableViewCell",
            for: indexPath) as? FriendListTableViewCell else {
            return UITableViewCell()
        }
        cell.cellDeleteBtn.tag = indexPath.row
        
        cell.cellLabel.text = self.myFriends[indexPath.row].userName
       
        cell.cellDeleteBtn.addTarget(self, action: #selector(deleteFriend(_:)), for: .touchUpInside)
        
        
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "朋友列表(2)"
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

}
