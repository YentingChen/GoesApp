//
//  OrderMyRequestViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/8.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

class OrderMyRequestViewController: UIViewController {
        
    let personalDataManager = PersonalDataManager.share
    let fireBaseManager = FireBaseManager.share
    var myProfile: MyProfile?
    var myOrdersS1 = [OrderDetail]()
    var myOrdersS4 = [OrderDetail]()
    var myOrdersS5 = [OrderDetail]()
    var driversS1 = [MyProfile]()
    var driverS4 = [MyProfile]()
    var driverS5 = [MyProfile]()
    var selectedOrder: OrderDetail?
    var selectedDriver: MyProfile?
    
    let group = DispatchGroup()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.register(
            UINib(nibName: "OrderRequestTableViewCell",
                  bundle: nil),
            forCellReuseIdentifier: "orderRequestTableViewCell")
        
        tableView.register(
            UINib(nibName: "OrderRequestHeaderTableViewCell",
                  bundle: nil),
            forCellReuseIdentifier: "orderRequestHeaderTableViewCell")
        
        tableView.register(
            UINib(nibName: "OrderRequestPlaceholderTableViewCell",
                  bundle: nil),
            forCellReuseIdentifier: "orderRequestPlaceholderTableViewCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        tableView.addRefreshHeader {

            self.loadDataAction()

        }
//          self.loadDataAction()
        
