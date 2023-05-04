//
//  ViewController.swift
//  BasicInstagramClone
//
//  Created by abdullah's Ventura on 4.05.2023.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwdTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
    }

    @IBAction func logInBtn(_ sender: Any) {

        if userNameTF.text != "" && passwdTF.text != ""{
            Auth.auth().signIn(withEmail: userNameTF.text!, password: passwdTF.text!) { authData, error in
                if error != nil {
                    self.alert(title: "Login Error", message: error?.localizedDescription ?? "undefined error")
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else{
            alert(title: "Login Error", message: "username or password cannot be empty")
        }
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        if userNameTF.text != "" && passwdTF.text != "" {
            Auth.auth().createUser(withEmail: userNameTF.text!, password: passwdTF.text!) { authData, error in
                if error != nil {
                    self.alert(title: "Auth Error", message: error?.localizedDescription ?? "undefined error")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            alert(title: "Create user error", message: "username or password cannot be empty")
        }
    }
    
    func alert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton  = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(okButton)
        present(alert, animated: true)
        
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

