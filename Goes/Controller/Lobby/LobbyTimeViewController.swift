//
//  LobbyTimeViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/5.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

class LobbyTimeViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard
    var selectedLocation: Address?
    var selectedDateTime: DateAndTime?
    var laterTxt = "儘快"
    let timeArray = [String]()
    let test = ["今天", "明天"]
    var change = 0
    
    @IBOutlet weak var laterLabel: UILabel!
    
    @IBOutlet weak var aspsBtn: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var laterBtn: UIButton!
    
    @IBAction func toFriendView(_ sender: Any) {
        
        if let userID = userDefaults.value(forKey: UserdefaultKey.memberUid.rawValue) as? String, userID != "" {
            
             self.performSegue(withIdentifier: "toSelectFriendPage", sender: self)
            
        } else {
            
            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "askLogIn")
                as? AskLogInViewController
            loginVC?.modalPresentationStyle = .overCurrentContext
            
            self.present(loginVC!, animated: false, completion: nil)
           
        }
        
        
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentTime()
        showTodayArray()
        showTomorrowArray()
        pickerView.delegate = self
        pickerView.isHidden = true
        
        self.selectedDateTime = DateAndTime(
            
            date: currentDate,
            year: currentYear,
            month: currentMonth,
            time: "儘快", day: currentDay)
        
    }

    @IBAction func aspsBtnFunction(_ sender: Any) {
        
        laterBtn.setImage(UIImage(named: "Images_24px_RadioBtn_Normal"), for: .normal)
        aspsBtn.setImage(UIImage(named: "Images_24px_RadioBtn_Selected"), for: .normal)
        pickerView.isHidden = true
        laterLabel.text = "稍後"
        
        loadViewIfNeeded()
    }
    
    @IBAction func showClicked(_ sender: Any) {
        
        aspsBtn.setImage(UIImage(named: "Images_24px_RadioBtn_Normal"), for: .normal)
        laterBtn.setImage(UIImage(named: "Images_24px_RadioBtn_Selected"), for: .normal)
        pickerView.isHidden = false

        loadViewIfNeeded()
    }

    @IBAction func dismissBtn(_ sender: Any) {
        
        dismiss(animated: false, completion: nil)
        
        self.navigationController?.dismiss(animated: false, completion: nil)
        
        present(LobbyViewController(), animated: false, completion: nil)
        
    }
    
    var currentHour = 0
    var currentMin = 0
    var currentDate = Int()
    var currentMonth = 0
    var currentYear = 0
    var currentDay = 0
    var tomorrowDate = Int()
    var tomorrowMonth = 0
    var tomorrowYear = 0
    var tomorrowDay = 0
  
    var todayArray = [String]()
    var tomorrowArray = [String]()
    
    func currentTime() {
        let today = Date()
        let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: today)
        let tomorrow = today.dayAfter
        let tomorrowDateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: tomorrow)
        currentHour = dateComponents.hour!
        currentMin = dateComponents.minute!
        currentDate = Int((dateComponents.date?.timeIntervalSince1970)!)
        currentMonth = dateComponents.month!
        currentYear = dateComponents.year!
        currentDay = dateComponents.day!
        tomorrowDate = Int((tomorrowDateComponents.date?.timeIntervalSince1970)!)
        tomorrowYear = tomorrowDateComponents.year!
        tomorrowMonth = tomorrowDateComponents.month!
        tomorrowDay = tomorrowDateComponents.day!
    }
    
    func showTodayArray() {
        
        var minutes = -15
        let deleteCase = currentMin/15
        
        for hours in currentHour...23 {
            for _ in 0...3 {
                minutes += 15
                if hours/10 < 1 {
                    if minutes == 0 {
                        
                        todayArray.append("0\(hours):0\(minutes)")
                    } else {
                        
                        todayArray.append("0\(hours):\(minutes)")
                    }
                    
                } else {
                    if minutes == 0 {
                        
                        todayArray.append("\(hours):0\(minutes)")
                    } else {
                        
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
        
    }
    
    func showTomorrowArray() {
        
        var minutes = -15
        
        for hours in 0...23 {
            
            for _ in 0...3 {
                
                minutes += 15
                
                if hours/10 < 1 {
                    
                    if minutes == 0 {
                        
                        tomorrowArray.append("0\(hours):0\(minutes)")
                        
                    } else {
                        
                        tomorrowArray.append("0\(hours):\(minutes)")
                    }
                    
                } else {
                    
                    if minutes == 0 {
                        
                        tomorrowArray.append("\(hours):0\(minutes)")
                        
                    } else {
                        
                        tomorrowArray.append("\(hours):\(minutes)")
                    }
                    
                }
                
            }
            
            minutes = -15
        }
    
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSelectFriendPage" {
            if let destination = segue.destination as? LobbyFriendViewController {
                destination.selectedLocation = self.selectedLocation
                destination.selectedTime = self.selectedDateTime
            }
        }
    }
   
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
        
        let today = Date()
        
        let dateComponents = Calendar.current.dateComponents(
            in: TimeZone.current,
            from: today)
        
        var time = String()
        
        var day = String()
       
        if component == 0 {
            
            if change == 0 {
                
                change = 1
                laterLabel.text = "明天的 \(time)"
                self.selectedDateTime = DateAndTime(
                    date: tomorrowDate,
                    year: tomorrowYear,
                    month: tomorrowMonth,
                    time: time, day: tomorrowDay)
               
            } else {
                
                change = 0
                
                laterLabel.text = "今天的 \(time)"
                
                self.selectedDateTime = DateAndTime(
                    date: currentDate,
                    year: currentYear,
                    month: currentMonth,
                    time: time, day: currentDay)
               
            }
            
            pickerView.reloadComponent(1)
            day = test[pickerView.selectedRow(inComponent: 0)]
            
        } else {
            
            if change == 0 {
                if todayArray.count == 0 { return }
                
                time = todayArray[pickerView.selectedRow(inComponent: 1)]
                
                laterLabel.text = "今天的 \(time)"
                
                self.selectedDateTime = DateAndTime(
                    date: currentDate,
                    year: currentYear,
                    month: currentMonth,
                    time: time, day: currentDay)
                
            } else {
                
                if tomorrowArray.count == 0 { return }
                time = tomorrowArray[pickerView.selectedRow(inComponent: 1)]
                
                laterLabel.text = "明天的 \(time)"
                
                self.selectedDateTime = DateAndTime(
                    date: tomorrowDate,
                    year: tomorrowYear,
                    month: tomorrowMonth,
                    time: time, day: tomorrowDay)
               
            }
           
        }
        
    }

}
