//
//  DateFormatter+Extension.swift
//  ScheduleApp
//
//  Created by Айбол on 27.07.2023.
//

import Foundation

extension DateFormatter {
    static let dayMonthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM YYYY"
        formatter.locale = Calendar.custom.locale
        
        return formatter
    }()
    
    static let hourMinutesFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Calendar.custom.locale
        
        return formatter
    }()
    
    static let monthDayHourMinutesFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM HH:mm"
        formatter.locale = Calendar.custom.locale
        
        return formatter
    }()
    
    static let fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM YYYY HH:mm"
        formatter.locale = Calendar.custom.locale
        
        return formatter
    }()
}
