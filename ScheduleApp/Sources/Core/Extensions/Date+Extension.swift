//
//  Date+Extension.swift
//  ScheduleApp
//
//  Created by Айбол on 27.07.2023.
//

import Foundation

enum WeekDay: Int, CaseIterable {
    case sunday = 0
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}

extension Date {
    var dayOfWeek: WeekDay {
        let dayNumber = Calendar.custom.component(.weekday, from: self)
        
        return WeekDay.allCases[dayNumber - 1]
    }
    
    func add(component: Calendar.Component, value: Int) -> Date {
        guard let date = Calendar.custom.date(byAdding: component, value: value, to: self) else {
            assertionFailure("\(#function) не может добавить компонент: \(component) со значением: \(value)")
            
            return self
        }
        
        return date
    }
    
    func monthYearEquals(calendar: Calendar, to date: Date) -> Bool {
        let current = calendar.dateComponents([.month, .year], from: self)
        let components = calendar.dateComponents([.month, .year], from: date)
        
        return current.month == components.month && current.year == components.year
    }
    
    func yearEquals(calendar: Calendar, to date: Date) -> Bool {
        let current = calendar.dateComponents([.year], from: self)
        let components = calendar.dateComponents([.year], from: date)
        
        return current.year == components.year
    }
    
    func monthYearDayEquals(calendar: Calendar, to date: Date) -> Bool {
        let current = calendar.dateComponents([.month, .year, .day], from: self)
        let components = calendar.dateComponents([.month, .year, .day], from: date)
        
        return current.month == components.month
        && current.year == components.year
        && current.day == components.day
    }
}
