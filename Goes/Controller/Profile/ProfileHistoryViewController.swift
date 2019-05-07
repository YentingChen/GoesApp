//
//  ProfileHistoryViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/7.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import MTSlideToOpen
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire

class ProfileHistoryViewController: UIViewController {
    
    let personalDataManager = PersonalDataManager.share
    let fireBaseManager = FireBaseManager.share
    
    var myProfile: MyProfile?
    var myHistory = [OrderDetail]()

    var selectedHistory: OrderDetail?
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: "ProfileHistoryTableViewCell",
                  bundle: nil),
            forCellReuseIdentifier: "profileHistoryTableViewCell")
        tableView.register(
            UINib(nibName: "FriendPlaceholderTableViewCell",
                  bundle: nil),
            forCellReuseIdentifier: "friendPlaceholderTableViewCell")
        tableView.separatorStyle = .none
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.addRefreshHeader {
            self.loadDataFromDB()
        }
        
        tableView.beginHeaderRefreshing()
    }
    
    func loadDataFromDB() {
        
        self.myHistory = []
        
        self.personalDataManager.getPersonalData { (myProfile, _) in
            self.myProfile = myProfile
            guard let myProfile = self.myProfile else { return }
            
            self.fireBaseManager.queryMyOrders(myUid: myProfile.userID, status: 7, completionHandler: { (orders) in
                
                self.myHistory = orders.sorted(by: { $0.orderID > $1.orderID })
                
               
                self.tableView.reloadData()
                
                self.tableView.endHeaderRefreshing()
            })
            
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "historyDetail" {
            if let destination = segue.destination as? ProfileHistoryDetailViewController {
                
                destination.myProfile = self.myProfile
                destination.history  = self.selectedHistory 
        
            }
            
        }
    }

}

extension ProfileHistoryViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if myHistory.count != 0 {
            return myHistory.count
        }
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if myHistory.count != 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileHistoryTableViewCell", for: indexPath) as? ProfileHistoryTableViewCell else { return UITableViewCell()}
            
            let timeInterVal = TimeInterval(self.myHistory[indexPath.row].completeTime)
            let date = Date(timeIntervalSince1970: timeInterVal)
            let dformatter = DateFormatter()
            dformatter.dateFormat = " yyyy年MM月dd日 HH:mm "
            let dateString = "\(dformatter.string(from: date))"
            cell.dateLabel.text = dateString
    
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendPlaceholderTableViewCell") as? FriendPlaceholderTableViewCell else { return UITableViewCell() }
            return cell
            
        }
        
        return UITableViewCell()
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if myHistory.count != 0, myHistory != nil{
            
            self.selectedHistory = myHistory[indexPath.row]
            print(selectedHistory)
            performSegue(withIdentifier: "historyDetail", sender: self)
            
            
        }
      
        

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

}
