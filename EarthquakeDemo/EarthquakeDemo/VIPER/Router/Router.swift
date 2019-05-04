//
//  Router.swift
//  EarthquakeDemo
//
//  Created by Sandeep N on 04/05/19.
//  Copyright © 2019 Sandeep N. All rights reserved.
//

import UIKit



enum Identifier {
    case vc
    case dvc
    
    func getController() -> Controller {
        switch self {
        case .vc:
            guard let vc = Identifier.mainStoryBoard.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {
                return Controller()
            }
            return Controller.viewController(vc: vc)
        case .dvc:
            guard let vc = Identifier.mainStoryBoard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
                return Controller()
            }
            return Controller.detailViewController(vc: vc)
        }
    }
    
    static var mainStoryBoard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
}

enum Controller {
    case viewController(vc: ViewController)
    case detailViewController(vc: DetailViewController)
    case notFound
    
    init() {
        self = .notFound
    }
}

/**
 This class is used to do any further navigation.
 Presenter can only talk to Router to do navigations
 */
class Router: PresenterToRouterProtocol {
//    static func QuackDetail() -> DetailViewController? {
//        guard let vc = self.storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
//            return nil
//        }
//        let presenter: ViewToPresenterProtocol & InteractorToPresenterProtocol = QuakePresenter()
//        let interactor: PresenterToInteractorProtocol = QuakeInteractor()
//        let router: PresenterToRouterProtocol = Router()
//        vc.presenter = presenter
//        presenter.toView = vc as? PresenterToViewProtocol
//        presenter.toInteractor = interactor
//        presenter.router = router
//        interactor.toPresenter = presenter
//
//        return vc
//    }
    
    static func quackController(controller: Identifier) -> Controller {
        let vc = controller.getController()
        let presenter: ViewToPresenterProtocol & InteractorToPresenterProtocol = QuakePresenter()
        let interactor: PresenterToInteractorProtocol = QuakeInteractor()
        let router: PresenterToRouterProtocol = Router()
        var newController = Controller()
        switch vc {
        case .viewController(let viewController):
            viewController.presenter = presenter
            presenter.toView = viewController
            newController = Controller.viewController(vc: viewController)
        case .detailViewController(let detailVC):
            detailVC.presenter = presenter
            presenter.toView = detailVC as? PresenterToViewProtocol
            newController = Controller.detailViewController(vc: detailVC)
        default:
            break
        }
        presenter.toInteractor = interactor
        presenter.router = router
        interactor.toPresenter = presenter
        return newController
    }
    
//    static func QuackFeatureController() -> ViewController? {
//        guard let vc = self.storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {
//            return nil
//        }
//        let presenter: ViewToPresenterProtocol & InteractorToPresenterProtocol = QuakePresenter()
//        let interactor: PresenterToInteractorProtocol = QuakeInteractor()
//        let router: PresenterToRouterProtocol = Router()
//        vc.presenter = presenter
//        presenter.toView = vc
//        presenter.toInteractor = interactor
//        presenter.router = router
//        interactor.toPresenter = presenter
//        return vc
//    }
    
    static var storyboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    func push(toController navigationController: UINavigationController) {
        let vcType = Router.quackController(controller: .dvc)
        switch vcType {
        case .detailViewController(let controller):
            navigationController.pushViewController(controller, animated: true)
        default:
            break
        }
    }
    
}
