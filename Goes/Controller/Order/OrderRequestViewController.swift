//
//  OrderRequestViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/8.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

class OrderRequestViewController: UIViewController {
    
    let personalDataManager = PersonalDataManager()
    let fireBaseManager = FireBaseManager()
    var myProfile: MyProfile?
    var myOrders = [OrderDetail]()
    var myEvents = [OrderDetail]()
    var riders = [MyProfile]()
    var ridersIng = [MyProfile]()
    
    var selectedOrder: OrderDetail?
    var selectedRider: MyProfile?
   
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDataFromDB()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(
            UINib(nibName: "OrderRequestTableViewCell",
                  bundle: nil),
            forCellReuseIdentifier: "orderRequestTableViewCell")
        
        tableView.register(
            UINib(nibName: "OrderRequestHeaderTableViewCell",
                  bundle: nil),
            forCellReuseIdentifier: "orderRequestHeaderTableViewCell")

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBeAnswered" {
            
            if let destination = segue.destination as? OrderAnswerRequestViewController {
                
                destination.order = self.selectedOrder
                destination.rider = self.selectedRider
                destination.myProfile = self.myProfile
                destination.orderRequestVC = self
            }
        }
        
        if segue.identifier == "toDrivingView" {
            
            if let destination = segue.destination as? OrderDrivingViewController {
                
                destination.order = self.selectedOrder
                destination.rider = self.selectedRider
                destination.myProfile = self.myProfile
                destination.orderRequestVC = self
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDataFromDB()
    }
    
    func loadDataFromDB() {
        personalDataManager.getPersonalData { (myProfile, _) in
            self.myProfile = myProfile
            
            self.fireBaseManager.queryMyOrders(myUid: (myProfile?.userID)!, status: 2, completionHandler: { (orders) in
                
                self.myOrders = orders
                
                for order in orders {
                    self.fireBaseManager.queryUserInfo(userID: order.riderUid, completion: { (rider) in
                        self.riders.append(rider!)
                        print(rider as Any)
                        self.tableView.reloadData()
                        
                    })
                }
                
            })
            
            self.fireBaseManager.queryMyOrders(myUid: (myProfile?.userID)!, status: 3, completionHandler: { (orders) in
                
                self.myEvents = orders
                
                for order in orders {
                    self.fireBaseManager.queryUserInfo(userID: order.riderUid, completion: { (rider) in
                        self.ridersIng.append(rider!)
                        print(rider as Any)
                        self.tableView.reloadData()
                        
                    })
                }
                
            })
            
        }
        
    }

}

extension OrderRequestViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "orderRequestHeaderTableViewCell") as? OrderRequestHeaderTableViewCell else { return UITableViewCell() }
            cell.headerTxt.text = "  待回覆   "
            
            return cell
            
        }
        
        if section == 1 {
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "orderRequestHeaderTableViewCell") as? OrderRequestHeaderTableViewCell else { return UITableViewCell() }
            cell.headerTxt.text = "  進行中   "
            
            return cell
            
        }
        
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
            if section == 0 {
                
                if myOrders.count != 0, riders.count != 0, myOrders.count == riders.count {
                    return self.myOrders.count
                }
                return 0
                
            }
            
            if section == 1 {
                if myEvents.count != 0, ridersIng.count != 0, myEvents.count == ridersIng.count {
                    
                    return self.myEvents.count
                } else {
                    
                    return 0
                }
            }

        return Int()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "orderRequestTableViewCell",
                for: indexPath) as? OrderRequestTableViewCell else { return UITableViewCell() }
            
            let year = self.myOrders[indexPath.row].selectTimeYear
            cell.requestName.text = riders[indexPath.row].userName
            cell.requestTime.text = "\(year)/\(self.myOrders[indexPath.row].selectTimeMonth)/\(self.myOrders[indexPath.row].selectTimeDay) \(self.myOrders[indexPath.row].selectTimeTime)"
            cell.requestLocation.text = "\(self.myOrders[indexPath.row].locationFormattedAddress)"
            
            return cell

        }
        
        if indexPath.section == 1 {
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "orderRequestTableViewCell",
                for: indexPath) as? OrderRequestTableViewCell else { return UITableViewCell() }
            
            let year = self.myEvents[indexPath.row].selectTimeYear
            cell.requestName.text = ridersIng[indexPath.row].userName
            cell.requestTime.text = "\(year)/\(self.myEvents[indexPath.row].selectTimeMonth)/\(self.myEvents[indexPath.row].selectTimeDay) \(self.myEvents[indexPath.row].selectTimeTime)"
            cell.requestLocation.text = "\(self.myEvents[indexPath.row].locationFormattedAddress)"
            
            return cell
            
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
             self.selectedOrder = myOrders[indexPath.row]
             self.selectedRider = riders[indexPath.row]
             performSegue(withIdentifier: "toBeAnswered", sender: self)
            
        }
        
        if indexPath.section == 1 {
            self.selectedOrder = myEvents[indexPath.row]
            self.selectedRider = ridersIng[indexPath.row]
            performSegue(withIdentifier: "toDrivingView", sender: self)
        }

    }

}