        tableView.beginHeaderRefreshing()
    
    }
    
    func loadDataAction() {
        
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
        
        self.group.enter()
        personalDataManager.getPersonalData { [weak self]  (myProfile, _) in
            
            self?.myProfile = myProfile
            
            self?.group.enter()
            self?.fireBaseManager.queryMyOrders(myUid: (myProfile?.userID)!, status: 1, completionHandler: { [weak self] (orders) in
                
                self?.myOrdersS1 = orders
            
                for order in orders {
                    
                    self?.group.enter()
                    
                    self?.fireBaseManager.queryUserInfo(userID: order.driverUid, completion: { [weak self]  (driver) in
                 
                        self?.driversS1.append(driver!)
                        
                        self?.group.leave()
                    })
                }
                
                self?.group.leave()
                
            })
            
            self?.group.enter()
            
            self?.fireBaseManager.queryMyOrders(myUid: (myProfile?.userID)!, status: 4, completionHandler: { [weak self]  (orders) in
                
                self?.myOrdersS4 = orders
                
                for order in orders {
                    
                    self?.group.enter()
                    
                    self?.fireBaseManager.queryUserInfo(userID: order.driverUid, completion: { [weak self]  (driver) in
                        
                        self?.driverS4.append(driver!)
    
                        self?.group.leave()
                        
                    })
                }
                
                self?.group.leave()
                
            })
            
            self?.group.enter()
            self?.fireBaseManager.queryMyOrders(myUid: (myProfile?.userID)!, status: 5, completionHandler: {  [weak self] (orders) in
                
                self?.myOrdersS5 = orders
            
                for order in orders {
                    
                    self?.group.enter()
                    
                    self?.fireBaseManager.queryUserInfo(userID: order.driverUid, completion: { [weak self] (driver) in
                        
                        self?.driverS5.append(driver!)
                      
                        self?.group.leave()
                        
                    })
                }
                
                self?.group.leave()
            })
            
            self?.group.notify(queue: .main) {
                
                self?.tableView.reloadData()
                
                self?.tableView.endHeaderRefreshing()
            }
            
            self?.group.leave()
        }
        
    }
    
    func produceTime(orders:[OrderDetail], number: Int)
        -> String {
            
            let year = orders[number].selectTimeYear
            let month = { () -> String in
                if orders[number].selectTimeMonth < 10 {
                    return "0\(orders[number].selectTimeMonth)"
                } else {
                    return "\(orders[number].selectTimeMonth)"
                }
            }()
            let day = { () -> String in
                if orders[number].selectTimeDay < 10 {
                    return "0\(orders[number].selectTimeDay)"
                } else {
                    return "\(orders[number].selectTimeMonth)"
                }
                
            }()

            let time = orders[number].selectTimeTime
            return "\(year)/\(month)/\(day)   \(time)"
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
                    withIdentifier: "orderRequestTableViewCell",
                    for: indexPath) as? OrderRequestTableViewCell else {
                        return UITableViewCell()
                }
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                
                let time = produceTime(orders: myOrdersS1, number: indexPath.row)
                cell.requestName.text = driversS1[indexPath.row].userName
                cell.requestTime.text = time
                cell.requestLocation.text = "\(self.myOrdersS1[indexPath.row].locationFormattedAddress)"
                cell.moreImage.isHidden = true
                if driversS1[indexPath.row].avatar != "" {
                    let url = URL(string: driversS1[indexPath.row].avatar)
                    cell.avatarImage.kf.setImage(with: url)
                    cell.avatarImage.roundCorners(cell.avatarImage.frame.width/2)
                    cell.avatarImage.clipsToBounds = true
                }
                
                return cell
                
            }
            
        }
        
        if indexPath.section == 1 {
            
                if myOrdersS4.count != 0,
                    driverS4.count != 0,
                    myOrdersS4.count == driverS4.count {
                    
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: "orderRequestTableViewCell",
                        for: indexPath) as? OrderRequestTableViewCell else {
                            return UITableViewCell()
                    }
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none
                    
                    let time = produceTime(orders: myOrdersS4, number: indexPath.row)
                    cell.requestName.text = driverS4[indexPath.row].userName
                    cell.requestTime.text = time
                    cell.requestLocation.text = "\(self.myOrdersS4[indexPath.row].locationFormattedAddress)"
                    cell.moreImage.isHidden = true
                    if driverS4[indexPath.row].avatar != "" {
                        let url = URL(string: driverS4[indexPath.row].avatar)
                        cell.avatarImage.kf.setImage(with: url)
                        cell.avatarImage.roundCorners(cell.avatarImage.frame.width/2)
                        cell.avatarImage.clipsToBounds = true
                    }
                    
                    return cell
                    
            }
            
        }
        
        if indexPath.section == 2 {
        
                if myOrdersS5.count != 0,
                    driverS5.count != 0,
                    myOrdersS5.count == driverS5.count {
                    
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: "orderRequestTableViewCell",
                        for: indexPath) as? OrderRequestTableViewCell else {
                            return UITableViewCell()
                    }
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none
                    
                    let time = produceTime(orders: myOrdersS5, number: indexPath.row)
                    cell.requestName.text = driverS5[indexPath.row].userName
                    cell.requestTime.text = time
                    cell.requestLocation.text = "\(self.myOrdersS5[indexPath.row].locationFormattedAddress)"
                    if driverS5[indexPath.row].avatar != "" {
                        let url = URL(string: driverS5[indexPath.row].avatar)
                        cell.avatarImage.kf.setImage(with: url)
                        cell.avatarImage.roundCorners(cell.avatarImage.frame.width/2)
                        cell.avatarImage.clipsToBounds = true
                    }
                    
                    
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
                
                return 140
                
            } else {
                
                return 40
            }
        }
        
        if indexPath.section == 1 {
            
            if myOrdersS4.count != 0,
                driverS4.count != 0,
                myOrdersS4.count == driverS4.count {
                
                return 140
                
            } else {
                
                return 40
            }
        }
        
        if indexPath.section == 2 {
            
            if myOrdersS5.count != 0,
                driverS5.count != 0,
                myOrdersS5.count == driverS5.count {
                
                return 140
                
            } else {
                
                return 40
            }
        }
        
        return CGFloat()
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            
            if self.myOrdersS5.count != 0 , self.driverS5.count != 0 {
                
                self.selectedOrder = self.myOrdersS5[indexPath.row]
                self.selectedDriver = self.driverS5[indexPath.row]
                
                performSegue(withIdentifier: "toMyOrderDetail", sender: self)
                
            }
            
        }
    }

}

