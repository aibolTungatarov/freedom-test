//
//  SACalendarView.swift
//  ScheduleApp
//
//  Created by Айбол on 24.07.2023.
//

import Foundation
import UIKit
import HorizonCalendar

// MARK: - SACalendarView
final class SACalendarView: UIView {
    private lazy var calendarView: CalendarView = {
        let content = makeContent()
        let calendarView = CalendarView(initialContent: content)
        
        calendarView.backgroundColor = .Calendar.background
        
        return calendarView
    }()
    
    private let monthView: UIButton = {
        let button = UIButton(type: .custom)
        button.isUserInteractionEnabled = true
        let calendarImage = UIImage(systemName: "calendar")?.withRenderingMode(.alwaysTemplate)
        button.setImage(calendarImage, for: .normal)
        button.tintColor = .Calendar.monthText
        button.imageEdgeInsets.left = -16
        button.semanticContentAttribute = .forceLeftToRight
        button.setTitleColor(.Calendar.monthText, for: .normal)
        
        return button
    }()
    
    private let leftArrowButton: UIButton = {
        let button = LargeTapAreaButton()
        let image = UIImage(systemName: "arrow.left")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        button.isEnabled = false
        
        return button
    }()
    
    private let rightArrowButton: UIButton = {
        let button = LargeTapAreaButton()
        let image = UIImage(systemName: "arrow.right")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    private let calendar = Calendar.custom
    
    private lazy var dayDateFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.calendar = calendar
      dateFormatter.locale = calendar.locale
      dateFormatter.dateFormat = DateFormatter.dateFormat(
        fromTemplate: "EEEE, MMM d, yyyy",
        options: 0,
        locale: calendar.locale ?? Locale.current)
        
      return dateFormatter
    }()
    
    private let monthsLayout = MonthsLayout.horizontal(options: HorizontalMonthsLayoutOptions(maximumFullyVisibleMonths: 1))
    
    private(set) var selectedDate: Date?
    
    private lazy var visibleDateRange: ClosedRange<Date> = {
        Date()...Date().add(component: .year, value: 3)
    }()
    
    private var events: [EventModel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupObservers()
        setupViews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(events: [EventModel]) {
        self.events = events
        
        calendarView.setContent(makeContent())
    }
}

// MARK: - Actions
private extension SACalendarView {
    @objc
    private func leftArrowButtonTapped() {
        guard let components = calendarView.visibleMonthRange?.upperBound.components,
              let currentDate = getDate(from: components) else { return }
        
        let date = currentDate.add(component: .month, value: -1)
        
        guard visibleDateRange.contains(currentDate) else { return }
        
        calendarView.scroll(toMonthContaining: date, scrollPosition: .centered, animated: false)
        
        leftArrowButton.isEnabled = !visibleDateRange.lowerBound.monthYearEquals(calendar: calendar, to: date)
        rightArrowButton.isEnabled = !visibleDateRange.upperBound.monthYearEquals(calendar: calendar, to: date)
    }
    
    @objc
    private func rightArrowButtonTapped() {
        guard let components = calendarView.visibleMonthRange?.upperBound.components,
              let currentDate = getDate(from: components) else { return }
        
        let date = currentDate.add(component: .month, value: 1)
        
        guard visibleDateRange.contains(date) else { return }
        
        calendarView.scroll(toMonthContaining: date, scrollPosition: .centered, animated: false)
        
        leftArrowButton.isEnabled = !visibleDateRange.lowerBound.monthYearEquals(calendar: calendar, to: date)
        rightArrowButton.isEnabled = !visibleDateRange.upperBound.monthYearEquals(calendar: calendar, to: date)
    }
}

// MARK: - Private Methods
private extension SACalendarView {
    func monthCalendarItemModel(month: Month) -> CalendarItemModel<MonthHeaderView> {
        var viewProperties = MonthHeaderView.InvariantViewProperties.base
        viewProperties.edgeInsets = NSDirectionalEdgeInsets(top: 12, leading: 0, bottom: -8, trailing: 0)
        
        let itemModel = MonthHeaderView.calendarItemModel(
            invariantViewProperties: viewProperties,
            viewModel: MonthHeaderView.ViewModel.init(monthText: " ", accessibilityLabel: nil)
        )
        
        return itemModel
    }
    
    func getDate(from components: DateComponents) -> Date? {
        calendar.date(from: components)
    }
    
