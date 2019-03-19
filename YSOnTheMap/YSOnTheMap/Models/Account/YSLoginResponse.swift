//
//  YSLoginResponse.swift
//  YSOnTheMap
//
//  Created by Youssef Eid on 07/07/1440 AH.
//  Copyright © 1440 Youssef Eid. All rights reserved.
//

import Foundation

struct YSAccount: Codable {
    let registered: Bool
    let key: String
}

struct YSSession: Codable {
    let id: String
    let expiration: String
}


struct YSLoginResponse: Codable {
    let account: YSAccount
    let session: YSSession
}
