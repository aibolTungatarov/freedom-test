//
//  MainFactory.swift
//  ScheduleApp
//
//  Created by Айбол on 28.07.2023.
//

import UIKit

final class MainFactory {
    func make() -> UINavigationController {
        let presenter = MainPresenter(eventsService: CoreDataEventsService(persistance: .init(name: "EventDataModel")))
        let viewController = MainViewController(presenter: presenter)
        presenter.view = viewController
        
        return UINavigationController(rootViewController: viewController)
    }
}
