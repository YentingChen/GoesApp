//
//  LaunchViewController.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/11.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LaunchViewController: UIViewController {

    @IBOutlet weak var testes: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    var lastchane: (() -> Void)?
    
    func getData(completion: @escaping () -> Void ) {
//        completion()
        lastchane = completion
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        UIView.animate(withDuration: 100) {
//            self.testes.alpha = 0.5
//            self.getData {
//                Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
//
//                    guard user != nil else {
//
//                        //Login
//
//                        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
//
//                        let vc = storyboard.instantiateViewController(withIdentifier: "SignUp")
//                        self?.present(vc, animated: true, completion: nil)
//
//                        return
//                    }
//
//                    //Lobby
//
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//                    let vc = storyboard.instantiateViewController(withIdentifier: "Goes")
//                    self?.present(vc, animated: true, completion: nil)
//
//                }
//            }
//
//        }
    
        UIView.animate(
            withDuration: 3,
            animations: {
                self.testes.alpha = 0.0
//                let storyboard = UIStoryboard(name: "Auth", bundle: nil)
//
//                let vc = storyboard.instantiateViewController(withIdentifier: "SignUp")
//
//                let delegate = UIApplication.shared.delegate as? AppDelegate
//
//                delegate!.window?.rootViewController = vc
                
//                self.present(vc, animated: true, completion: nil)
            }, completion: { _ in
                Auth.auth().addStateDidChangeListener { [weak self] (_, user) in

                    guard user != nil else {

                        //Login

                        let storyboard = UIStoryboard(name: "Auth", bundle: nil)

                        let vc = storyboard.instantiateViewController(withIdentifier: "SignUp")
                        self?.present(vc, animated: true, completion: nil)

                        return
                    }

                    //Lobby

                    let storyboard = UIStoryboard(name: "Main", bundle: nil)

                    let vc = storyboard.instantiateViewController(withIdentifier: "Goes")
                    self?.present(vc, animated: true, completion: nil)

                }
            }
        )
        self.lastchane?()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
