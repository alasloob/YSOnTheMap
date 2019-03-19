//
//  YSLoginRequest.swift
//  YSOnTheMap
//
//  Created by Youssef Eid on 07/07/1440 AH.
//  Copyright © 1440 Youssef Eid. All rights reserved.
//

import Foundation


struct YSLoginRequest: Codable {
    let username: String
    let password: String
}

struct YSUdacityLogin: Codable {
    let udacity: YSLoginRequest
}

struct YSUdacityLoginError: Codable {
    let status: Int
    let error: String
}
