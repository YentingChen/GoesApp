//
//  OrderMyRequestViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/8.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

class OrderMyRequestViewController: UIViewController {
        
    let personalDataManager = PersonalDataManager()
    let fireBaseManager = FireBaseManager()
    var myProfile: MyProfile?
    var myOrders = [OrderDetail]()
    var myEvents = [OrderDetail]()
    var drivers = [MyProfile]()
    var driverIng = [MyProfile]()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        
        personalDataManager.getPersonalData { (myProfile, err) in
            self.myProfile = myProfile
            self.fireBaseManager.queryMyOrders(myUid: (myProfile?.userID)!, status: 1, completionHandler: { (orders) in
                self.myOrders = orders
                for order in orders {
                    self.fireBaseManager.queryUserInfo(userID: order.driverUid, completion: { (driver) in
                        self.drivers.append(driver!)
                        self.tableView.reloadData()
                    })
                }
                
            })
            
            self.fireBaseManager.queryMyOrders(myUid: (myProfile?.userID)!, status: 3, completionHandler: { (orders) in
                self.myEvents = orders
                
                for order in orders {
                    self.fireBaseManager.queryUserInfo(userID: order.driverUid, completion: { (driver) in
                        self.driverIng.append(driver!)
                        print(driver as Any)
                        self.tableView.reloadData()
                        
                    })
                }
            })
            
        }
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: "OrderMyRequestTableViewCell",
                  bundle: nil),
            forCellReuseIdentifier: "orderMyRequestTableViewCell")
        
        tableView.register(
            UINib(nibName: "OrderRequestHeaderTableViewCell",
                  bundle: nil),
            forCellReuseIdentifier: "orderRequestHeaderTableViewCell")

    }
    
}

extension OrderMyRequestViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "orderRequestHeaderTableViewCell") as? OrderRequestHeaderTableViewCell else { return UITableViewCell() }
            cell.headerTxt.text = "  待回覆  "
            cell.backgroundColor = .white
            return cell
        }
        
        if section == 1 {
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "orderRequestHeaderTableViewCell") as? OrderRequestHeaderTableViewCell else { return UITableViewCell() }
            cell.headerTxt.text = "  進行中  "
            cell.backgroundColor = .white
            return cell
        }
        
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            
            if myOrders.count != 0, drivers.count != 0, myOrders.count == drivers.count {
                return self.myOrders.count
            }
            return 0
            
        }
        
        if section == 1 {
            if myEvents.count != 0, driverIng.count != 0, myEvents.count == driverIng.count {

                return self.myEvents.count
            } else {
                
                return 0
            }
        }
        
        return Int()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "orderMyRequestTableViewCell", for: indexPath) as? OrderMyRequestTableViewCell else {
            return UITableViewCell()
        }
        
        if indexPath.section == 0 {
            
            cell.driverName.text = self.drivers[indexPath.row].userName
            
            return cell
        }
        
        if indexPath.section == 1 {
            cell.driverName.text = self.driverIng[indexPath.row].userName
        }
        
        return UITableViewCell()
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            performSegue(withIdentifier: "test3", sender: self)
        }
    }

}
