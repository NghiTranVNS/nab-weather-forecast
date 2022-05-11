//
//  ViewController.swift
//  mvl
//
//  Created by nghitran on 18/02/2022.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift
import GoogleMaps

class ViewController: UIViewController, StoryboardView {
    @IBOutlet weak var screenA: MVLScreenA!
    @IBOutlet weak var screenB: MVLScreenB!
    @IBOutlet weak var screenC: MVLScreenC!

    var dispatcher: MVLAppCoordinator?
    var disposeBag = DisposeBag()
    var viewModel: MVLViewModel = MVLViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dispatcher = MVLMainCoordinator(withViewController: self)
        self.configureUI()
        self.reactor = self.viewModel
        MVLLocationsManager.shared.checkAndRequestAuthorizationLocation()
        
        //test
        viewModel.coordinateRepository.requestLocalCoordinates().bind { coordinates in
            print("coordinates.count = \(coordinates.count)")
        }.disposed(by: disposeBag)
    }
    
    private func configureUI() {
        self.dispatcher?.showMainView()
    }

    // Called when the new value is assigned to `self.reactor`
    func bind(reactor: MVLViewModel) {
        //Screen A Actions
        screenA.setPointAButton.rx.tap
            .map { Reactor.Action.setPointA }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        screenA.setPointBButton.rx.tap
            .map { Reactor.Action.setPointB }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        screenA.clearButton.rx.tap
            .map { Reactor.Action.clear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
      
        //Screen B Actions
        screenB.setButton.rx.tap
            .map { Reactor.Action.setPoint }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        screenB.didChangeMapPosition = { [weak self] clLocation in
            guard let _ = self else { return }
            reactor.action.onNext(MVLViewModel.Action.loadPointInfoForCoordinate(clLocation.latitude, clLocation.longitude))
        }
        
        screenB.localCoordinateView.coordinateCollectionView.rx.itemSelected
          .subscribe(onNext: { [weak self, weak reactor] indexPath in
              guard let strongSelf = self else { return }
              strongSelf.screenB.localCoordinateView.coordinateCollectionView.deselectItem(at: indexPath, animated: false)
              guard let mvlCoordinate = reactor?.currentState.storedPoints[indexPath.row] else { return }
              reactor?.action.onNext(MVLViewModel.Action.selectLocalPoint(mvlCoordinate))
          })
          .disposed(by: disposeBag)
        
        //Screen C Actions
        screenC.backButton.rx.tap
            .map { Reactor.Action.backToMainScreen }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // State
        reactor.pulse(\.$showingScreen)
            .compactMap({ $0 })
            .subscribe (onNext: { [weak self] appScreen in
                switch appScreen {
                case .screenA:
                    self?.dispatcher?.showMainView()
                case .screenB:
                    self?.dispatcher?.showMapView(atCoordinate: reactor.currentState.editingPoint)
                    reactor.action.onNext(MVLViewModel.Action.loadLocalPoints)
                case .screenC:
                    self?.dispatcher?.showCoordinatePreview(pointA: reactor.currentState.pointA, pointB: reactor.currentState.pointB)
                }
              }).disposed(by: disposeBag)
        
        reactor.pulse(\.$editingPoint)
            .compactMap({ $0 })
            .subscribe (onNext: { [weak self] mvlCoordinate in
                self?.screenB.mvlCoordinate = mvlCoordinate
              }).disposed(by: disposeBag)
        
        reactor.pulse(\.$pointA)
            .compactMap({ $0 })
            .subscribe (onNext: { [weak self] mvlCoordinate in
                self?.screenA.pointA = mvlCoordinate
              }).disposed(by: disposeBag)
        
        reactor.pulse(\.$pointB)
            .compactMap({ $0 })
            .subscribe (onNext: { [weak self] mvlCoordinate in
                self?.screenA.pointB = mvlCoordinate
              }).disposed(by: disposeBag)
        
        reactor.pulse(\.$storedPoints).compactMap { result in
            return result
        }.subscribe { [weak self] mvlCoordinates in
            self?.screenB.localCoordinateView.coordinates = mvlCoordinates
        }.disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoadingPointInfo }
        .distinctUntilChanged()
        .bind(to: self.screenB.loadingPointActivityIndicatorView.rx.isAnimating)
        .disposed(by: disposeBag) 
    }
}

