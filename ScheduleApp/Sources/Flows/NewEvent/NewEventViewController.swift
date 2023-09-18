//
//  NewEventViewController.swift
//  ScheduleApp
//
//  Created by Айбол on 24.07.2023.
//

import UIKit

// MARK: - NewEventViewController
final class NewEventViewController: UIViewController {
    weak var delegate: NewEventViewControllerDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .View.defaultNavigationText
        label.text = "New Event"
        
        return label
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let eventTitleField = SATextField(
        viewProperties: .init(
            title: "Event Title",
            placeholder: "Enter Event Title",
            keyboardType: .default,
            type: .editable
        )
    )
    
    private let dateField = SATextField(
        viewProperties: .init(
            title: "Date",
            keyboardType: .default,
            type: .tappable
        )
    )
    
    private let timeField = SATextField(
        viewProperties: .init(
            title: "Time",
            keyboardType: .default,
            type: .tappable
        )
    )
    
    private lazy var rightBarButtonItem = UIBarButtonItem(
        title: "Add",
        style: .done,
        target: self,
        action: #selector(addItemTapped)
    )
    
    private let presenter: NewEventViewControllerInput
    
    init(presenter: NewEventViewControllerInput) {
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
        setupObservers()
        
        presenter.viewLoaded()
    }
}

// MARK: - NewEventViewOutput
extension NewEventViewController: NewEventViewControllerOutput {
    func updateEventTime(with date: String, time: String) {
        dateField.text = date
        timeField.text = time
    }
    
    func showDatePicker(with time: TimeModel) {
        let viewController = DatePickerViewController(selectedTime: time)
        viewController.delegate = self
        viewController.modalPresentationStyle = .automatic
        
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
    
    func addEvent(model: EventModel) {
        delegate?.newEventViewController(add: model)
        
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Actions
private extension NewEventViewController {
    @objc
    private func addItemTapped() {
        presenter.addItemTapped()
    }
}

// MARK: - DatePickerViewControllerDelegate
extension NewEventViewController: DatePickerViewControllerDelegate {
    func datePicker(didSelect time: TimeModel) {
        presenter.setTime(time)
    }
}

// MARK: - Private Methods
private extension NewEventViewController {
    func setupObservers() {
        eventTitleField.onEdit = { [unowned self] text in
            self.presenter.setEventTitle(text)
            self.rightBarButtonItem.isEnabled = !text.isEmpty
        }
        
        timeField.onTap = { [unowned self] in
            self.presenter.timeFieldTapped()
        }
    }
    
    func buildHorizontalStackView(from subviews: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: subviews)
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.axis = .horizontal
        
        return stackView
    }
}

// MARK: - Setup UI
private extension NewEventViewController {
    func setupNavigationItem() {
        navigationItem.titleView = titleLabel
        
        rightBarButtonItem.isEnabled = !(eventTitleField.text?.isEmpty ?? true)
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func setupViews() {
        view.backgroundColor = .View.defaultBackground
        view.addSubview(verticalStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultOffset),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultOffset),
            verticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.defaultOffset),
            verticalStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            timeField.widthAnchor.constraint(equalToConstant: 86)
        ])
        
        verticalStackView.addArrangedSubview(buildHorizontalStackView(from: [eventTitleField]))
        verticalStackView.addArrangedSubview(buildHorizontalStackView(from: [dateField, timeField]))
    }
}

// MARK: - Constants
private extension NewEventViewController {
    private enum Constants {
        static let defaultOffset: CGFloat = 16
    }
}
