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
    let personalDataManager = PersonalDataManager.share
    let fireBaseManager = FireBaseManager.share
    var myProfile: MyProfile?
    var inviteFriend = [MyProfile]()
    @IBOutlet weak var tableView: UITableView!

     func loadDataFromDB() {
        
        personalDataManager.getPersonalData { [weak self] (myProfile, error) in
            self?.myProfile = myProfile
            self?.fireBaseManager.querymyFriends(myUid: (self?.myProfile?.userID)!, status: 2, completionHandler: { (friendInfos) in
                guard let myfriendInfos = friendInfos else { return }
                self?.inviteFriend = myfriendInfos
                self?.tableView.reloadData()
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDataFromDB()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: "FriendInviteTableViewCell",
                  bundle: nil),
            forCellReuseIdentifier: "friendInviteTableViewCell")
        tableView.register(
            UINib(nibName: "FriendPlaceholderTableViewCell",
                  bundle: nil),
            forCellReuseIdentifier: "FriendPlaceholderTableViewCell")

    }

}

extension FriendInviteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.inviteFriend.count == 0 {
            
            return 1
            
        } else {
            
            return inviteFriend.count
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.inviteFriend.count == 0 {
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: FriendPlaceholderTableViewCell.self)) as? FriendPlaceholderTableViewCell else {
                    return UITableViewCell()
            }
            cell.selectionStyle = .none
            
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "friendInviteTableViewCell",
                for: indexPath) as? FriendInviteTableViewCell else { return  UITableViewCell() }
            
            cell.checkBtn.tag = indexPath.row
            cell.deleteBtn.tag = indexPath.row
            cell.cellLabel.text = self.inviteFriend[indexPath.row].userName
            cell.checkBtn.addTarget(self, action: #selector(makeFriend(_:)), for: .touchUpInside)
            cell.deleteBtn.addTarget(self, action: #selector(cancelInvite(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            if self.inviteFriend[indexPath.row].avatar != "" {
                let url = URL(string: self.inviteFriend[indexPath.row].avatar)
                cell.cellImage.kf.setImage(with: url)
                cell.cellImage.roundCorners(cell.cellImage.frame.width/2)
                cell.cellImage.clipsToBounds = true
            }
            
            return cell
        }
        
    }
    
    @objc func cancelInvite(_ sendr: UIButton) {
        self.fireBaseManager.deleteFriend(
        myUid: (self.myProfile?.userID)!,
        friendUid: self.inviteFriend[sendr.tag].userID) {
            
            self.inviteFriend.remove(at: sendr.tag)
            self.tableView.reloadData()
        }
        
    }
    
    @objc func makeFriend(_ sendr: UIButton) {
        self.fireBaseManager.becomeFriend(
        myUid: (self.myProfile?.userID)!,
        friendUid: self.inviteFriend[sendr.tag].userID) {
            
            self.inviteFriend.remove(at: sendr.tag)
            self.tableView.reloadData()
           
        }
    
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

}
