//
//  MVLScreenA.swift
//  mvl
//
//  Created by nghitran on 18/02/2022.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift

class MVLScreenA: BaseView {
    @IBOutlet weak var setPointAButton: UIButton!
    @IBOutlet weak var setPointBButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var pointALabel: UILabel!
    @IBOutlet weak var pointBLabel: UILabel!
    
    public private(set) var disposeBag = DisposeBag()

    var pointA: MVLCoordinate = MVLRawCoordinate() {
        didSet {
            self.bindPointToLabel(point: pointA, label: pointALabel)
        }
    }
    
    var pointB: MVLCoordinate = MVLRawCoordinate() {
        didSet {
            self.bindPointToLabel(point: pointB, label: pointBLabel)
        }
    }
    
    override func setupView() {
        super.setupView()
        self.bindPointToLabel(point: pointA, label: pointALabel)
        self.bindPointToLabel(point: pointB, label: pointBLabel)
    }
    
    private func bindPointToLabel(point: MVLCoordinate, label: UILabel) {
        label.text = point.shortDescription()
    }
}
