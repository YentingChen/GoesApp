//
//  ProfilePersonalDataViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/7.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

class ProfilePersonalDataViewController: UIViewController {
    
    let userdefualt = UserDefaults.standard
    
    var myProfile: MyProfile?
    
    typealias CompletionHandler = (MyProfile?) -> Void
    var handler: CompletionHandler?
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewSetting()
        
        tableView.addRefreshHeader {
            self.loadDataFromDB()
        }
        
        tableView.beginHeaderRefreshing()
        
    }
        
    func loadDataFromDB() {
        
        guard  let uid = userdefualt.value(
            forKey: UserdefaultKey.memberUid.rawValue)  else {
            return
        }
        
        FireBaseManager.share.queryUserInfo(userID: "\(uid)") { (myProfile) in
            self.myProfile = myProfile
            self.tableView.reloadData()
            self.handler!(myProfile)
            self.tableView.endHeaderRefreshing()
        }
    }
    
    fileprivate func tableViewSetting() {
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.register(
            UINib(
                nibName: "ProfilePersonalTableViewCell",
                bundle: nil
            ),
            forCellReuseIdentifier: "profilePersonalTableViewCell"
        )
        
        tableView.separatorStyle = .none
    }
}

extension ProfilePersonalDataViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = ["姓名", "email", "手機"]
        let content = [myProfile?.userName, myProfile?.email, myProfile?.phoneNumber]
        let image = ["name_icon_24x", "email_icon_24x", "phone_icon_24x"]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "profilePersonalTableViewCell",
            for: indexPath) as? ProfilePersonalTableViewCell else { return UITableViewCell() }
        cell.cellTitle.text = title[indexPath.row]
        cell.cellContent.text = content[indexPath.row]
        
        cell.cellImageView.image = UIImage(named: image[indexPath.row] )
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.editImageView.isHidden = true

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func showEditingBox(title: String, message: String, placeholder: String, handler:((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title,
                                                message: message, preferredStyle: .alert)
        alertController.addTextField {
            
            (textField: UITextField!) -> Void in
            
            textField.placeholder = placeholder
            
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        let okAction = UIAlertAction(title: "確定", style: .default, handler: handler)
        
        alertController.addAction(cancelAction)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }

}