    func setupObservers() {
        leftArrowButton.addTarget(self, action: #selector(leftArrowButtonTapped), for: .touchUpInside)
        rightArrowButton.addTarget(self, action: #selector(rightArrowButtonTapped), for: .touchUpInside)
        
        calendarView.daySelectionHandler = { [weak self] day in
            guard let self else { return }
            
            if let selectedDate = self.selectedDate,
               let date = self.getDate(from: day.components),
               selectedDate.monthYearDayEquals(calendar: self.calendar, to: date) {
                self.selectedDate = nil
                self.calendarView.setContent(self.makeContent())
            } else {
                self.selectedDate = self.calendar.date(from: day.components)
                self.calendarView.setContent(self.makeContent())
            }
        }
    }
    
    func getMonthYearHeaderTitle(for month: Month) -> String {
        let monthName = dayDateFormatter.monthSymbols[month.month - 1]
        
        return monthName.capitalized + " " + month.year.description
    }
    
    func makeContent() -> CalendarViewContent {
        return CalendarViewContent(
            calendar: calendar,
            visibleDateRange: visibleDateRange,
            monthsLayout: monthsLayout
        )
        .interMonthSpacing(24)
        .verticalDayMargin(6)
        .horizontalDayMargin(12)
        .dayItemProvider { [calendar, dayDateFormatter] day in
            var viewProperties = DayView.InvariantViewProperties.baseInteractive
            
            let date = calendar.date(from: day.components)
            viewProperties.textColor = .Calendar.dayText
            switch date?.dayOfWeek {
            case .saturday, .sunday:
                viewProperties.textColor = .Calendar.weekendText
            default:
                break
            }
            
            if let _ = self.events.first (where: { event in
                date?.monthYearDayEquals(calendar: Calendar.custom, to: event.date) ?? false
            }) {
                viewProperties.textColor = .systemBlue
            }
            
            if date == self.selectedDate {
                viewProperties.backgroundShapeDrawingConfig.fillColor = .Calendar.selectedDayBackground
                viewProperties.textColor = .Calendar.selectedText
            }
            
            
            return DayView.calendarItemModel(
                invariantViewProperties: viewProperties,
                viewModel: .init(
                    dayText: day.day.description,
                    accessibilityLabel: date.map { dayDateFormatter.string(from: $0) },
                    accessibilityHint: nil))
        }
        .dayOfWeekItemProvider { month, weekdayIndex in
            var viewProperties = DayOfWeekView.InvariantViewProperties.base
            viewProperties.textColor = .Calendar.monthText
            if let weekDay = WeekDay(rawValue: weekdayIndex) {
                switch weekDay {
                case .saturday, .sunday:
                    viewProperties.textColor = .Calendar.weekendText
                default:
                    break
                }
            }
            
            return DayOfWeekView.calendarItemModel(
                invariantViewProperties: viewProperties,
                viewModel: .init(dayOfWeekText: self.calendar.veryShortWeekdaySymbols[weekdayIndex], accessibilityLabel: nil))
        }
        .monthHeaderItemProvider { month in
            self.monthView.setTitle(self.getMonthYearHeaderTitle(for: month), for: .normal)
            
            return self.monthCalendarItemModel(month: month)
        }
    }
}

// MARK: - Setup UI
private extension SACalendarView {
    func setupViews() {
        addSubview(calendarView)
        [monthView, leftArrowButton, rightArrowButton].forEach(calendarView.addSubview)
    }
    
    func setupConstraints() {
        calendarView.pinToEdges(of: self)
        monthView.pinToTopCenter(of: calendarView, height: Constants.monthHeaderHeight)
        
        rightArrowButton.set(size: Constants.arrowButtonSize)
        leftArrowButton.set(size: Constants.arrowButtonSize)
        
        NSLayoutConstraint.activate([
            leftArrowButton.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor, constant: Constants.defaultOffset),
            leftArrowButton.centerYAnchor.constraint(equalTo: monthView.centerYAnchor),
            
            rightArrowButton.rightAnchor.constraint(equalTo: calendarView.rightAnchor, constant: -Constants.defaultOffset),
            rightArrowButton.centerYAnchor.constraint(equalTo: monthView.centerYAnchor)
        ])
    }
}

// MARK: - Constants
private extension SACalendarView {
    private enum Constants {
        static let arrowButtonSize: CGFloat = 18
        static let monthHeaderHeight: CGFloat = 48
        static let defaultOffset: CGFloat = 16
    }
}

