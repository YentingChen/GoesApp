//
//  LobbyFriendViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/5.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class LobbyFriendViewController: UIViewController {
    
    var selectedLocation: Address?
    var selectedTime: DateAndTime?
    var selectedFriend: MyProfile?
    var isSearching = false
    
    var result = [MyProfile]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    let personalDataManager = PersonalDataManager.share
    let fireBaseManager = FireBaseManager.share
    var myProfile: MyProfile?
    var myFriends = [MyProfile]()
    var myFriendName = [String]()

    @IBOutlet weak var tableView: UITableView!
    func produceTime(time: DateAndTime)
        -> String {
            
            let year = time.year
            let month = { () -> String in
                if time.month < 10 {
                    return "0\(time.month)"
                } else {
                    return "\(time.month)"
                }
            }()
            let day = { () -> String in
                if time.day < 10 {
                    return "0\(time.day)"
                } else {
                    return "\(time.day)"
                }
            }()
            
            let time = time.time
            return "\(year)/\(month)/\(day)   \(time)"
    }

    @IBAction func checkBtn(_ sender: Any) {
        
        if selectedFriend == nil {
            
            let alertController = UIAlertController(
                title: "請選擇朋友",
                message: "選擇朋友後，方能使用該功能",
                preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "確定", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            guard let selectime = self.selectedTime else { return }
            
            let selectedTimeAndDate = produceTime(time: selectime)
            
            let orderID = "\(createOrderID())"
            
            let alertController = UIAlertController(
                title: "",
                message: "選擇地點：\(selectedLocation!.placeName)\n選擇時間：\(selectedTimeAndDate)\n選擇朋友：\(selectedFriend!.userName)",
                preferredStyle: .alert)
            
            let doneAction = UIAlertAction(title: "Okay", style: .default) { (_) in
                
                self.fireBaseManager.upLoadOrder(
                    orderID: orderID,
                    selectedTime: self.selectedTime!,
                    selectedFriend: self.selectedFriend!,
                    selectedLocation: self.selectedLocation!,
                    myInfo: self.myProfile!,
                    completionHandler: {
                        self.dismiss(animated: false, completion: nil)
                        self.navigationController?.dismiss(animated: false, completion: nil)
                        self.present(LobbyViewController(), animated: false, completion: nil)
                })
                guard let friendFcmToken = self.selectedFriend?.fcmToken else { return }
                guard let myself = self.myProfile else { return }
                let sender = PushNotificationSender()
                sender.sendPushNotification(to: friendFcmToken, title: "您收到一則請求", body: "您收到來自\(myself.userName)的請求，快去回覆吧！")

            }
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            alertController.addAction(doneAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func createOrderID() -> Int {
        let now = Date()
        let timeInterval: TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return timeStamp
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        personalDataManager.getPersonalData { (myProfile, _) in
            self.myProfile = myProfile
            self.fireBaseManager.querymyFriends(
                myUid: (self.myProfile?.userID)!,
                status: 3,
                completionHandler: { (friendInfos) in
                guard let myfriendInfos = friendInfos else { return }
                self.myFriends = myfriendInfos
                self.tableView.reloadData()
            })
            
        }
        
        self.searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: "LobbyFriendTableViewCell",
                  bundle: nil),
            forCellReuseIdentifier: "lobbyFriendTableViewCell")

    }

    @IBAction func dismissBtn(_ sender: Any) {
        
        dismiss(animated: false, completion: nil)
        
        self.navigationController?.dismiss(animated: false, completion: nil)
        
        present(LobbyViewController(), animated: false, completion: nil)
    }

}

extension LobbyFriendViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            return result.count
        } else {
            return myFriends.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "lobbyFriendTableViewCell",
            for: indexPath) as? LobbyFriendTableViewCell else { return UITableViewCell() }
        
        if isSearching {
            cell.nameLabel.text = self.result[indexPath.row].userName
            if self.result[indexPath.row].avatar != "" {
                let url = URL(string: self.result[indexPath.row].avatar)
                cell.profileImageView?.kf.setImage(with: url)
                cell.profileImageView?.roundCorners((cell.profileImageView?.frame.width)!/2)
                cell.profileImageView?.clipsToBounds = true
            }
            
        } else {
            
            cell.nameLabel.text = self.myFriends[indexPath.row].userName
            if self.myFriends[indexPath.row].avatar != "" {
                let url = URL(string: self.myFriends[indexPath.row].avatar)
                cell.profileImageView?.kf.setImage(with: url)
                cell.profileImageView?.roundCorners((cell.profileImageView?.frame.width)!/2)
                cell.profileImageView?.clipsToBounds = true
            }
        }
        
        return cell

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedFriend = self.myFriends[indexPath.row]
    }

}

extension LobbyFriendViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            
            self.result = self.myFriends
            
        } else {
            
            self.result = []
            isSearching = true
            
            for name in self.myFriends.filter(( {$0.userName.lowercased().hasPrefix(searchText.lowercased())} )) {

                self.result.append(name)
                
            }

        }
        
        self.tableView.reloadData()
    }
    
    private func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        searchBar.text = ""
        
        isSearching = false
        
        self.tableView.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
