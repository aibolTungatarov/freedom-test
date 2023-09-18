//
//  NewEventViewControllerDelegate.swift
//  ScheduleApp
//
//  Created by Айбол on 28.07.2023.
//

import Foundation

// MARK: - NewEventViewControllerDelegate
protocol NewEventViewControllerDelegate: AnyObject {
    /// Отправляет уведомление о том что нужно добавить event
    ///
    ///  - Parameters:
    ///     - event: Модель для добавления  Ивента
    func newEventViewController(add event: EventModel)
}
