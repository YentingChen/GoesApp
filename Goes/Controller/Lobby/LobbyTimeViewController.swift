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
    let test = ["今天", "明天"]

    @IBOutlet weak var aspsBtn: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var laterBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentTime()
        showTodayArray()
        showTomorrowArray()
        pickerView.delegate = self
        pickerView.isHidden = true
    }

    @IBAction func aspsBtnFunction(_ sender: Any) {
        laterBtn.setImage(UIImage(named: "Images_24px_RadioBtn_Normal"), for: .normal)
        aspsBtn.setImage(UIImage(named: "Images_24px_RadioBtn_Selected"), for: .normal)
        pickerView.isHidden = true
        
        loadViewIfNeeded()
    }
    
    @IBAction func showClicked(_ sender: Any) {
        aspsBtn.setImage(UIImage(named: "Images_24px_RadioBtn_Normal"), for: .normal)
        laterBtn.setImage(UIImage(named: "Images_24px_RadioBtn_Selected"), for: .normal)
        pickerView.isHidden = false

        loadViewIfNeeded()
    }

    @IBAction func dismissBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        self.navigationController?.dismiss(animated: true, completion: nil)
        present(LobbyViewController(), animated: true, completion: nil)
    }
    
    var currentHour = 0
    var currentMin = 0
    
    var todayArray = [String]()
    var tomorrowArray = [String]()
    
    func currentTime() {
        let today = Date()
        let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: today)
        currentHour = dateComponents.hour!
        currentMin = dateComponents.minute!
    }
    
    func showTodayArray() {
        
        var minutes = -15
        var deleteCase = currentMin/15
        
        for hours in currentHour...23 {
            for _ in 0...3 {
                minutes += 15
                if hours/10 < 1 {
                    if minutes == 0 {
                        
                        todayArray.append("0\(hours):0\(minutes)")
                    }else{
                        
                        todayArray.append("0\(hours):\(minutes)")
                    }
                }else{
                    if minutes == 0 {
                        
                        todayArray.append("\(hours):0\(minutes)")
                    }else {
                        
                        todayArray.append("\(hours):\(minutes)")
                    }
                    
                }
                
            }
            minutes = -15
        }
        
        switch deleteCase {
        case 0 :
            todayArray.remove(at: 0)
            todayArray.remove(at: 0)
        case 1 :
            todayArray.remove(at: 0)
            todayArray.remove(at: 0)
            todayArray.remove(at: 0)
        case 2:
            todayArray.remove(at: 0)
            todayArray.remove(at: 0)
            todayArray.remove(at: 0)
            todayArray.remove(at: 0)
        case 3:
            todayArray.remove(at: 0)
            todayArray.remove(at: 0)
            todayArray.remove(at: 0)
            todayArray.remove(at: 0)
            todayArray.remove(at: 0)
        default:
            break
        }
        
        print(todayArray)
    }
    
    func showTomorrowArray() {
        var minutes = -15
        for hours in 0...23 {
            for _ in 0...3 {
                minutes += 15
                if hours/10 < 1 {
                    if minutes == 0 {
                        
                        tomorrowArray.append("0\(hours):0\(minutes)")
                    }else{
                        
                        tomorrowArray.append("0\(hours):\(minutes)")
                    }
                }else{
                    if minutes == 0 {
                        
                        tomorrowArray.append("\(hours):0\(minutes)")
                    }else {
                        
                        tomorrowArray.append("\(hours):\(minutes)")
                    }
                    
                }
                
            }
            minutes = -15
        }
    
    }
    var change = 0

  
}
extension LobbyTimeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 2
        }
        if component == 1 {
            
            if change == 0 {
                 return todayArray.count
            } else {
                return tomorrowArray.count
            }
           
        }
        return Int()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return test[row]
        }
        
        if component == 1 {
            if change == 0 {
                return todayArray[row]
            } else {
                return tomorrowArray[row]
            }
            
        }
        return String()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            if change == 0 {
                change = 1
            } else {
                change = 0
            }
            pickerView.reloadComponent(1)
            print(test[pickerView.selectedRow(inComponent: 0)])
            
        } else {
            if change == 0 {
                 print(todayArray[pickerView.selectedRow(inComponent: 1)])
                
            } else {
                print(tomorrowArray[pickerView.selectedRow(inComponent: 1)])
            }
           
        }
    }

}
