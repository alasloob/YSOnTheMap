//
//  YSAlert.swift
//  YSOnTheMap
//
//  Created by Youssef Eid on 09/07/1440 AH.
//  Copyright © 1440 Youssef Eid. All rights reserved.
//

import UIKit

class YSAlert {
    
    static func show(title: String, message: String, context: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
            alert.dismiss(animated: true)
        }))
        context.present(alert, animated: true)
    }
    
    static func showWithCompletion(title: String, message: String, context: UIViewController, completion: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: completion))
        context.present(alert, animated: true) 
    }
    
}

class YSAlertIndicator: UIViewController {
    
    fileprivate let activityView = ActivityView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        view = activityView
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        print("dismiss")
    }
    
}


private class ActivityView: UIView {
    
    let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    let containerBoxView = UIView(frame: CGRect.zero)

    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        containerBoxView.backgroundColor = UIColor(white: 0.0, alpha: 0.8)
        containerBoxView.layer.cornerRadius = 18.0
        activityIndicatorView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        addSubview(containerBoxView)
        addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerBoxView.frame.size.width = 160.0
        containerBoxView.frame.size.height = 160.0
        containerBoxView.frame.origin.x = ceil((bounds.width / 2.0) - (containerBoxView.frame.width / 2.0))
        containerBoxView.frame.origin.y = ceil((bounds.height / 2.0) - (containerBoxView.frame.height / 2.0))
        activityIndicatorView.frame.origin.x = ceil((bounds.width / 2.0) - (activityIndicatorView.frame.width / 2.0))
        activityIndicatorView.frame.origin.y = ceil((bounds.height / 2.0) - (activityIndicatorView.frame.height / 2.0))
    }
    
}

