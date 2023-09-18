//
//  MainCalendarCell.swift
//  ScheduleApp
//
//  Created by Айбол on 28.07.2023.
//

import UIKit

final class MainCalendarCell: UITableViewCell {
    private let calendarView: SACalendarView = {
        let calendarView = SACalendarView()
        calendarView.layer.cornerRadius = 16
        calendarView.clipsToBounds = true
        
        return calendarView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
}

// MARK: - Setup UI
private extension MainCalendarCell {
    func setupViews() {
        contentView.addSubview(calendarView)
    }

    func setupConstraints() {
        calendarView.pinToTopEdges(of: contentView, height: Constants.calendarHeight, insets: 16)
    }
}
// MARK: - Constants
private extension MainCalendarCell {
    private enum Constants {
        static let calendarHeight: CGFloat = 400
    }
}
