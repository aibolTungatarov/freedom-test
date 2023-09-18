//
//  NewEventPresenter.swift
//  ScheduleApp
//
//  Created by Айбол on 27.07.2023.
//

import Foundation

// MARK: - NewEventPresenter
final class NewEventPresenter: NewEventViewControllerInput {
    var selectedDate: Date
    
    weak var view: NewEventViewControllerOutput?
    
    private var eventTitle = ""
    
    init(selectedDate: Date) {
        self.selectedDate = selectedDate
    }
    
    func viewLoaded() {
        selectedDate = selectedDate.addingTimeInterval(60 * 60)
        
        updateView()
    }
    
    func setTime(_ model: TimeModel) {
        var components = getComponents()
        
        components.hour = model.hour
        components.minute = model.minute
        
        updateSelectedDate(with: components)
    }
    
    func setDay(_ model: DayModel) {
        var components = getComponents()
        
        components.year = model.year
        components.month = model.month
        components.day = model.day
        
        updateSelectedDate(with: components)
    }
    
    
    func timeFieldTapped() {
        let components = getComponents()
        
        guard let hour = components.hour, let minute = components.minute else { return }
        
        view?.showDatePicker(with: TimeModel(hour: hour, minute: minute))
    }
    
    func addItemTapped() {
        let model = EventModel(title: eventTitle, date: selectedDate)
        
        view?.addEvent(model: model)
    }
    
    func setEventTitle(_ text: String) {
        eventTitle = text
    }
}

// MARK: - Private Methods
private extension NewEventPresenter {
    func updateView() {
        let date = DateFormatter.dayMonthYearFormatter.string(from: selectedDate).capitalized
        let time = DateFormatter.hourMinutesFormatter.string(from: selectedDate)
        
        view?.updateEventTime(
            with: date,
            time: time
        )
    }
    
    func getComponents() -> DateComponents {
        return Calendar.custom.dateComponents([.year, .month, .day, .hour, .minute], from: selectedDate)
    }
    
    func updateSelectedDate(with components: DateComponents) {
        guard let changeDate = Calendar.custom.date(from: components) else { return }
        
        selectedDate = changeDate
        
        updateView()
    }
}
