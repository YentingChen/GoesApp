//
//  FriendViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/6.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

class FriendListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FriendListTableViewCell", bundle: nil), forCellReuseIdentifier: "friendListTableViewCell")

    }

}

extension FriendListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendListTableViewCell", for: indexPath) as? FriendListTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "朋友列表(2)"
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

}
