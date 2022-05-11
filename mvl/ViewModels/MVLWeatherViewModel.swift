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
        case updateCurrentKey(MVLSearchKey)
        case showAlertMessage(String)
        case saveKeyToLocalStore(MVLSearchKey)
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
        case updateCurrentKey(MVLSearchKey)
        case saveKeySuccessfully(Bool)
    }

    // State is a current view state
    struct State {
        @Pulse var currentKey: MVLSearchKey
        @Pulse var searchString: String
        @Pulse var searchedKeys: [MVLSearchKey]
        var isLoadingWeatherInfo: Bool
        var isStartedSearching: Bool
        var keySaved: Bool
        @Pulse var alertMessage: String?
    }

    let initialState: State
    
    init() {
        self.initialState = State(
            currentKey: MVLRawSearchKey(),
            searchString: "",
            searchedKeys: [],
            isLoadingWeatherInfo: false,
            isStartedSearching: false,
            keySaved: false,
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
          if keyString.count < GlobalVariables.minLengthOfKeyString {
              return Observable.just(Mutation.setAlertMessage("The search term length must be from 3 characters or above."))
          }
          
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
                    self?.action.onNext(Action.saveKeyToLocalStore(_key))
                    self?.action.onNext(Action.updateCurrentKey(_key))
                }
                else {
                    self?.action.onNext(Action.updateCurrentKey(MVLRawSearchKey()))
                    self?.action.onNext(Action.showAlertMessage("No weather forecast data found!"))
                }
                return Mutation.setIsLoadingWeatherInfo(false)
            })
          ])
      case .updateCurrentKey(let searchKey):
          return Observable.just(Mutation.updateCurrentKey(searchKey))
      case .showAlertMessage(let message):
          return Observable.just(Mutation.setAlertMessage(message))
      case .saveKeyToLocalStore(let searchKey):
          return Observable.concat([
            self.weatherRepository.storeSearchKeyToLocal(searchKey: searchKey).map { storedKey in
                if storedKey != nil {
                    print("Stored \(storedKey?.key ?? "") to DB")
                    return Mutation.saveKeySuccessfully(true)
                }
                else {
                    print("Failed to store new key to DB")
                    return Mutation.saveKeySuccessfully(false)
                }
            }
          ])
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
        case .saveKeySuccessfully(let success):
            break
        }
        return newState
    }
}
