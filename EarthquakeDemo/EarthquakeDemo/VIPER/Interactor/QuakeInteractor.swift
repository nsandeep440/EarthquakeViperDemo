//
//  QuakeInteractor.swift
//  EarthquakeDemo
//
//  Created by Sandeep N on 04/05/19.
//  Copyright © 2019 Sandeep N. All rights reserved.
//

import UIKit
import SwiftyJSON

/************** INTERACTOR *******************/
/**
 An Interactor class is used to fetch any network related data when conforming to "presenter to interactor protocol".
 Once data is fetched, Interactor need to send back information to presentor => presenter class should confirm to InteractorToPresenter protol.
 */
class QuakeInteractor: PresenterToInteractorProtocol {
    var toPresenter: InteractorToPresenterProtocol?
    
    func fetchQuake(forType query: EarthquakeQueries) {
        // Fetch Earth quake features
        // upon data fethed from network -> send back to presenter.
        var url = ""
        switch query {
        case .feature:
            url = query.featureUrl
        case .details(let urlString):
            url = urlString
        }
        ApiRequest.shared.GET(url).onSuccess { [weak self] (json) in
            guard let featuresJson = json["features"].array else { return }
            var features = [QuackFeature]()
            for feature in featuresJson {
                let quackFeature = QuackFeature(data: feature)
                features.append(quackFeature)
            }
            self?.toPresenter?.quakeFetchSuccess(withData: features)
            }.onFailure { (error) in
                self.toPresenter?.quakeFetchFailed()
        }
    }
}
