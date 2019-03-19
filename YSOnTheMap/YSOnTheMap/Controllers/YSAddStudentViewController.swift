//
//  YSAddStudentViewController.swift
//  YSOnTheMap
//
//  Created by Youssef Eid on 09/07/1440 AH.
//  Copyright © 1440 Youssef Eid. All rights reserved.
//

import UIKit
import CoreLocation

class YSAddStudentViewController: UIViewController {

    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var webisteTF: UITextField!
    var indicator = YSAlertIndicator()
    var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTF.delegate = self
        webisteTF.delegate = self
    }
    
    @IBAction func findLocatoin(_ sender: UIButton) {
        if checkTextField() {
            if isLinkURL() {
                present(indicator, animated: true) {
                    self.geocoder.geocodeAddressString(self.locationTF.text!) { (placemarkers, error) in
                        if let error = error {
                            self.indicator.dismiss(animated: true) {
                                DispatchQueue.main.async {
                                    YSAlert.show(title: "Error", message: "Unable to Forward Geocode Address (\(error))", context: self)
                                }
                            }
                        } else {
                            self.indicator.dismiss(animated: true) {
                                DispatchQueue.main.async {
                                    var location: CLLocation?
                                    if let placemarks = placemarkers, placemarks.count > 0 {
                                        location = placemarks.first?.location
                                    }
                                    if let location = location {
                                        self.sendNextViewController(location: location)
                                    } else {
                                        YSAlert.show(title: "Info", message: "No Matching Location Found", context: self)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func sendNextViewController(location: CLLocation) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ShowLocation") as? YSMapFindLocationViewController {
            vc.locationName = self.locationTF.text
            vc.website = self.webisteTF.text
            vc.location = location
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func checkTextField() -> Bool {
        if locationTF.text?.trimmingCharacters(in: .whitespaces).isEmpty == true
           || webisteTF.text?.trimmingCharacters(in: .whitespaces).isEmpty == true {
            YSAlert.show(title: "Attention", message: "All of the input text is required", context: self)
            return false
        } else {
            return true
        }
    }
    
    fileprivate func isLinkURL() -> Bool {
        if let url = webisteTF.text, UIApplication.shared.canOpenURL(URL(string: url)!) {
            return true
        }
        return false
    }
    
    @IBAction func dismissVC(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

extension YSAddStudentViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
