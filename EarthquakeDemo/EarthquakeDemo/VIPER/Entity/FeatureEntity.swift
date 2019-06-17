//
//  FeatureEntity.swift
//  EarthquakeDemo
//
//  Created by Sandeep N on 04/05/19.
//  Copyright © 2019 Sandeep N. All rights reserved.
//

import UIKit
import SwiftyJSON

struct QuackFeature {
    let properties: QuackProperties
    let geometry: QuackGeometry
    let id: String
    
    init(data: JSON) {
        self.id = data["id"].stringValue
        self.properties = QuackProperties(data: data["properties"].dictionaryObject ?? [:])
        self.geometry = QuackGeometry(data: data["geometry"].dictionaryObject ?? [:])
    }
}

@dynamicMemberLookup
struct QuackProperties {
    let props: [String: Any]

    init(data: [String: Any]) {
        self.props = data
    }
    
    subscript(dynamicMember member: String) -> String {
        if let intValue = props[member] as? Int {
            return Singleton.shared.convertSecondsToDate(seconds: intValue)
        }
        return props[member] as? String ?? ""
    }
    
    subscript(dynamicMember member: String) -> Double {
        return props[member] as? Double ?? 0.0
    }
    
    subscript(dynamicMember member: String) -> URL? {
        return (props[member] as? String)?.getUrl
    }
}

@dynamicMemberLookup
public struct QuackGeometry {
    let geometry: [String: Any]
    
    init(data: [String: Any]) {
        self.geometry = data
    }
    
    subscript<T>(dynamicMember member: String) -> T? {
        return geometry[member] as? T
    }
    
    subscript(dynamicMember member: String) -> [Any]? {
        return geometry[member] as? [Any]
    }
}
