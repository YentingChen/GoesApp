//
//  ProfileAdressViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/7.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import GooglePlaces

class ProfileAdressViewController: UIViewController {
    
    var addressHomeVC: AdressHomeViewController?
    var addressWorkVC: AdressWorkViewController?
    var addressFavoriteVC: AdressFavoriteViewController?
    
    var personalDataManager = PersonalDataManager.share
    var firebaseManager = FireBaseManager.share
    var myProfile: MyProfile?
    var homeAddress: Address?
    var workAddress: Address?
    var favoriteAddress: Address?
    
    @IBOutlet weak var tableView: UITableView!
    
     func loadAdressInfoFromDB() {
        
        personalDataManager.getPersonalData { (myProfile, err) in
            self.myProfile = myProfile
            self.firebaseManager.queryAdress(myUid: (myProfile?.userID)!, category: "home", completionHandler: { (homeAddress) in
                self.homeAddress = homeAddress
                self.tableView.reloadData()
            })
            
            self.firebaseManager.queryAdress(myUid: (myProfile?.userID)!, category: "work", completionHandler: { (workAddress) in
                self.workAddress = workAddress
                self.tableView.reloadData()
            })
            
            self.firebaseManager.queryAdress(myUid: (myProfile?.userID)!, category: "favorite", completionHandler: { (favoriteAddress) in
                self.favoriteAddress = favoriteAddress
                self.tableView.reloadData()
            })
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAdressInfoFromDB()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: "ProfilePersonalTableViewCell",
                  bundle: nil),
            forCellReuseIdentifier: "profilePersonalTableViewCell")
        tableView.separatorStyle = .none

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAdressHomeVC" {
            
            if let destination = segue.destination as? AdressHomeViewController {
                
                self.addressHomeVC = destination
                
                destination.profileAddressVC = self
            }
            
        }
        
        if segue.identifier == "toAdressWorkVC" {
            
            if let destination = segue.destination as? AdressWorkViewController {
                
                self.addressWorkVC = destination
                
                destination.profileAddressVC = self
            }
            
        }
        
        if segue.identifier == "toAdressFavoriteVC" {
            
            if let destination = segue.destination as? AdressFavoriteViewController {
                
                self.addressFavoriteVC = destination
                
                destination.profileAddressVC = self
            }
            
        }
    }

}

extension ProfileAdressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = ["住家", "公司", "常用"]
        let content = [self.homeAddress?.placeName, self.workAddress?.placeName, self.favoriteAddress?.placeName]
        let image = ["home_icon_hollow_24x", "work_icon_hollow_24x", "star_icon_hollow_24x"]
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "profilePersonalTableViewCell",
            for: indexPath) as? ProfilePersonalTableViewCell else { return UITableViewCell() }
        
        cell.cellTitle.text = title[indexPath.row]
        
        cell.cellContent.text = content[indexPath.row]
        
        cell.cellImageView.image = UIImage(named: image[indexPath.row] )
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            performSegue(withIdentifier: "toAdressHomeVC", sender: self)
        }
        
        if indexPath.row == 1 {
            performSegue(withIdentifier: "toAdressWorkVC", sender: self)
        }
        
        if indexPath.row == 2 {
            performSegue(withIdentifier: "toAdressFavoriteVC", sender: self)
        }
    }
    
}
