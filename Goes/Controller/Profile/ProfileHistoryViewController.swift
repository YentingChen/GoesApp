//
//  ProfileHistoryViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/7.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

class ProfileHistoryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ProfileHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "profileHistoryTableViewCell")
        tableView.separatorStyle = .none
       
        
    }
    
}

extension ProfileHistoryViewController: UITableViewDelegate, UITableViewDataSource {
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileHistoryTableViewCell", for: indexPath) as? ProfileHistoryTableViewCell else { return UITableViewCell()}
        return cell
        return UITableViewCell()
    }
    
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 &&  indexPath.row == 0 {
            performSegue(withIdentifier: "test3", sender: self)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
   
    
}
