//
//  YSListTableViewController.swift
//  YSOnTheMap
//
//  Created by Youssef Eid on 07/07/1440 AH.
//  Copyright © 1440 Youssef Eid. All rights reserved.
//

import UIKit

class YSListTableViewController: UITableViewController {

    var indicator = YSAlertIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.present(indicator, animated: true) {
            YSStudentDataInformation.shared.fetch() {
                error in
                self.indicator.dismiss(animated: true, completion: {
                    DispatchQueue.main.async {
                        if error != nil {
                            YSAlert.show(title: "Error", message: (error?.domain)!, context: self)
                        } else {
                            self.tableView.reloadData()
                        }
                    }
                })
            }
        }
    }
    
    @IBAction func refershData() {
        self.present(self.indicator, animated: true) {
            YSStudentDataInformation.shared.refersh() {
                error in
                self.indicator.dismiss(animated: true, completion: {
                    DispatchQueue.main.async {
                        if error != nil {
                            YSAlert.show(title: "Error", message: (error?.domain)!, context: self)
                        } else {
                            self.tableView.reloadData()
                        }
                    }
                })
            }
        }
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        YSClient.logout { (success, error) in
            self.dismiss(animated: true)
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return YSStudentDataInformation.shared.data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentsCell", for: indexPath)
        // Configure the cell...
        let sutudentLocation = YSStudentDataInformation.shared.data[indexPath.row]
        if let firstName = sutudentLocation.firstName, let lastName = sutudentLocation.lastName, let mediaURL = sutudentLocation.mediaURL {
            cell.textLabel?.text = firstName + " " + lastName
            cell.detailTextLabel?.text = mediaURL
            cell.imageView?.image = #imageLiteral(resourceName: "icon_pin")
        } 
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sutudentLocation = YSStudentDataInformation.shared.data[indexPath.row]
        if let mediaURL = sutudentLocation.mediaURL {
            self.openURL(stringURL: mediaURL)
        }
    }
    
    func openURL(stringURL url: String) {
        if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        } else {
            YSAlert.show(title: "Error", message: "Invalid link.", context: self)
        }
    }

}
