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

    @IBOutlet weak var aspsBtn: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var laterBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerDefaultSetting()
    }

    @IBAction func aspsBtnFunction(_ sender: Any) {
        laterBtn.setImage(UIImage(named: "Images_24px_RadioBtn_Normal"), for: .normal)
        aspsBtn.setImage(UIImage(named: "Images_24px_RadioBtn_Selected"), for: .normal)
        datePicker.isHidden = true
        datePicker.isEnabled = false
        loadViewIfNeeded()
    }
    
    @IBAction func showClicked(_ sender: Any) {
        aspsBtn.setImage(UIImage(named: "Images_24px_RadioBtn_Normal"), for: .normal)
        laterBtn.setImage(UIImage(named: "Images_24px_RadioBtn_Selected"), for: .normal)

        datePicker.isHidden = false
        datePicker.isEnabled = true
        loadViewIfNeeded()
    }

    @IBAction func dismissBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        self.navigationController?.dismiss(animated: true, completion: nil)
        present(LobbyViewController(), animated: true, completion: nil)
    }
    
    func datePickerDefaultSetting() {
        datePicker.isEnabled = false
        datePicker.isHidden = true
        datePicker.locale = Locale(identifier: "zh_CN")
        datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())
        datePicker.maximumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
    }

}
