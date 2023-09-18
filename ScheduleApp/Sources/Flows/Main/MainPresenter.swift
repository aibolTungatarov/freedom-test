//
//  MainPresenter.swift
//  ScheduleApp
//
//  Created by Айбол on 27.07.2023.
//

import Foundation

// MARK: - MainPresenter
final class MainPresenter: MainViewControllerInput {
    weak var view: MainViewControllerOutput?
    
    var items: [MainEventCell.ViewModel] = []
    var events: [EventModel] = []
    
    private let eventsService: EventsServiceProtocol
    
    init(eventsService: EventsServiceProtocol) {
        self.eventsService = eventsService
    }
    
    func viewLoaded() {
        Task {
            var events = await eventsService.fetchEvents()
            events = events.sorted(by: { first, second in
                first.date < second.date
            })
            self.events = events
            items = events.map { getViewModel(from: $0) }
            
            await view?.reloadItems()
        }
    }
    
    func addEvent(_ model: EventModel) {
        Task {
            await eventsService.addEvent(model)
            
            events.insert(model, at: 0)
            
            events = events.sorted(by: { first, second in
                first.date < second.date
            })
            
            let index = events.firstIndex { event in
                event == model
            }
            
            items = events.map { getViewModel(from: $0) }
            
            guard let index else {
                viewLoaded()
                
                return
            }
            
            await view?.insertRow(at: [IndexPath(row: index, section: 0)])
        }
    }
    
    func deleteAtIndexPath(_ indexPath: IndexPath) {
        Task {
            await eventsService.removeEvent(events[indexPath.row])
            
            events.remove(at: indexPath.row)
            items.remove(at: indexPath.row)
            
            await view?.deleteRows(at: [indexPath])
        }
    }
    
    private func getViewModel(from event: EventModel) -> MainEventCell.ViewModel {
        let time: String
        
        if event.date.monthYearDayEquals(calendar: Calendar.custom, to: Date()) {
            time = DateFormatter.hourMinutesFormatter.string(from: event.date)
        } else if event.date.yearEquals(calendar: Calendar.custom, to: Date()) {
            time = DateFormatter.monthDayHourMinutesFormatter.string(from: event.date)
        } else {
            time = DateFormatter.fullDateFormatter.string(from: event.date)
        }
        
        return MainEventCell.ViewModel(title: event.title, time: time)
    }
}
