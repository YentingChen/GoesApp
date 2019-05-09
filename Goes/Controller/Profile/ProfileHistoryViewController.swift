//
//  ProfileHistoryViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/7.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ProfileHistoryViewController: UIViewController {

    var myHistory = [OrderDetail]()

    var selectedHistory: OrderDetail?
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewSetting()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.addRefreshHeader {
            
            self.loadDataFromDB()
        }
        
        tableView.beginHeaderRefreshing()
    }
    
    func loadDataFromDB() {
        
        guard let uid = UserDefaults.standard.value(
            forKey: UserdefaultKey.memberUid.rawValue) as? String,
            uid != "" else { return }
        
        self.myHistory = []
        
        FireBaseManager.share.queryMyOrders(myUid: uid, status: 7) { (orders) in
            
            self.myHistory = orders.sorted(by: { $0.orderID > $1.orderID })
            
            self.tableView.reloadData()
            
            self.tableView.endHeaderRefreshing()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "historyDetail" {
            
            if let destination = segue.destination as? ProfileHistoryDetailViewController {
                
                destination.history  = self.selectedHistory 
        
            }
            
        }
    }
    
    fileprivate func tableViewSetting() {
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.register(
            UINib(nibName: String(describing: FriendPlaceholderTableViewCell.self),
                  bundle: nil),
            forCellReuseIdentifier: String(describing: FriendPlaceholderTableViewCell.self))
        
        tableView.register(
            UINib(nibName: String(describing: ProfileHistoryTableViewCell.self),
                  bundle: nil),
            forCellReuseIdentifier: String(describing: ProfileHistoryTableViewCell.self))
        tableView.separatorStyle = .none
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
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier:
                String(describing: ProfileHistoryTableViewCell.self),
                for: indexPath) as? ProfileHistoryTableViewCell else { return UITableViewCell()}
            
            cell.dateLabel.text = String.formateTimeStamp(timeStamp: self.myHistory[indexPath.row].completeTime)
    
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier:
                String(describing:  FriendPlaceholderTableViewCell.self)) as? FriendPlaceholderTableViewCell else {
                    
                    return UITableViewCell()
                    
            }
            
            return cell
            
        }
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if myHistory.count != 0 {
            
            self.selectedHistory = myHistory[indexPath.row]
            
            performSegue(withIdentifier: SegueName.historyDetail.rawValue, sender: self)
        
        }
      
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }

}
