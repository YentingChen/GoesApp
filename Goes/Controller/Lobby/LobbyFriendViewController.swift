//
//  LobbyFriendViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/5.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

class LobbyFriendViewController: UIViewController {
    
    var selectedLocation: Address?
    var selectedTime: DateAndTime?
    var selectedFriend: MyProfile?
    
    let personalDataManager = PersonalDataManager()
    let fireBaseManager = FireBaseManager()
    var myProfile: MyProfile?
    var myFriends = [MyProfile]()
    
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var tableView: UITableView!

    @IBAction func checkBtn(_ sender: Any) {
        
        let selectedTimeAndDate = "\(selectedTime!.year)-\(selectedTime!.month)-\(selectedTime!.day) \(selectedTime!.time)"
        
        let alertController = UIAlertController(
            title: "",
            message: "選擇地點：\(selectedLocation!.placeName)\n選擇時間：\(selectedTimeAndDate)\n選擇朋友：\(selectedFriend!.userName)",
            preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Okay", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.dismiss(animated: true, completion: nil)
            self.present(LobbyViewController(), animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
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
            UINib(nibName: "LobbyFriendTableViewCell",
                  bundle: nil),
            forCellReuseIdentifier: "lobbyFriendTableViewCell")

    }

    @IBAction func dismissBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        self.navigationController?.dismiss(animated: true, completion: nil)
        present(LobbyViewController(), animated: true, completion: nil)
    }

}

extension LobbyFriendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFriends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "lobbyFriendTableViewCell",
            for: indexPath) as? LobbyFriendTableViewCell else { return UITableViewCell() }
        cell.nameLabel.text = self.myFriends[indexPath.row].userName
        return cell

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedFriend = self.myFriends[indexPath.row]
    }

}
