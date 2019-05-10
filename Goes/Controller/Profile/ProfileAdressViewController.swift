//
//  ProfileAdressViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/7.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

class ProfileAdressViewController: UIViewController {
    
    var addressHomeVC: AdressHomeViewController?
    
    var addressWorkVC: AdressWorkViewController?
    
    var addressFavoriteVC: AdressFavoriteViewController?

    var myProfile: MyProfile?
    
    var homeAddress, workAddress, favoriteAddress : Address?
    
    let userdefault = UserDefaults.standard
    
    @IBOutlet weak var tableView: UITableView!
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadAdressInfoFromDB()
        
        tableViewSetting()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SegueName.toAdressHomeVC.rawValue {
            
            if let destination = segue.destination as? AdressHomeViewController {
                
                self.addressHomeVC = destination
                
                destination.profileAddressVC = self
            }
            
        }
        
        if segue.identifier ==  SegueName.toAdressWorkVC.rawValue {
            
            if let destination = segue.destination as? AdressWorkViewController {
                
                self.addressWorkVC = destination
                
                destination.profileAddressVC = self
            }
            
        }
        
        if segue.identifier == SegueName.toAdressFavoriteVC.rawValue {
            
            if let destination = segue.destination as? AdressFavoriteViewController {
                
                self.addressFavoriteVC = destination
                
                destination.profileAddressVC = self
            }
            
        }
    }
    
    func loadAdressInfoFromDB() {
        
        guard let uid = userdefault.value(
            forKey: UserdefaultKey.memberUid.rawValue) as? String,
            uid != "" else { return }
        
        FireBaseManager.share.queryAdress(
        myUid: uid,
        category: "home") { (homeAddress) in
            self.homeAddress = homeAddress
            self.tableView.reloadData()
        }
        
        FireBaseManager.share.queryAdress(
        myUid: uid,
        category: "work") { (workAddress) in
            
            self.workAddress = workAddress
            self.tableView.reloadData()
        }
        
        FireBaseManager.share.queryAdress(
        myUid: uid,
        category: "favorite") { (favoriteAddress) in
            
            self.favoriteAddress = favoriteAddress
            self.tableView.reloadData()
        }
        
    }
    
    fileprivate func tableViewSetting() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: String(describing: ProfilePersonalTableViewCell.self),
                  bundle: nil),
            forCellReuseIdentifier: String(describing: ProfilePersonalTableViewCell.self))
        tableView.separatorStyle = .none
        
    }

}

extension ProfileAdressViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let title = [
            
            Title.home.rawValue,
            Title.company.rawValue,
            Title.favorite.rawValue
        ]
        
        let content = [
            
            self.homeAddress?.placeName,
            self.workAddress?.placeName,
            self.favoriteAddress?.placeName
        ]
        
        let images = [
            
            UIImage.asset(.Icons_24x_Home_Normal),
            UIImage.asset(.Icons_24x_Work_Normal),
            UIImage.asset(.Icons_24x_Star_Normal)
        ]
        
        guard let cell = tableView.dequeueReusableCell(
            
            withIdentifier: String(describing: ProfilePersonalTableViewCell.self),
            
            for: indexPath) as? ProfilePersonalTableViewCell else {
                
                return UITableViewCell()
                
        }
        
        cell.cellTitle.text = title[indexPath.row]
        
        cell.cellContent.text = content[indexPath.row]
        
        cell.cellImageView.image = images[indexPath.row]
        
        cell.editImageView.image = UIImage.asset(.Icons_24x_Edit_Normal)
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
            
        case 0:
            
            performSegue(
                withIdentifier: SegueName.toAdressHomeVC.rawValue,
                sender: self)
            
        case 1:
            
            performSegue(
                withIdentifier: SegueName.toAdressWorkVC.rawValue,
                sender: self)
            
        case 2:
            
            performSegue(
                withIdentifier: SegueName.toAdressFavoriteVC.rawValue,
                sender: self)
            
        default:
            
            return
            
        }
        
    }
    
}
