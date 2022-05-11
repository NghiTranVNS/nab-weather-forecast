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

        //self.viewModel.action.onNext(MVLWeatherViewModel.Action.loadLocalSearchedKeys)
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
                self?.view.endEditing(true)
              }).disposed(by: disposeBag)
        
        reactor.pulse(\.$alertMessage)
            .compactMap({ $0 })
            .subscribe (onNext: { [weak self] message in
                self?.showAlert(withMessage: message)
              }).disposed(by: disposeBag)
        
        reactor.pulse(\.$isStartedSearching)
            .compactMap({ $0 })
            .subscribe (onNext: { [weak self] isStartedSearching in
                if !isStartedSearching {
                    self?.view.endEditing(true)
                }
              }).disposed(by: disposeBag)
    }

}

extension MVLWeatherForcastViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !viewModel.currentState.currentKey.isEmptyData() else { return 0 }
        return viewModel.currentState.currentKey.weathers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MVLWeatherTableViewCell", for: indexPath) as! MVLWeatherTableViewCell
        
        if !viewModel.currentState.currentKey.isEmptyData() {
            let searchKey = viewModel.currentState.currentKey
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

extension MVLWeatherForcastViewController {
    func showAlert(withMessage message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
        })
        present(alert, animated: true)
    }
}


