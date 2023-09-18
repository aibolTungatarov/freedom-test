//
//  UIColor+Constants.swift
//  ScheduleApp
//
//  Created by Айбол on 27.07.2023.
//

import UIKit

extension UIColor {
    enum Calendar {
        static let background = UIColor(named: "calendar_background")!
        static let selectedDayBackground = UIColor(named: "calendar_selected_background")!
        static let selectedText = UIColor(named: "calendar_selected_text")!
        static let weekendText = UIColor(named: "calendar_weekend_text")!
        static let monthText = UIColor(named: "calendar_month_text")!
        static let dayText = UIColor(named: "calendar_day_text")!
        static let calendarPastDays = UIColor(named: "calendar_past_days")!
    }
    
    enum View {
        static let defaultBackground = UIColor(named: "default_background")!
        static let defaultNavigationText = UIColor(named: "default_navigation_text")!
    }
    
    enum TextField {
        static let background = UIColor(named: "textfield_background")!
    }
    
    enum Text {
        static let defaultText = UIColor(named: "default_text")!
        static let lightGrayText = UIColor(named: "light_gray_text")!
    }
}
