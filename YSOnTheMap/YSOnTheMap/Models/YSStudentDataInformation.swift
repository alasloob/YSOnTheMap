//
//  YSStudentDataInformation.swift
//  YSOnTheMap
//
//  Created by Youssef on 08/07/1440 AH.
//  Copyright © 1440 Youssef Eid. All rights reserved.
//

import Foundation

class YSStudentDataInformation {
    
    static let shared = YSStudentDataInformation()
    var data: [YSStudentInformation] = []
    
    func fetch(completion: @escaping (Error?) -> Void) {
        if self.data.count > 0 {
            completion(nil)
        } else {
            YSClient.fetchStudentLocation { (students, error) in
                if error == nil {
                    if let students = students {
                        self.data = students
                        completion(nil)
                    }
                } else {
                    completion(error)
                }
            }
        }
    }
    
    func refersh(completion: @escaping (Error?) -> Void) {
        YSClient.fetchStudentLocation { (students, error) in
            if error == nil {
                if let students = students {
                    self.data.removeAll()
                    self.data = students
                    completion(nil)
                } else {
                    completion(nil)
                }
            } else {
                completion(error)
            }
        }
    }
    
    
}
