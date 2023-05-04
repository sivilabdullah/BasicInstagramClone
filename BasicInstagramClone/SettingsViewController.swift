//
//  SettingsViewController.swift
//  BasicInstagramClone
//
//  Created by abdullah's Ventura on 5.05.2023.
//

import UIKit
import Firebase
class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logOutBtn(_ sender: Any) {
        
        do {
         try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toLogOut", sender: nil)
        }catch{
            print("Error")
        }
    }
    
}
