//
//  MVLWeatherViewModel.swift
//  mvl
//
//  Created by Mr Nghi Tran Kien Nghi on 5/9/22.
//

import UIKit
import ReactorKit
import RxSwift
import CoreLocation

class MVLWeatherViewModel: Reactor {
    //MARK: - Business objects
    var weatherRepository: MVLWeatherRepository = MVLWeatherRepositoryImpl()
    
    //MARK: - Reactor Implementation
    // Action is an user interaction
    enum Action {
        case loadLocalSearchedKeys
        case retrieveLocalSearchedKeys(String)
        case searchWithKey(String)
        case fetchWeatherInfoWithSearchString(String)
        case cancelSearching
        case searchBarFocused
        case searchStringChanged(String)
        case updateCurrentKey(MVLSearchKey?)
    }

    // Mutate is a state manipulator which is not exposed to a view
    enum Mutation {
        case loadedLatestcurrentKeys([MVLSearchKey])
//        case fetchWeatherInfoWithSearchString(String)
        case searchWithKey(String)
        case cancelSearching
        case updateSearchString(String)
        case setIsLoadingWeatherInfo(Bool)
        case setIsStartedSearching(Bool)
        case setAlertMessage(String)
        case updateCurrentKey(MVLSearchKey?)
        
    }

    // State is a current view state
    struct State {
        @Pulse var currentKey: MVLSearchKey?
        @Pulse var searchString: String
        @Pulse var searchedKeys: [MVLSearchKey]
        var isLoadingWeatherInfo: Bool
        var isStartedSearching: Bool
        @Pulse var alertMessage: String?
    }

    let initialState: State
    
    init() {
        self.initialState = State(
            currentKey: nil,
            searchString: "",
            searchedKeys: [],
            isLoadingWeatherInfo: false,
            isStartedSearching: false,
            alertMessage: nil
        )
    }

    // Action -> Mutation
    func mutate(action: Action) -> Observable<Mutation> {
      switch action {
      case .loadLocalSearchedKeys:
          return Observable.concat([
//            Observable.just(Mutation.setIsStartedSearching(true)),
            self.weatherRepository.loadLocalSearchKeys().map({ keys in
                return Mutation.loadedLatestcurrentKeys(keys)
            }),
//            Observable.just(Mutation.setIsStartedSearching(true))
          ])
      case .retrieveLocalSearchedKeys(_):
          break
      case .searchWithKey(let keyString):
          return Observable.concat([
            self.weatherRepository.loadLocalSearchKeys().map({ [weak self] keys in
                if let key = keys.first(where: { $0.key.lowercased() == keyString.lowercased() && $0.isTodaySearch() }) {
                    //Return local key
                    return Mutation.updateCurrentKey(key)
                }
                else {
                    //Call API
                    self?.action.onNext(Action.fetchWeatherInfoWithSearchString(keyString))
                }
                return Mutation.setIsLoadingWeatherInfo(true)
            })
          ])
      case .cancelSearching:
          return Observable.concat([
              Observable.just(Mutation.setIsStartedSearching(false))
          ])
      case .searchBarFocused:
          return Observable.concat([
              Observable.just(Mutation.setIsStartedSearching(true))
          ])
      case .searchStringChanged(let searchString):
          return Observable.just(Mutation.updateSearchString(searchString))
      case .fetchWeatherInfoWithSearchString(let keyString):
          return Observable.concat([
            self.weatherRepository.requestWeathersWithKey(keyString).map({ [weak self] key in
                if let _key = key {
                    self?.weatherRepository.storeSearchKeyToLocal(searchKey: _key).map({ storedKey in
                        if storedKey != nil {
                            print("Stored \(storedKey?.key ?? "") to DB")
                        }
                        else {
                            print("Failed to store new key to DB")
                        }
                    })
                    self?.action.onNext(Action.updateCurrentKey(_key))
                }
                else {
                    self?.action.onNext(Action.updateCurrentKey(nil))
                }
                return Mutation.setIsLoadingWeatherInfo(false)
            })
          ])
      case .updateCurrentKey(let searchKey):
          return Observable.just(Mutation.updateCurrentKey(searchKey))
      }
        
        //test
        return Observable.concat([
            Observable.just(Mutation.setIsLoadingWeatherInfo(true)),
            Observable.just(Mutation.setAlertMessage("Testing error message"))
        ])
            //
    }

    // Mutation -> State
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setAlertMessage(message):
            newState.alertMessage = message
        case .loadedLatestcurrentKeys(let keys):
            newState.searchedKeys = keys
            newState.currentKey = keys.first
            break
        case .searchWithKey(_):
            break
        case .cancelSearching:
            newState.isStartedSearching = false
        case .updateSearchString(let searchString):
            newState.searchString = searchString
        case .setIsLoadingWeatherInfo(_):
            break
        case .setIsStartedSearching(let startedSearching):
            newState.isStartedSearching = startedSearching
        case .updateCurrentKey(let searchKey):
            newState.currentKey = searchKey
        }
        return newState
    }
}
