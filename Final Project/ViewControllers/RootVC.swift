//
//  ViewController.swift
//  Final Project
//
//  Created by Donga,Ashok Murali on 3/27/23.
//

import UIKit

class RootVC: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var loginBTN: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func login(_ sender: UIButton) {
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
    
}

