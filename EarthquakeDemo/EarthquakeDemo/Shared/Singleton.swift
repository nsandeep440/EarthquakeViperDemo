//
//  Singleton.swift
//  EarthquakeDemo
//
//  Created by Sandeep N on 04/05/19.
//  Copyright © 2019 Sandeep N. All rights reserved.
//

import UIKit

class Singleton {
    static let shared = Singleton()
    func convertSecondsToDate(seconds: Int) -> String {
        let time = Date(timeIntervalSince1970: TimeInterval(seconds))
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MMM d, h:mm a"
        let newDate = dateFormat.string(from: time)
        return newDate
    }
}
