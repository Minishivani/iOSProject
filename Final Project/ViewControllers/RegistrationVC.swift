//
//  Registration.swift
//  Final Project
//
//  Created by Sai Karthik Malyala on 4/2/23.
//

import UIKit
import Firebase

class RegistrationVC: UIViewController {
    
    
    @IBOutlet weak var firstNameTF: UITextField!
    
    @IBOutlet weak var middleNameTF: UITextField!
    
    @IBOutlet weak var lastNameTF: UITextField!
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    @IBOutlet weak var signUpBTN: UIButton!
    
    
    var email: String = ""
    var password: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if email != "" {
            emailTF.text = email
            if password != "" {
                passwordTF.text = password
            }
        }
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        guard let firstName = firstNameTF.text, !firstName.isEmpty else {
            showAlert(title: "", message: "Please enter First name.")
            return
        }
        guard let lastName = lastNameTF.text, !lastName.isEmpty else {
            showAlert(title: "", message: "Please enter Last name.")
            return
        }
        guard let email = emailTF.text, !email.isEmpty else {
            showAlert(title: "", message: "Please enter Email-ID.")
            return
        }
        guard NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}").evaluate(with: email) else {
            showAlert(title: "", message: "Please enter validate Email-ID.")
            return
        }
        guard let password = passwordTF.text, !password.isEmpty else {
            showAlert(title: "", message: "Please enter password.")
            return
        }
        guard let confirmPassword = confirmPasswordTF.text, !confirmPassword.isEmpty else {
            showAlert(title: "", message: "Please enter confirm password.")
            return
        }
        guard password == confirmPasswordTF.text else {
            showAlert(title: "", message: "Password and confirm password are not matching.")
            return
        }
        guard password.count > 5 else {
            showAlert(title: "", message: "Password length must be atleast 6 characters.")
            return
        }
        guard let middleName = middleNameTF.text else {return}
        
        let auth = FirebaseAuth.Auth.auth()
        
        auth.fetchSignInMethods(forEmail: email) { (providers, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let providers = providers {
                if providers.count > 0 {
                    let alert = UIAlertController(title: "", message: "User already exists", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
                        self.navigationController?.popToRootViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
        }
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            } else if let authResult = authResult {
                let db = Firestore.firestore()
                let userRef = db.collection("users").document(authResult.user.uid)
                userRef.setData(["firstname": firstName])
                if !middleName.isEmpty {
                    userRef.setData(["middlename": middleName])
                }
                userRef.setData(["lastname": lastName])
            }
            let alert = UIAlertController(title: "", message: "User registered successfully.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
                self.navigationController?.popToRootViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func toLoginPage(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
