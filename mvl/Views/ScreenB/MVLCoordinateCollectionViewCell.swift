//
//  MVLCoordinateCollectionViewCell.swift
//  mvl
//
//  Created by nghitran on 21/02/2022.
//

import UIKit

class MVLCoordinateCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var coordinateInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bindCoordinate(_ coordinate: MVLCoordinate) {
        self.coordinateInfoLabel.text = coordinate.cellDescription()
    }
}
