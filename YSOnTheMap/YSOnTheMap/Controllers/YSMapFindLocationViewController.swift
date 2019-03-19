//
//  YSMapFindLocationViewController.swift
//  YSOnTheMap
//
//  Created by Youssef Eid on 09/07/1440 AH.
//  Copyright © 1440 Youssef Eid. All rights reserved.
//

import UIKit
import MapKit

class YSMapFindLocationViewController: UIViewController {

    @IBOutlet weak var mapView:MKMapView!
    
    var indicator: YSAlertIndicator = YSAlertIndicator()
    var location: CLLocation!
    var locationName: String!
    var website: String!
    var firstName: String!
    var lastName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addLocations(location: self.location)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                 target: self, action: #selector(dismissVC(_:)))
        // get fake data of user
        YSClient.getFakeData { (firstName, lastName, error) in
            if let error = error {
                YSAlert.show(title: "Error", message: error.localizedDescription, context: self)
            } else {
                self.firstName = firstName
                self.lastName = lastName
            }
        }
    }
    
    
    private func addLocations(location: CLLocation) {
        if self.mapView.annotations.count > 0 {
            self.mapView.removeAnnotations(self.mapView.annotations)
        }
        let annotation = MKPointAnnotation()
        annotation.title = self.locationName
        annotation.subtitle = self.website
        annotation.coordinate = location.coordinate
        self.mapView.addAnnotation(annotation)
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
    
    @IBAction func dismissVC(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    // HdZ48b61bm -- 1UNsipJIuj - zW3CgLg5Ue -- bnUD9aAycF
    @IBAction func finishAndSendDataToServer() {
        // objectId
        self.sendDataToServer()
        // When you update data use this function
        // self.updateDataAndSendToServer(objectId: "HdZ48b61bm")
    }
    
    fileprivate func sendDataToServer() {
        let newData = YSSendStudentLocation(firstName: self.firstName!,
                                            lastName: self.lastName!,
                                            latitude: location.coordinate.latitude - Double.random(in: 1.3...3.9),
                                            longitude: location.coordinate.longitude + Double.random(in: 1.3...3.9),
                                            mapString: self.locationName!, mediaURL: self.website!,
                                            uniqueKey: nil)
        self.present(self.indicator, animated: true) {
            YSClient.postStudentLocaiton(bodyData: newData) {
                success, error in
                self.indicator.dismiss(animated: true) {
                    DispatchQueue.main.async {
                        if let error = error {
                            YSAlert.show(title: "Error", message: error.localizedDescription, context: self)
                        } else {
                            YSAlert.showWithCompletion(title: "info", message: "Successfully!", context: self) {
                                actions in
                                print("Dismiss finsih")
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func updateDataAndSendToServer(objectId: String) {
        let data = YSSendStudentLocation(firstName: self.firstName!,
                                            lastName: self.lastName!,
                                            latitude: location.coordinate.latitude - Double.random(in: 1.3...3.9),
                                            longitude: location.coordinate.longitude + Double.random(in: 1.3...3.9),
                                            mapString: self.locationName!, mediaURL: self.website!,
                                            uniqueKey: nil)
        self.present(self.indicator, animated: true) {
            YSClient.putStudentLocation(id: objectId,bodyData: data) {
                success, error in
                self.indicator.dismiss(animated: true) {
                    DispatchQueue.main.async {
                        if let error = error {
                            YSAlert.show(title: "Error", message: error.localizedDescription, context: self)
                        } else {
                            YSAlert.showWithCompletion(title: "info", message: "Successfully!", context: self) {
                                actions in
                                print("Dismiss finsih")
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
}
