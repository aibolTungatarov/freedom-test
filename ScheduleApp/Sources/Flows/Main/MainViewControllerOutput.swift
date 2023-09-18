//
//  MainViewControllerOutput.swift
//  ScheduleApp
//
//  Created by Айбол on 28.07.2023.
//

import Foundation

// MARK: - MainViewControllerOutput
protocol MainViewControllerOutput: AnyObject {
    @MainActor
    func reloadItems()
    @MainActor
    func deleteRows(at indexPath: [IndexPath])
    @MainActor
    func insertRow(at indexPath: [IndexPath])
}
