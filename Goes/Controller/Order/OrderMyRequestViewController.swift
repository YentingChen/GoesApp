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
    var myOrdersS1 = [OrderDetail]()
    var myOrdersS4 = [OrderDetail]()
    var myOrdersS5 = [OrderDetail]()
    var driversS1 = [MyProfile]()
    var driverS4 = [MyProfile]()
    var driverS5 = [MyProfile]()
    var selectedOrder: OrderDetail?
    var selectedDriver: MyProfile?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.register(
            UINib(nibName: "OrderMyRequestTableViewCell",
                  bundle: nil),
            forCellReuseIdentifier: "orderMyRequestTableViewCell")
        
        tableView.register(
            UINib(nibName: "OrderRequestHeaderTableViewCell",
                  bundle: nil),
            forCellReuseIdentifier: "orderRequestHeaderTableViewCell")
        
        tableView.register(
            UINib(nibName: "OrderRequestPlaceholderTableViewCell",
                  bundle: nil),
            forCellReuseIdentifier: "orderRequestPlaceholderTableViewCell")

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMyOrderDetail" {
            if let destination = segue.destination as? OrderRidingViewController {
                
                destination.orderMyRequestVC = self
                destination.myProfile = self.myProfile
                destination.order = self.selectedOrder
                destination.driver = self.selectedDriver
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.myOrdersS1 = []
        self.myOrdersS4 = []
        self.myOrdersS5 = []
        self.driversS1 = []
        self.driverS4 = []
        self.driverS5 = []
        tableView.reloadData()
        
        loadDataFromDB()
    }
    
    func loadDataFromDB() {
        
        personalDataManager.getPersonalData { (myProfile, _) in
            self.myProfile = myProfile
            
            self.fireBaseManager.queryMyOrders(myUid: (myProfile?.userID)!, status: 1, completionHandler: { (orders) in
                
                self.myOrdersS1 = orders
                
                for order in orders {
                    self.fireBaseManager.queryUserInfo(userID: order.driverUid, completion: { (driver) in
                        
                        self.driversS1.append(driver!)
                        
                        self.tableView.reloadData()
                        
                    })
                }
                
            })
            
            self.fireBaseManager.queryMyOrders(myUid: (myProfile?.userID)!, status: 4, completionHandler: { (orders) in
                self.myOrdersS4 = orders
                for order in orders {
                    self.fireBaseManager.queryUserInfo(userID: order.driverUid, completion: { (driver) in
                        
                        self.driverS4.append(driver!)
    
                        self.tableView.reloadData()
                        
                    })
                }
                
            })
            
            self.fireBaseManager.queryMyOrders(myUid: (myProfile?.userID)!, status: 5, completionHandler: { (orders) in
                self.myOrdersS5 = orders
                
                for order in orders {
                    self.fireBaseManager.queryUserInfo(userID: order.driverUid, completion: { (driver) in
                        
                        self.driverS5.append(driver!)
                      
                        self.tableView.reloadData()
                        
                    })
                }
            })
        }
    }
}

extension OrderMyRequestViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "orderRequestHeaderTableViewCell") as? OrderRequestHeaderTableViewCell else { return UITableViewCell() }
         cell.backgroundColor = .white

        if section == 0 {
            
            cell.titleLabel.text = "待回覆"
    
        }

        if section == 1 {

            cell.titleLabel.text = "待接送"

        }

        if section == 2 {

            cell.titleLabel.text = "前往中"

        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 23
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            
            if myOrdersS1.count != 0,
                driversS1.count != 0,
                myOrdersS1.count == driversS1.count {
                
                return self.myOrdersS1.count
                
            }
            
            return 1
            
        }
        
        if section == 1 {
            
            if myOrdersS4.count != 0,
                driverS4.count != 0,
                driverS4.count == myOrdersS4.count {
                
                return self.myOrdersS4.count
                
            } else {
                
                return 1
            }
        }
        
        if section == 2 {
            
            if myOrdersS5.count != 0,
                driverS5.count != 0,
                driverS5.count == myOrdersS5.count {
                
                return self.myOrdersS5.count
                
            } else {
                
                return 1
            }
        }
        
        return Int()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if myOrdersS1.count != 0,
                driversS1.count != 0,
                myOrdersS1.count == driversS1.count {
                
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "orderMyRequestTableViewCell",
                    for: indexPath) as? OrderMyRequestTableViewCell else {
                    return UITableViewCell()
                }
                
                cell.driverName.text = self.driversS1[indexPath.row].userName
                cell.moreInfoImageVIew.isHidden = true
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
                
            }
            
        }
        
        if indexPath.section == 1 {
            
           
                if myOrdersS4.count != 0,
                    driverS4.count != 0,
                    myOrdersS4.count == driverS4.count {
                    
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: "orderMyRequestTableViewCell",
                        for: indexPath) as? OrderMyRequestTableViewCell else {
                        return UITableViewCell()
                        
                    }
                    
                    cell.driverName.text = self.driverS4[indexPath.row].userName
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none
                    cell.moreInfoImageVIew.isHidden = true
                    return cell
                    
            }
            
        }
        
        if indexPath.section == 2 {
        
                if myOrdersS5.count != 0,
                    driverS5.count != 0,
                    myOrdersS5.count == driverS5.count {
                    
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: "orderMyRequestTableViewCell",
                        for: indexPath) as? OrderMyRequestTableViewCell else {
                        return UITableViewCell()
                        
                    }
                    cell.driverName.text = self.driverS5[indexPath.row].userName
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none
                    return cell
                
            }
            
        }
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "orderRequestPlaceholderTableViewCell") as? OrderRequestPlaceholderTableViewCell else {
                return UITableViewCell()
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            if myOrdersS1.count != 0,
                driversS1.count != 0,
                myOrdersS1.count == driversS1.count {
                
                return 100
                
            } else {
                
                return 40
            }
        }
        
        if indexPath.section == 1 {
            
            if myOrdersS4.count != 0,
                driverS4.count != 0,
                myOrdersS4.count == driverS4.count {
                
                return 100
                
            } else {
                
                return 40
            }
        }
        
        if indexPath.section == 2 {
            
            if myOrdersS5.count != 0,
                driverS5.count != 0,
                myOrdersS5.count == driverS5.count {
                
                return 100
                
            } else {
                
                return 40
            }
        }
        
        return CGFloat()
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
           
            self.selectedOrder = self.myOrdersS5[indexPath.row]
            self.selectedDriver = self.driverS5[indexPath.row]
            
             performSegue(withIdentifier: "toMyOrderDetail", sender: self)
            
        }
    }

}
