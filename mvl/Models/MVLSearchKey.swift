//
//  MVLSearchKey.swift
//  mvl
//
//  Created by Mr Nghi Tran Kien Nghi on 5/8/22.
//

import Foundation

protocol MVLSearchKey {
    var date: Date { get set }
    var key: String { get set }
    var weathers: [MVLWeather] { get set }
}

extension MVLSearchKey {
    func isTodaySearch() -> Bool {
        return Calendar.current.isDateInToday(date)
    }
}

struct MVLRawSearchKey: MVLSearchKey {
    var weathers: [MVLWeather] = []
    var date: Date = Date()
    var key: String = ""
}
