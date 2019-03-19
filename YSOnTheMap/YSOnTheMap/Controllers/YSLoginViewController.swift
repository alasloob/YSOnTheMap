//
//  YSLoginViewController.swift
//  YSOnTheMap
//
//  Created by Youssef Eid on 07/07/1440 AH.
//  Copyright © 1440 Youssef Eid. All rights reserved.
//

import UIKit

class YSLoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    var alertIndicator = YSAlertIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.delegate = self
        password.delegate = self
    }
    
    @IBAction func login(_ sender: UIButton) {
        disabledUI(bool: false)
        if isValidate() {
            present(alertIndicator, animated: true) {
                YSClient.loginRequest(username: self.username.text!, password: self.password.text!) { (success, error) in
                    self.alertIndicator.dismiss(animated: true, completion: {
                        DispatchQueue.main.async {
                             if success {
                                self.performSegue(withIdentifier: "completeLogin", sender: nil)
                                self.disabledUI(bool: true)
                             } else {
                                YSAlert.show(title: "Error", message: (error?.domain)!, context: self)
                                self.disabledUI(bool: true)
                            }
                        }
                    })
                }
            }
        } else {
            disabledUI(bool: true)
            YSAlert.show(title: "Error", message: "all data is required", context: self)
        }
    }
    
    @IBAction func singup(_ sender: UIButton) {
        guard let url = URL(string: "https://auth.udacity.com/sign-up"), UIApplication.shared.canOpenURL(url) else {
            YSAlert.show(title: "Error", message: "Opps!, Please try angin a later", context: self)
            return
        }
        UIApplication.shared.open(url, options: [:])
    }
    
    fileprivate func isValidate() -> Bool {
        if let user = username.text,
        let pass = password.text,
        !user.trimmingCharacters(in: .whitespaces).isEmpty,
            !pass.trimmingCharacters(in: .whitespaces).isEmpty {
            return true
        }
        return false
    }
    
    fileprivate func disabledUI(bool: Bool) {
        username.isEnabled = bool
        password.isEnabled = bool
        btnLogin.isEnabled = bool
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

extension YSLoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
