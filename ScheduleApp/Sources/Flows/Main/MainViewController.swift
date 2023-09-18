//
//  MainViewController.swift
//  ScheduleApp
//
//  Created by Айбол on 24.07.2023.
//

import UIKit

// MARK: - MainViewController
final class MainViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .View.defaultNavigationText
        label.text = "Events Calendar"
        
        return label
    }()
    
    private let calendarView: SACalendarView = {
        let calendarView = SACalendarView()
        calendarView.layer.cornerRadius = 16
        calendarView.clipsToBounds = true
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        return calendarView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.registerCell(MainEventCell.self)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    private let calendarContainerView = UIView(frame: .init(origin: .zero, size: .init(width: UIScreen.main.bounds.width, height: Constants.calendarHeight)))
        
    private let presenter: MainViewControllerInput
    
    init(presenter: MainViewControllerInput) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
        setupViews()
        setupConstraints()
        
        presenter.viewLoaded()
        
        tableView.tableHeaderView = calendarContainerView
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - MainViewControllerOutput
extension MainViewController: MainViewControllerOutput {
    @MainActor
    func reloadItems() {
        tableView.reloadData()
        
        calendarView.set(events: presenter.events)
    }
    
    @MainActor
    func deleteRows(at indexPath: [IndexPath]) {
        tableView.deleteRows(at: indexPath, with: .left)
        
        calendarView.set(events: presenter.events)
    }
    
    @MainActor
    func insertRow(at indexPath: [IndexPath]) {
        tableView.insertRows(at: indexPath, with: .bottom)
        
        calendarView.set(events: presenter.events)
    }
}

// MARK: - Actions
private extension MainViewController {
    @objc
    private func addItemTapped() {
        let viewController = NewEventFactory().make(selectedDate: calendarView.selectedDate ?? Date())
        viewController.delegate = self
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - NewEventViewControllerDelegate
extension MainViewController: NewEventViewControllerDelegate {
    func newEventViewController(add event: EventModel) {
        presenter.addEvent(event)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MainEventCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: presenter.items[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.deleteAtIndexPath(indexPath)
            
        }
    }
}

// MARK: - Setup UI
private extension MainViewController {
    func setupNavigationItem() {
        navigationItem.titleView = titleLabel
        
        let rightBarButtonItem = UIBarButtonItem(
            title: "Add",
            style: .done,
            target: self,
            action: #selector(addItemTapped)
        )
        rightBarButtonItem.tintColor = .View.defaultNavigationText
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func setupViews() {
        view.backgroundColor = .View.defaultBackground
        view.addSubview(tableView)
        calendarContainerView.addSubview(calendarView)
    }
    
    func setupConstraints() {
        tableView.pinToEdges(of: view, safeArea: false)
        calendarView.pinToEdges(of: calendarContainerView, edgeInsets: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16))
    }
}

// MARK: - Constants
private extension MainViewController {
    private enum Constants {
        static let calendarHeight: CGFloat = 400
    }
}

