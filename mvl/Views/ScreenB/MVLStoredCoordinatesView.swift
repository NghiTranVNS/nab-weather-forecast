//
//  MVLStoredCoordinatesView.swift
//  mvl
//
//  Created by nghitran on 21/02/2022.
//

import UIKit

class MVLStoredCoordinatesView: BaseView {
    @IBOutlet weak var coordinateCollectionView: UICollectionView!
    
    var coordinates: [MVLCoordinate] = [] {
        didSet {
            self.coordinateCollectionView.reloadData()
        }
    }
    
    override func setupView() {
        super.setupView()
        
        self.coordinateCollectionView.register(UINib(nibName: "MVLCoordinateCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MVLCoordinateCollectionViewCell")
        self.coordinateCollectionView.delegate = self
        self.coordinateCollectionView.dataSource = self
    }
}

extension MVLStoredCoordinatesView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coordinates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MVLCoordinateCollectionViewCell", for: indexPath) as! MVLCoordinateCollectionViewCell
        
        let coordinate = self.coordinates[indexPath.row]
        cell.bindCoordinate(coordinate)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 98)
    }
}
