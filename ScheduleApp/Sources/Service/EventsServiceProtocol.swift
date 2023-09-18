//
//  EventsServiceProtocol.swift
//  ScheduleApp
//
//  Created by Айбол on 28.07.2023.
//

protocol EventsServiceProtocol {
    func fetchEvents() async -> [EventModel]
    func addEvent(_ model: EventModel) async
    func removeEvent(_ model: EventModel) async
}
