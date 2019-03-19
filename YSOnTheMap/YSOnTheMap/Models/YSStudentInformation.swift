//
//  YSStudentLocation.swift
//  YSOnTheMap
//
//  Created by Youssef Eid on 07/07/1440 AH.
//  Copyright © 1440 Youssef Eid. All rights reserved.
//

import Foundation

struct YSStudentInformation: Codable {
    let firstName: String?
    let lastName: String?
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let uniqueKey: String?
    let objectId: String
    let createdAt: String
    let updatedAt: String
}

struct YSStudentData: Codable {
    let results: [YSStudentInformation]
}


struct YSSendStudentLocation: Codable {
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let uniqueKey: String?
}
