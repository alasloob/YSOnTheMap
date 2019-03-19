//
//  YSExtension.swift
//  YSOnTheMap
//
//  Created by Youssef Eid on 07/07/1440 AH.
//  Copyright © 1440 Youssef Eid. All rights reserved.
//

import UIKit


extension Data {
    func subSet(in range: Int) -> Data {
        return subdata(in: range..<self.count)
    }
}


extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}


@IBDesignable extension UIButton {
    
    
    @IBInspectable var cornerFloat: Float {
        set (newValue) {
            self.layer.masksToBounds = false
            self.layer.cornerRadius = CGFloat(newValue)
            self.layer.displayIfNeeded()
        }
        get {
            self.layer.masksToBounds = false
            self.layer.cornerRadius = CGFloat(self.cornerFloat)
            return self.cornerFloat
        }
    }
    
}
