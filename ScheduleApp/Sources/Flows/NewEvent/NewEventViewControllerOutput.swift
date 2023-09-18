//
//  NewEventViewOutput.swift
//  ScheduleApp
//
//  Created by Айбол on 28.07.2023.
//

import Foundation

// MARK: - NewEventViewOutput
protocol NewEventViewControllerOutput: AnyObject {
    /// Обновляет значения в dateField и timeField
    ///
    /// - Parameters:
    ///     - date: Текст для dateField
    ///     - time: Текст для timeField
    func updateEventTime(with date: String, time: String)
    
    /// Показывает Date Picker для выбора времени (hour and minute)
    ///
    /// - Parameters:
    ///     - time: Изначально выбранное время
    func showDatePicker(with time: TimeModel)
    
    /// Отправляет уведомление о том что нужно добавить event
    ///
    ///  - Parameters:
    ///     - event: Модель для добавления  Ивента
    func addEvent(model: EventModel)
}
