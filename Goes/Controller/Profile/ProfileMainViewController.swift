//
//  ProfileMainViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/8.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit

class ProfileMainViewController: UIViewController {
    
    var profilePersonalVC: ProfilePersonalDataViewController?
    let personalDataManager = PersonalDataManager.share

    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self

        segmentedControl.addUnderlineForSelectedSegment()

        segmentedControl.removeBorder()

        profilePersonalVC?.handler = { (myInfo) in
            
            self.userName.text = myInfo?.userName
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toPersonalPage" {
        
            if let destination = segue.destination as? ProfilePersonalDataViewController {

                self.profilePersonalVC = destination
            }
        
        }
    }
   
    
    @IBAction func logOutBtn(_ sender: Any) {
        
        if FireAuthManager.share.getCurrentUser()?.id != nil {
        
            do {
                try FireAuthManager.share.auth.signOut()
                let alert = UIAlertController(title: "", message: "你已經成功登出", preferredStyle: .alert)
                let action = UIAlertAction(title: "確定", style: .default) { (action) in
                    
                    self.tabBarController?.dismiss(animated: true, completion: {
                        let tabStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let tabViewController = tabStoryboard.instantiateViewController(withIdentifier: "Goes") as? GoTabBarViewController

                        self.present(tabViewController!, animated: false, completion: nil)
                        
                        FireAuthManager.share.deleteListener()
                    
                    })
                    
                    
                }
                
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    func changeBtnView() {
        if scrollView.contentOffset.x == 0 {
            segmentedControl.selectedSegmentIndex = 0
            segmentedControl.changeUnderlinePosition()

        }
        if scrollView.contentOffset.x == scrollView.frame.size.width {
            segmentedControl.selectedSegmentIndex = 1
            segmentedControl.changeUnderlinePosition()

        }

        if scrollView.contentOffset.x == scrollView.frame.size.width*2 {
            segmentedControl.selectedSegmentIndex = 2
            segmentedControl.changeUnderlinePosition()

        }

    }

    @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl) {
        segmentedControl.changeUnderlinePosition()
        if sender.selectedSegmentIndex == 0 {
            scrollView.contentOffset.x = 0
        }

        if sender.selectedSegmentIndex == 1 {
            scrollView.contentOffset.x = scrollView.frame.size.width
        }

        if sender.selectedSegmentIndex == 2 {
            scrollView.contentOffset.x = scrollView.frame.size.width*2
        }
    }

}

extension ProfileMainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        changeBtnView()
    }

}
