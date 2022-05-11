//
//  MVLWeatherForcastViewController.swift
//  mvl
//
//  Created by Mr Nghi Tran Kien Nghi on 5/8/22.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift

class MVLWeatherForcastViewController: UIViewController, StoryboardView {
   
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    var disposeBag = DisposeBag()
    let viewModel: MVLWeatherViewModel = MVLWeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        self.reactor = self.viewModel

        self.viewModel.action.onNext(MVLWeatherViewModel.Action.loadLocalSearchedKeys)
    }
    
    func initUI() {
        searchBar.barTintColor = UIColor.clear
        searchBar.backgroundColor = UIColor.clear
        searchBar.isTranslucent = true
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        weatherTableView.register(UINib(nibName: "MVLWeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "MVLWeatherTableViewCell")
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        weatherTableView.tableFooterView = UIView()
    }

    // Called when the new value is assigned to `self.reactor`
    func bind(reactor: MVLWeatherViewModel) {
        searchBar.searchTextField.rx.text.changed
            .map{ Reactor.Action.searchStringChanged($0 ?? "") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchBar.rx.cancelButtonClicked
            .map { Reactor.Action.cancelSearching }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .map { Reactor.Action.searchWithKey(reactor.currentState.searchString) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State change events
        reactor.pulse(\.$currentKey)
            .compactMap({ $0 })
            .subscribe (onNext: { [weak self] key in
                self?.weatherTableView.reloadData()
              }).disposed(by: disposeBag)
        
//        reactor.pulse(\.$showingScreen)
//            .compactMap({ $0 })
//            .subscribe (onNext: { [weak self] appScreen in
//                switch appScreen {
//                case .screenA:
//                    self?.dispatcher?.showMainView()
//                case .screenB:
//                    self?.dispatcher?.showMapView(atCoordinate: reactor.currentState.editingPoint)
//                    reactor.action.onNext(MVLViewModel.Action.loadLocalPoints)
//                case .screenC:
//                    self?.dispatcher?.showCoordinatePreview(pointA: reactor.currentState.pointA, pointB: reactor.currentState.pointB)
//                }
//              }).disposed(by: disposeBag)
//
//        reactor.pulse(\.$editingPoint)
//            .compactMap({ $0 })
//            .subscribe (onNext: { [weak self] mvlCoordinate in
//                self?.screenB.mvlCoordinate = mvlCoordinate
//              }).disposed(by: disposeBag)
//
//        reactor.pulse(\.$pointA)
//            .compactMap({ $0 })
//            .subscribe (onNext: { [weak self] mvlCoordinate in
//                self?.screenA.pointA = mvlCoordinate
//              }).disposed(by: disposeBag)
//
//        reactor.pulse(\.$pointB)
//            .compactMap({ $0 })
//            .subscribe (onNext: { [weak self] mvlCoordinate in
//                self?.screenA.pointB = mvlCoordinate
//              }).disposed(by: disposeBag)
//
//        reactor.pulse(\.$storedPoints).compactMap { result in
//            return result
//        }.subscribe { [weak self] mvlCoordinates in
//            self?.screenB.localCoordinateView.coordinates = mvlCoordinates
//        }.disposed(by: disposeBag)
//
//        reactor.state.map { $0.isLoadingPointInfo }
//        .distinctUntilChanged()
//        .bind(to: self.screenB.loadingPointActivityIndicatorView.rx.isAnimating)
//        .disposed(by: disposeBag)
        
        
    }

}

extension MVLWeatherForcastViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let searchkey = viewModel.currentState.currentKey else { return 0 }
        return searchkey.weathers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MVLWeatherTableViewCell", for: indexPath) as! MVLWeatherTableViewCell
        
        if let searchKey = viewModel.currentState.currentKey {
            let weather = searchKey.weathers[indexPath.row]
            cell.bindWeather(weather)
        }
        else {
            cell.cleanUI()
        }
        
        return cell
    }
}

extension MVLWeatherForcastViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 176
    }
}


