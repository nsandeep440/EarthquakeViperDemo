//
//  FeatureCell.swift
//  EarthquakeDemo
//
//  Created by Sandeep N on 04/05/19.
//  Copyright © 2019 Sandeep N. All rights reserved.
//

import UIKit

class FeatureCell: UITableViewCell {

    @IBOutlet private weak var viewOverlay: UIView!
    @IBOutlet private weak var labelType: UILabel!
    @IBOutlet private weak var labelTitle: UILabel!
    @IBOutlet private weak var labelMagnitude: UILabel!
    @IBOutlet private weak var labelDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewOverlay.layoutIfNeeded()
        viewOverlay.layer.cornerRadius = 5.0
        viewOverlay.layer.shadowOpacity = 1.0
        viewOverlay.layer.shadowOffset = CGSize(width: 0, height: -0.5)
        viewOverlay.layer.shadowRadius = 0.5
//        viewOverlay.layer.borderWidth = 1.0
        viewOverlay.addInnerShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension FeatureCell {
    func updateCell(withFeature feature: QuackFeature) {
        self.labelDate.text = feature.properties.time
        self.labelTitle.text = feature.properties.place
        self.labelType.text = feature.properties.type
        self.labelMagnitude.text = String(feature.properties.mag)
    }
}

extension UIView {
    public func addInnerShadow(topColor: UIColor = UIColor.red) {
        let shadowLayer = CAGradientLayer()
        shadowLayer.cornerRadius = layer.cornerRadius
        shadowLayer.frame = bounds
        shadowLayer.frame.size.height = -5
        shadowLayer.colors = [
            topColor.withAlphaComponent(0.3).cgColor,
//            UIColor.white.withAlphaComponent(0.5).cgColor
        ]
        layer.addSublayer(shadowLayer)
    }
}
