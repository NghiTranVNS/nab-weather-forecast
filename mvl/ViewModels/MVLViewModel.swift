//
//  MVLViewModel.swift
//  mvl
//
//  Created by nghitran on 19/02/2022.
//

import UIKit
import ReactorKit
import RxSwift
import CoreLocation

class MVLViewModel: Reactor {
    
    //MARK: - Business objects
    var coordinateRepository: MVLCoordinateRepository = MVLCoordinateRepositoryImpl()
    
    //MARK: - Reactor Implementation
    // Action is an user interaction
    enum Action {
        //ScreenA
        case loadCurrentLocation
        case selectPoint(MVLCoordinate)
        case setCurrentLocation(CLLocationCoordinate2D)
        case setPointA
        case setPointB
        case clear
        
        //ScreenB
        case loadPointInfoForCoordinate(Double, Double)
        case setPoint
        case selectLocalPoint(MVLCoordinate)
        case loadLocalPoints
        
        //ScreenC
        case backToMainScreen
    }

    // Mutate is a state manipulator which is not exposed to a view
    enum Mutation {
        case overridePointA(MVLCoordinate)
        case overridePointB(MVLCoordinate)
        case setIsSelectPointA(Bool)
        case setCurrentLocation(CLLocationCoordinate2D)
        case setLoadingCurrentLocation(Bool)
        case setLoadingName(Bool)
        case setLoadingAqi(Bool)
        case setName(String)
        case setAqi(Int)
        case showScreen(AppScreen)
        case setEditingPoint(MVLCoordinate)
        case setLocalPoints([MVLCoordinate])
        case setSavedPoint(MVLCoordinate)
        case setAlertMessage(String)
    }

    // State is a current view state
    struct State {
        @Pulse var pointA: MVLCoordinate
        @Pulse var pointB: MVLCoordinate
        @Pulse var editingPoint: MVLCoordinate
        var isSelectedPointA: Bool
        var currentLocation: CLLocationCoordinate2D
        var isLoadingCurrentLocation: Bool
        var isLoadingName: Bool
        var isLoadingAqi: Bool
        var isLoadingPointInfo: Bool //isLoadingName & isLoadingAqi
        @Pulse var showingScreen: AppScreen
        
        //Additional data
        @Pulse var storedPoints: [MVLCoordinate]
        @Pulse var savedPoint: MVLCoordinate
        @Pulse var alertMessage: String?
    }

    let initialState: State
    
    init() {
        self.initialState = State(
            pointA: MVLRawCoordinate(),
            pointB: MVLRawCoordinate(),
            editingPoint: MVLRawCoordinate(),
            isSelectedPointA: false,
            currentLocation: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            isLoadingCurrentLocation: false,
            isLoadingName: false,
            isLoadingAqi: false,
            isLoadingPointInfo: false,
            showingScreen: .screenA,
            storedPoints: [],
            savedPoint: MVLRawCoordinate()
        )
        
        //self.coordinateRepository = MVLCoordinateRepositoryImpl()
    }

