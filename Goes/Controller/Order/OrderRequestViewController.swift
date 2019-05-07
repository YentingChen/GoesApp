//
//  OrderRequestViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/8.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import Kingfisher

class OrderRequestViewController: UIViewController {
    
    let fireAuthManager = FireAuthManager.share
    let personalDataManager = PersonalDataManager.share
    let fireBaseManager = FireBaseManager.share
    var myProfile: MyProfile?
    
    var myOrdersS2 = [OrderDetail]()
    var myOrdersS3 = [OrderDetail]()
    var myOrdersS6 = [OrderDetail]()
    
    var ridersS2 = [MyProfile]()
    var ridersS3 = [MyProfile]()
    var ridersS6 = [MyProfile]()
    
    var selectedOrder: OrderDetail?
    var selectedRider: MyProfile?
    
    let group = DispatchGroup()
   
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableViewSetting()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
            tableView.addRefreshHeader {
                
                self.loadDataAction()
                
            }
            
            self.tableView.beginHeaderRefreshing()
        
        
    
    }
    
    func loadDataAction() {
        
        myOrdersS2 = []
        myOrdersS3 = []
        myOrdersS6 = []
        
        ridersS2 = []
        ridersS3 = []
        ridersS6 = []
//        tableView.reloadData()
        
        self.loadDataFromDB()
        
    }
    
    func loadDataFromDB() {
        
        self.group.enter()
        
        personalDataManager.getPersonalData { [weak self] (myProfile, _) in
            
            self?.myProfile = myProfile
            
            self?.group.enter()
            
            self?.fireBaseManager.queryMyOrders(myUid: (myProfile?.userID)!, status: 2, completionHandler: { [weak self] (orders) in
                
                self?.myOrdersS2 = orders
                for order in orders {
                    
                    self?.group.enter()
                    self?.fireBaseManager.queryUserInfo(userID: order.riderUid, completion: { [weak self] (rider) in
                        
                        self?.ridersS2.append(rider!)
                        
                        print(rider as Any)
                        
                        self?.group.leave()
                        //self.tableView.reloadData()
                        
                    })
                    
                }
                
                self?.group.leave()
            })
            
            self?.group.enter()
            self?.fireBaseManager.queryMyOrders(myUid: (myProfile?.userID)!, status: 3, completionHandler: { [weak self]  (orders) in
                
                self?.myOrdersS3 = orders
                
                for order in orders {
                    self?.group.enter()
                    self?.fireBaseManager.queryUserInfo(userID: order.riderUid, completion: { [weak self] (rider) in
                        self?.ridersS3.append(rider!)
                        print(rider as Any)
                        //self.tableView.reloadData()
                        self?.group.leave()
                        
                    })
                    
                }
                
                self?.group.leave()
            })
            
            self?.group.enter()
            self?.fireBaseManager.queryMyOrders(myUid: (myProfile?.userID)!, status: 6, completionHandler: { [weak self]  (orders) in
                
                self?.myOrdersS6 = orders
                
                for order in orders {
                    
                    self?.group.enter()
                    
                    self?.fireBaseManager.queryUserInfo(userID: order.riderUid, completion: { [weak self]  (rider) in
                        self?.ridersS6.append(rider!)
                        print(rider as Any)
                        //self.tableView.reloadData()
                        
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
    
    fileprivate func tableViewSetting() {
        
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
                return "\(orders[number].selectTimeDay)"
            }
        }()
       
        let time = orders[number].selectTimeTime
        return "\(year)/\(month)/\(day)   \(time)"
    }
    
   
}

extension OrderRequestViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "orderRequestHeaderTableViewCell") as? OrderRequestHeaderTableViewCell else { return UITableViewCell() }
            cell.titleLabel.text = "待回覆"
            
            return cell
            
        }
        
        if section == 1 {
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "orderRequestHeaderTableViewCell") as? OrderRequestHeaderTableViewCell else { return UITableViewCell() }
            cell.titleLabel.text = "準備中"
            
            return cell
            
        }
        
        if section == 2 {
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "orderRequestHeaderTableViewCell") as? OrderRequestHeaderTableViewCell else { return UITableViewCell() }
            cell.titleLabel.text = "進行中"
            
            return cell
            
        }
        
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int)
        -> CGFloat {
            
        return 23
            
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int)
        -> Int {
    
            if section == 0 {
                
                if myOrdersS2.count != 0,
                    ridersS2.count != 0,
                    myOrdersS2.count == ridersS2.count {
                    
                    return self.myOrdersS2.count
                }
                
                return 1
                
            }
            
            if section == 1 {
                
                if myOrdersS3.count != 0,
                    ridersS3.count != 0,
                    myOrdersS3.count == ridersS3.count {
                    
                    return self.myOrdersS3.count
                    
                } else {
                    
                    return 1
                }
            }
        
        if section == 2 {
            
            if myOrdersS6.count != 0,
                ridersS6.count != 0,
                myOrdersS6.count == ridersS6.count {
                
                return self.myOrdersS6.count
                
            } else {
                
                return 1
            }
            
        }

        return Int()
    }

    func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
        if indexPath.section == 0 {
            
            if myOrdersS2.count != 0,
                ridersS2.count != 0,
                myOrdersS2.count == ridersS2.count {
                
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "orderRequestTableViewCell",
                    for: indexPath) as? OrderRequestTableViewCell else {
                        return UITableViewCell()
                }
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
               
                let time = produceTime(orders: myOrdersS2, number: indexPath.row)
                cell.requestName.text = ridersS2[indexPath.row].userName
                cell.requestTime.text = time
                cell.requestLocation.text = "\(self.myOrdersS2[indexPath.row].locationFormattedAddress)"
                if ridersS2[indexPath.row].avatar != "" {
                    let url = URL(string: ridersS2[indexPath.row].avatar)
                    cell.avatarImage.kf.setImage(with: url)
                    cell.avatarImage.roundCorners(cell.avatarImage.frame.width/2)
                    cell.avatarImage.clipsToBounds = true
                }
                return cell
            }
        
        }
        
        if indexPath.section == 1 {
            
            if myOrdersS3.count != 0,
                ridersS3.count != 0,
                myOrdersS3.count == ridersS3.count {
                
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "orderRequestTableViewCell",
                    for: indexPath) as? OrderRequestTableViewCell else { return UITableViewCell() }
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                
                let time = produceTime(orders: myOrdersS3, number: indexPath.row)
                cell.requestName.text = ridersS3[indexPath.row].userName
                cell.requestTime.text = time
                cell.requestLocation.text = "\(self.myOrdersS3[indexPath.row].locationFormattedAddress)"
                if ridersS3[indexPath.row].avatar != "" {
                    let url = URL(string: ridersS3[indexPath.row].avatar)
                    cell.avatarImage.kf.setImage(with: url)
                    cell.avatarImage.roundCorners(cell.avatarImage.frame.width/2)
                    cell.avatarImage.clipsToBounds = true
                }
                return cell
                
            }
            
        }
        
        if indexPath.section == 2 {
            
            if myOrdersS6.count != 0,
                ridersS6.count != 0,
                myOrdersS6.count == ridersS6.count {
                
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "orderRequestTableViewCell",
                    for: indexPath) as? OrderRequestTableViewCell else { return UITableViewCell() }
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                
                let time = produceTime(orders: myOrdersS6, number: indexPath.row)
                cell.requestName.text = ridersS6[indexPath.row].userName
                cell.requestTime.text = time
                cell.requestLocation.text = "\(self.myOrdersS6[indexPath.row].locationFormattedAddress)"
                if ridersS6[indexPath.row].avatar != "" {
                    let url = URL(string: ridersS6[indexPath.row].avatar)
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

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath)
        -> CGFloat {
            
        if indexPath.section == 0 {
            
            if myOrdersS2.count != 0,
                ridersS2.count != 0,
                myOrdersS2.count == ridersS2.count {
                
                return 140
                
            } else {
                
                return 40
            }
        }
            
        if indexPath.section == 1 {
                
                if myOrdersS3.count != 0,
                    ridersS3.count != 0,
                    myOrdersS3.count == ridersS3.count {
                    
                    return 140
                    
                } else {
                    
                    return 40
                }
            }
            
        if indexPath.section == 2 {
                
                if myOrdersS6.count != 0,
                    ridersS6.count != 0,
                    myOrdersS6.count == ridersS6.count {
                    
                    return 140
                    
                } else {
                    
                    return 40
                }
            }
            
        return CGFloat()
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            if myOrdersS2.count != 0,
                ridersS2.count != 0,
                myOrdersS2.count == ridersS2.count {

                self.selectedOrder = myOrdersS2[indexPath.row]
                self.selectedRider = ridersS2[indexPath.row]
                performSegue(withIdentifier: "toBeAnswered", sender: self)

            }
            
        }
        
        if indexPath.section == 1 {
            
            if myOrdersS3.count != 0,
                ridersS3.count != 0,
                myOrdersS3.count == ridersS3.count {

                self.selectedOrder = myOrdersS3[indexPath.row]
                self.selectedRider = ridersS3[indexPath.row]
                performSegue(withIdentifier: "toDrivingView", sender: self)
            }
        
        }
        
        if indexPath.section == 2 {
            
            if myOrdersS6.count != 0,
                ridersS6.count != 0,
                myOrdersS6.count == ridersS6.count {
                
                self.selectedOrder = myOrdersS6[indexPath.row]
                self.selectedRider = ridersS6[indexPath.row]
                performSegue(withIdentifier: "toDrivingView", sender: self)
            }
            
        }

    }
}
