//
//  ViewController.swift
//  Final Project
//
//  Created by Donga,Ashok Murali on 3/27/23.
//

import UIKit
import Firebase

class RootVC: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var loginBTN: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func login(_ sender: UIButton) {
        guard let email = usernameTF.text, !email.isEmpty else {
            showAlert(title: "", message: "Please enter Email-ID.")
            return
        }
        guard let password = passwordTF.text, !password.isEmpty else {
            showAlert(title: "", message: "Please enter password.")
            return
        }
        
        let auth = FirebaseAuth.Auth.auth()
        
        auth.signIn(withEmail: email, password: password) { authResult, error in
            guard let user = authResult?.user, error == nil else {
                print("Error: \(error!.localizedDescription)")
                return
            }
            print("User \(user.email!) has signed in successfully")
        }
    }
    
    @IBAction func userRegistration(_ sender: UIButton) {
        performSegue(withIdentifier: "registration", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueName = segue.identifier {
            switch segueName {
            case "registration":
                if let destinationVC = segue.destination as? RegistrationVC {
                    if let email = usernameTF.text {
                        destinationVC.email = email
                        if let password = passwordTF.text {
                            destinationVC.password = password
                        } else {
                            destinationVC.password = ""
                        }
                    }
                }
            default:
                break
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

