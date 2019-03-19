//
//  YSMapViewController.swift
//  YSOnTheMap
//
//  Created by Youssef Eid on 07/07/1440 AH.
//  Copyright © 1440 Youssef Eid. All rights reserved.
//

import UIKit
import MapKit

class YSMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var indicator = YSAlertIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add delegate map view
        self.mapView.delegate = self
        // load data
        present(indicator, animated: true) {
            YSStudentDataInformation.shared.fetch() {
                error in
                self.indicator.dismiss(animated: true, completion: {
                    DispatchQueue.main.async {
                        if error != nil {
                            DispatchQueue.main.async {
                                YSAlert.show(title: "Error", message: (error?.domain)!, context: self)
                            }
                        } else {
                            self.loadData()
                        }
                    }
                })
            }
        }
        
    }
    
    @IBAction func refershData() {
        present(indicator, animated: true) {
            YSStudentDataInformation.shared.refersh() {
                error in
                self.indicator.dismiss(animated: true, completion: {
                    DispatchQueue.main.async {
                        if error != nil {
                            YSAlert.show(title: "Error", message: (error?.domain)!, context: self)
                        } else {
                            self.loadData()
                        }
                    }
                })
            }
        }
    }
    
    fileprivate func loadData() {
        let data = YSStudentDataInformation.shared.data
        if data.count > 0 {
            self.mapView.removeAnnotations(self.mapView.annotations)
            data.forEach({ (location) in
                self.addAnnotation(student: location)
            })
        }
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        YSClient.logout { (success, error) in
            self.dismiss(animated: true)
        }
    }
    
    fileprivate func addAnnotation(student: YSStudentInformation) {
        if let long = student.longitude,
            let lat = student.latitude, long != 0 && lat != 0 {
            let annotation = MKPointAnnotation()
            annotation.title = student.firstName! + " " + student.lastName!
            annotation.subtitle = student.mediaURL!
            annotation.coordinate = CLLocationCoordinate2DMake(lat, long)
            self.mapView.addAnnotation(annotation)
        }
    }
}

// MARK: Map View Delegate
extension YSMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        view.markerTintColor = .green
        view.glyphImage = UIImage(named: "icon_pin")
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
        let webButton = YSButton(frame: CGRect(origin: .zero, size: CGSize(width: 25, height: 32)))
        webButton.setBackgroundImage(#imageLiteral(resourceName: "icon_world"), for: .normal)
        webButton.urlLink = annotation.subtitle ?? ""
        webButton.addTarget(self, action: #selector(openURL(_:)), for: .touchUpInside)
        view.rightCalloutAccessoryView = webButton
        return view

    }
    
    @objc func openURL(_ sender: YSButton) {
        if let link = sender.urlLink {
            if let url = URL(string: link), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            } else {
                YSAlert.show(title: "Error", message: "Invalid link.", context: self)
            }
        }
    }
    
    
}

class YSButton: UIButton {
    var urlLink: String?
}
