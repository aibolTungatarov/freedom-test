//
//  UITableView+Dequeue.swift
//  ScheduleApp
//
//  Created by Айбол on 28.07.2023.
//

import UIKit

extension UITableView {
    func registerCell<T: UITableViewCell>(_ cell: T.Type) {
        register(T.self, forCellReuseIdentifier: "\(T.self)")
    }
    
    func dequeueCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: "\(T.self)", for: indexPath) as? T else {
            fatalError("couldn't dequeue \(T.self)")
        }
        
        return cell
    }
}
