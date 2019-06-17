//
//  QuakePresenter.swift
//  EarthquakeDemo
//
//  Created by Sandeep N on 04/05/19.
//  Copyright © 2019 Sandeep N. All rights reserved.
//

import UIKit

/**
 This class is used to fetch the data from "Interactor" and passes back to this ("Presenter") and sends to router for further navigation.
 A presenter class is used to present information on view using viewToPresent protocol. Such that it communicates with presenter to Interactor, interactor to presenter, presenter to router and finally presenter to view.
 1. To fetch any data from server or core data, Interator is used such that it should confirm to "presenterToInterator" protocol
 2. Once data is fetched, Interactor sends back information using "InteractorToPresent" protocol -> which in turn, presenter calls back to view protocol ("prsenterToView" protocol) for further UI display.
 3. For any navigation, router protocol is used to navigate from current controller to next.
 
 */
/************** VIEW TO PRESENTER *******************/
class QuakePresenter: ViewToPresenterProtocol {
    
    var toView: PresenterToViewProtocol?
    var toInteractor: PresenterToInteractorProtocol?
    var router: PresenterToRouterProtocol?
    
    func getEarthqaukeFeatures(forType type: EarthquakeQueries) {
        toInteractor?.fetchQuake(forType: type)
    }
    
    func showEarthquakeFeatureDetails(fromController navigationController: UINavigationController) {
        router?.push(toController: navigationController)
    }
}

extension QuakePresenter: InteractorToPresenterProtocol {
    func quakeFetchSuccess(withData data: [QuackFeature]) {
        // Call back to view using "Presenter to view" on success
        toView?.displayEarthqauke(withFeatures: data)
    }
    
    func quakeFetchFailed() {
        toView?.dataError()
    }
}
