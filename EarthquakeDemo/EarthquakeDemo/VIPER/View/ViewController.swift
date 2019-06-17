//
//  ViewController.swift
//  EarthquakeDemo
//
//  Created by Sandeep N on 03/05/19.
//  Copyright © 2019 Sandeep N. All rights reserved.
//

import UIKit
import SwiftyJSON
import BrightFutures

enum EarthquakeQueries {
    case feature
    case details(urlString: String)
    
    var featureUrl: String {
        return "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=2019-05-01&endtime=2019-05-02"
    }
    
}

/************** VIEW CONTROLLER *******************/

class ViewController: UIViewController {
    
    var presenter: ViewToPresenterProtocol?
    private var fullFeatures = [QuackFeature]()
    private var features = [QuackFeature]()
    @IBOutlet private weak var tableView: UITableView!
    private var currentPage = 0
    private let perPage = 20
    private var maxPageCount: Int {
        return fullFeatures.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "FeatureCell", bundle: nil)
        self.navigationItem.title = "USGS Earthquakes"
        self.tableView.register(nib, forCellReuseIdentifier: "FeatureCell")
        self.tableView.separatorStyle = .none
        self.presenter?.getEarthqaukeFeatures(forType: EarthquakeQueries.feature)
        self.startActivityIndicator()
    }
    
    func loadMoreData() {
        guard self.currentPage < self.maxPageCount else {
            return
        }
        var endCount = (self.currentPage + self.perPage)
        if endCount > self.maxPageCount {
            endCount = self.maxPageCount
        }
        let list = Array(self.fullFeatures[self.currentPage..<endCount])
        self.currentPage += 20
        self.features.append(contentsOf: list)
        self.tableView.reloadData()
    }

}

extension ViewController: PresenterToViewProtocol {
    func displayEarthqauke(withFeatures features: [QuackFeature]) {
        self.fullFeatures = features
        self.stopActivityIndicator()
        self.loadMoreData()
    }
    
    func dataError() {
        self.stopActivityIndicator()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.features.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureCell", for: indexPath) as? FeatureCell else {
            preconditionFailure("Cell not found")
        }
        let feature = self.features[indexPath.row]
        cell.updateCell(withFeature: feature)
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.presenter?.showEarthquakeFeatureDetails(fromController: self.navigationController!)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contenty = scrollView.contentOffset.y
        let maxContentOffset = scrollView.contentSize.height - scrollView.frame.size.height
        guard maxContentOffset - contenty <= 80 else {
            return
        }
        self.loadMoreData()
    }
    
}
