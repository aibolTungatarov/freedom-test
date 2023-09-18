//
//  Calendar+Extension.swift
//  ScheduleApp
//
//  Created by Айбол on 27.07.2023.
//

import Foundation

extension Calendar {
    static let custom: Calendar = {
        var calendar = Calendar(identifier: .iso8601)
        calendar.locale = Locale(identifier: "en_US")
        
        return calendar
    }()
}

