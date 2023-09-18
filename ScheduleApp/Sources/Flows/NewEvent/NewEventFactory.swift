//
//  NewEventFactory.swift
//  ScheduleApp
//
//  Created by Айбол on 28.07.2023.
//

import UIKit

final class NewEventFactory {
    func make(selectedDate: Date) -> NewEventViewController {
        let presenter = NewEventPresenter(selectedDate: selectedDate)
        let viewController = NewEventViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
}
