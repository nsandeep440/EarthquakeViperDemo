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

struct QuackProperties {
    let mag: Double
    let place: String
    let time: String//1556754673170,
    var url: URL? //https://earthquake.usgs.gov/earthquakes/eventpage/pr2019121008,
    var detail: URL? //https://earthquake.usgs.gov/fdsnws/event/1/query?eventid=pr2019121008&format=geojson,
    let type: String//earthquake,
    let title: String //M 3.4 - 11km WNW of San Rafael del Yuma, Dominican Republic
    
    init(data: [String: Any]) {
        self.mag = data["mag"] as? Double ?? 0.0
        self.place = data["place"] as? String ?? ""
        
        self.url = (data["url"] as? String)?.getUrl
        self.detail = (data["detail"] as? String)?.getUrl
        self.type = data["type"] as? String ?? ""
        self.title = data["title"] as? String ?? ""
        self.time = Singleton.shared.convertSecondsToDate(seconds: data["time"] as? Int ?? 0)
    }
}


struct QuackGeometry {
    let type: String
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    
    init(data: [String: Any]) {
        self.type = data["type"] as? String ?? ""
        if let coord = data["coordinates"] as? [Any] {
            for (index, value) in coord.enumerated() {
                if index == 0 {
                    self.latitude = value as? Double ?? 0.0
                } else if index == 1 {
                    self.longitude = value as? Double ?? 0.0
                }
            }
        } else {
            self.latitude = 0.0
            self.longitude = 0.0
        }
    }
}
