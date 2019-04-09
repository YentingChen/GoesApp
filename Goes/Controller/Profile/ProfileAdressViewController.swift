//
//  ProfileAdressViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/7.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

class ProfileAdressViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ProfilePersonalTableViewCell", bundle: nil), forCellReuseIdentifier: "profilePersonalTableViewCell")

    }

}

extension ProfileAdressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = ["住家", "公司", "常用"]
        let content = ["台北市信義區吳興街300號", "台北市信義區基隆路一段180號", "台北市大安區羅斯福路四段1號"]
        let image = ["home_icon_hollow_24x", "work_icon_hollow_24x", "star_icon_hollow_24x"]
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
