//
//  UIViewController+Extension.swift
//  EarthquakeDemo
//
//  Created by Sandeep N on 04/05/19.
//  Copyright © 2019 Sandeep N. All rights reserved.
//

import UIKit

extension UIViewController {
    public var activityIndicatorTag: Int { return 999999 }
    /**
     Starts loading indicator when fetching data is initiated.
     */
    public func startActivityIndicator(_ style: UIActivityIndicatorView.Style = UIActivityIndicatorView.Style.whiteLarge, location: CGPoint? = nil) {
        let loc = location ?? self.view.center
        (UIApplication.shared.delegate as! AppDelegate).window?.isUserInteractionEnabled = false
        DispatchQueue.main.async(execute: {
            let activityIndicator = UIActivityIndicatorView(style: style)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            activityIndicator.layer.cornerRadius = 5.0
            activityIndicator.tag = self.activityIndicatorTag
            activityIndicator.center = loc
            activityIndicator.hidesWhenStopped = true
            //activityIndicator.backgroundColor = UIColor.white
            activityIndicator.color = UIColor.black
            activityIndicator.startAnimating()
            self.view.addSubview(activityIndicator)
        })
    }
    
    /**
     Stops and removes an UIActivityIndicator in any UIViewController, when fetching is completed or failed
     */
    public func stopActivityIndicator() {
        (UIApplication.shared.delegate as! AppDelegate).window?.isUserInteractionEnabled = true
        DispatchQueue.main.async(execute: {
            if let activityIndicator = self.view.subviews.filter({ $0.tag == self.activityIndicatorTag}).first as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        })
    }
}