    // Action -> Mutation
    func mutate(action: Action) -> Observable<Mutation> {
      switch action {
      case .loadCurrentLocation:
          return Observable.concat([
            Observable.just(Mutation.setLoadingCurrentLocation(true)),
            MVLLocationsManager.shared.requestLocationObservable().map({ [weak self] clLocation in
                guard let strongSelf = self else {
                    return Mutation.setCurrentLocation(clLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
                }
                
                let locaion2D = clLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
                strongSelf.action.onNext(Action.setCurrentLocation(locaion2D))
                if strongSelf.currentState.isSelectedPointA == true {
                    strongSelf.action.onNext(Action.selectPoint(strongSelf.currentState.pointA))
                }
                else {
                    strongSelf.action.onNext(Action.selectPoint(strongSelf.currentState.pointB))
                }
                
                return Mutation.setCurrentLocation(locaion2D)
            }),
            Observable.just(Mutation.setLoadingCurrentLocation(false))
          ])
      case .selectPoint(let mvlCoordinate):
          if mvlCoordinate.isInitialized() {
              self.action.onNext(Action.loadPointInfoForCoordinate(self.currentState.currentLocation.latitude, self.currentState.currentLocation.longitude))
          }
          return Observable.concat([
            Observable.just(Mutation.setEditingPoint(mvlCoordinate)),
            Observable.just(Mutation.showScreen(.screenB)),
          ])
      case .setCurrentLocation(let clLocationCoordinate2D):
          return Observable.just(Mutation.setCurrentLocation(clLocationCoordinate2D))
      case .setPointA:
          if self.currentState.pointA.isInitialized() {
              self.action.onNext(Action.loadCurrentLocation)
              return Observable.concat([
                Observable.just(Mutation.setIsSelectPointA(true)),
              ])
          }
          else {
              return Observable.concat([
                Observable.just(Mutation.setIsSelectPointA(true)),
                Observable.just(Mutation.setEditingPoint(self.currentState.pointA)),
                Observable.just(Mutation.showScreen(.screenB)),
              ])
          }
      case .setPointB:
          if self.currentState.pointB.isInitialized() {
              self.action.onNext(Action.loadCurrentLocation)
              return Observable.concat([
                Observable.just(Mutation.setIsSelectPointA(false)),
              ])
          }
          else {
              return Observable.concat([
                Observable.just(Mutation.setIsSelectPointA(false)),
                Observable.just(Mutation.setEditingPoint(self.currentState.pointB)),
                Observable.just(Mutation.showScreen(.screenB)),
              ])
          }
      case .clear:
          return Observable.concat([
            Observable.just(Mutation.overridePointA(MVLRawCoordinate())),
            Observable.just(Mutation.overridePointB(MVLRawCoordinate())),
            Observable.just(Mutation.setEditingPoint(MVLRawCoordinate())),
            Observable.just(Mutation.setIsSelectPointA(true))
          ])
      case .loadPointInfoForCoordinate(let lat, let long):
          return Observable.concat([
            Observable.just(Mutation.setEditingPoint(MVLRawCoordinate(name: "", aqi: 0, lat: lat, long: long))),
            Observable.just(Mutation.setLoadingName(true)),
            self.coordinateRepository.requestNameOfCoordinate(lat: lat, long: long).map({ mvlCoordinate in
                return Mutation.setName(mvlCoordinate?.name ?? "")
            }),
            Observable.just(Mutation.setLoadingAqi(true)),
            self.coordinateRepository.requestAqiOfCoordinate(lat: lat, long: long).map({ mvlCoordinate in
                return Mutation.setAqi(mvlCoordinate?.aqi ?? 0)
            })
          ])
      case .setPoint:
          var observables: [Observable<Mutation>] = []
          if self.currentState.isSelectedPointA {
              observables.append(Observable.just(Mutation.overridePointA(self.currentState.editingPoint)))
              if self.currentState.pointB.isInitialized() {
                  observables.append(Observable.just(Mutation.showScreen(.screenA)))
              }
              else {
                  observables.append(Observable.just(Mutation.showScreen(.screenC)))
              }
          }
          else {
              observables.append(Observable.just(Mutation.overridePointB(self.currentState.editingPoint)))
              if self.currentState.pointA.isInitialized() {
                  observables.append(Observable.just(Mutation.showScreen(.screenA)))
              }
              else {
                  observables.append(Observable.just(Mutation.showScreen(.screenC)))
              }
          }
          //Only save new point to local CoreData
          let editingPoint = self.currentState.editingPoint
          let foundPoints = self.currentState.storedPoints.first { mvlCoordinate in
              mvlCoordinate.lat == editingPoint.lat && mvlCoordinate.long == editingPoint.long }
          if foundPoints == nil {
              observables.append(self.coordinateRepository.requestSavingCoordinate(coordinate: self.currentState.editingPoint).map({ mvlCoordinate in
                  return Mutation.setSavedPoint(mvlCoordinate ?? MVLRawCoordinate())
              }))
          }
          
          return Observable.concat(observables)
      case .selectLocalPoint(let localPoint):
          return Observable.just(Mutation.setEditingPoint(localPoint))
      case .loadLocalPoints:
          return Observable.concat([
            self.coordinateRepository.requestLocalCoordinates().map({ mvlCoordinates in
                return Mutation.setLocalPoints(mvlCoordinates)
            })
          ])
      case .backToMainScreen:
          self.action.onNext(Action.clear)
          return Observable.just(Mutation.showScreen(.screenA))
      }
    }

    // Mutation -> State
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setAlertMessage(message):
            newState.alertMessage = message
        case .overridePointA(let point):
            newState.pointA = point
        case .overridePointB(let point):
            newState.pointB = point
        case .setCurrentLocation(let location):
            newState.currentLocation = location
        case .setLoadingCurrentLocation(let isLoading):
            newState.isLoadingCurrentLocation = isLoading
        case .setLoadingName(let isLoading):
            newState.isLoadingName = isLoading
        case .setLoadingAqi(let isLoading):
            newState.isLoadingAqi = isLoading
        case .setName(let name):
            newState.editingPoint.name = name
            newState.editingPoint = newState.editingPoint
            newState.isLoadingName = false
            newState.isLoadingPointInfo = newState.isLoadingName && newState.isLoadingAqi
        case .setAqi(let aqi):
            newState.editingPoint.aqi = aqi
            newState.editingPoint = newState.editingPoint
            newState.isLoadingAqi = false
            newState.isLoadingPointInfo = newState.isLoadingName && newState.isLoadingAqi
        case .setIsSelectPointA(let pointASelected):
            newState.isSelectedPointA = pointASelected
        case .showScreen(let screen):
            newState.showingScreen = screen
        case .setEditingPoint(let editingPoint):
            newState.editingPoint = editingPoint
            if editingPoint.isInitialized() {
                newState.editingPoint.coordinate = newState.currentLocation
            }
        case .setLocalPoints(let localPoints):
            newState.storedPoints = localPoints
        case .setSavedPoint(let savedPoint):
            newState.savedPoint = savedPoint
        }
        return newState
    }
}
