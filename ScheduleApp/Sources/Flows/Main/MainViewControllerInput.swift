//
//  MainViewControllerInput.swift
//  ScheduleApp
//
//  Created by Айбол on 28.07.2023.
//

import Foundation

protocol MainViewControllerInput: AnyObject {
    var items: [MainEventCell.ViewModel] { get }
    var events: [EventModel] { get }
    func addEvent(_ model: EventModel)
    func deleteAtIndexPath(_ indexPath: IndexPath)
    func viewLoaded()
}
