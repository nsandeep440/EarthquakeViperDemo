//
//  Protocols.swift
//  EarthquakeDemo
//
//  Created by Sandeep N on 04/05/19.
//  Copyright © 2019 Sandeep N. All rights reserved.
//

import UIKit

// VIPER Architechture ->

// view <-> view controller <-> presenter -> router
// presenter <-> Interactor <-> (coredata / networking) <-> (entity/network response)

/*
 presenter to view (Bi-directional) => view to presenter
 prseenter to Interactor (Bi-Direction)
 presenter to router (uni-direction)
 */

// view <-> view controller <-> presenter
protocol ViewToPresenterProtocol: class {
    var toView: PresenterToViewProtocol? {get set}
    var toInteractor: PresenterToInteractorProtocol? {get set}
    var router: PresenterToRouterProtocol? {get set}
    
    // passing from presenter to interactor
    func getEarthqaukeFeatures(forType type: EarthquakeQueries)
    // passing from presenter to router
    func showEarthquakeFeatureDetails(fromController navigationController: UINavigationController)
}

/**
 presenter <-> view controller <-> view
 Sends back information from presenter to view
 eg: Interators information (Two cases success and failure)
 */
protocol PresenterToViewProtocol: class {
    //    associatedtype QaukeData
    func displayEarthqauke(withFeatures features: [QuackFeature])
    func dataError()
}

/**
 presenter <-> Interactor
 needs to send data back to presenter
 */
protocol PresenterToInteractorProtocol: class {
    var toPresenter: InteractorToPresenterProtocol? { get set }
    func fetchQuake(forType query: EarthquakeQueries)
    
}

/**
 Sends data from Interactor to presenter :-
 Success data and failure information
 */
protocol InteractorToPresenterProtocol: class {
    //    associatedtype QuakeData
    func quakeFetchSuccess(withData data: [QuackFeature])
    func quakeFetchFailed()
}


// presenter -> router
protocol PresenterToRouterProtocol: class {
    func push(toController navigationController: UINavigationController)
}
