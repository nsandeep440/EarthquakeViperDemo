//
//  String+Extension.swift
//  EarthquakeDemo
//
//  Created by Sandeep N on 04/05/19.
//  Copyright © 2019 Sandeep N. All rights reserved.
//

import UIKit

extension String {
    var getUrl: URL? {
        return URL(string: self)
    }
}
