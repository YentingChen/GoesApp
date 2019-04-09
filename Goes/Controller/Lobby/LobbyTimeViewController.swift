//
//  LobbyTimeViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/5.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

class LobbyTimeViewController: UIViewController {
    let timeArray = [String]()

    @IBOutlet weak var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.isEnabled = false
        datePicker.isHidden = true
        datePicker.locale = Locale(identifier: "zh_CN")
        datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        datePicker.maximumDate = Calendar.current.date(byAdding: .day, value: +1, to: Date())

    }

    @IBAction func showClicked(_ sender: Any) {
        datePicker.isHidden = false
        datePicker.isEnabled = true
        loadViewIfNeeded()

    }

    @IBAction func dismissBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        self.navigationController?.dismiss(animated: true, completion: nil)
        present(LobbyViewController(), animated: true, completion: nil)
    }

}
