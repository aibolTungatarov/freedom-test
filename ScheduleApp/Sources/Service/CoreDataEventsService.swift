//
//  CoreDataEventsService.swift
//  ScheduleApp
//
//  Created by Айбол on 28.07.2023.
//

import CoreData

final class CoreDataEventsService: EventsServiceProtocol {
    private let persistance: NSPersistentContainer
    
    init(persistance: NSPersistentContainer) {
        self.persistance = persistance
        
        persistance.loadPersistentStores { _, _ in
            
        }
    }
    
    func fetchEvents() async -> [EventModel] {
        do {
            let eventsDAO = try persistance.viewContext.fetch(EventDAO.fetchRequest())
            
            var events: [EventModel] = []
            
            eventsDAO.forEach { event in
                if let title = event.title, let time = event.time {
                    events.append(EventModel(title: title, date: time))
                }
            }
            
            return events
        } catch {
            return []
        }
    }
    
    func addEvent(_ model: EventModel) async {
        let event = EventDAO(context: persistance.viewContext)
        event.time = model.date
        event.title = model.title
        
        do {
            try persistance.viewContext.save()
        } catch {}
    }
    
    func removeEvent(_ model: EventModel) async {
        do {
            let request = EventDAO.fetchRequest()
            
            let eventsDAO = try persistance.viewContext.fetch(request)
            
            guard let event = eventsDAO.first (where: { event in
                event.time == model.date && event.title == model.title
            }) else { return }
            persistance.viewContext.delete(event)
            
            try persistance.viewContext.save()
        } catch {}
    }
}
