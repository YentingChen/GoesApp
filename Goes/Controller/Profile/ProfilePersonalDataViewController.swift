//
//  ProfilePersonalDataViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/7.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

class ProfilePersonalDataViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ProfilePersonalTableViewCell", bundle: nil), forCellReuseIdentifier: "profilePersonalTableViewCell")
        tableView.separatorStyle = .none

    }

}

extension ProfilePersonalDataViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = ["姓名", "email", "手機"]
        let content = ["Yenting Chen", "yenting@gmail.com", "0988888888"]
        let image = ["name_icon_24x", "email_icon_24x", "phone_icon_24x"]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "profilePersonalTableViewCell", for: indexPath) as? ProfilePersonalTableViewCell else { return UITableViewCell() }
        cell.cellTitle.text = title[indexPath.row]
        cell.cellContent.text = content[indexPath.row]
        cell.cellImageView.image = UIImage(named: image[indexPath.row] )

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

}
