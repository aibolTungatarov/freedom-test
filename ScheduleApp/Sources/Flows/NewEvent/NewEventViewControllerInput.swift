//
//  NewEventViewControllerInput.swift
//  ScheduleApp
//
//  Created by Айбол on 28.07.2023.
//

import Foundation

// MARK: - NewEventViewControllerInput
protocol NewEventViewControllerInput: AnyObject {
    func viewLoaded()
    func setTime(_ model: TimeModel)
    func setDay(_ model: DayModel)
    func timeFieldTapped()
    func addItemTapped()
    func setEventTitle(_ text: String)
}
