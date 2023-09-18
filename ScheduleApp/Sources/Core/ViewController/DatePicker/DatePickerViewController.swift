//
//  DatePickerViewController.swift
//  ScheduleApp
//
//  Created by Айбол on 28.07.2023.
//

import UIKit

// MARK: - DatePickerViewControllerDelegate
protocol DatePickerViewControllerDelegate: AnyObject {
    func datePicker(didSelect time: TimeModel)
}

// MARK: - DatePickerViewController
final class DatePickerViewController: UIViewController {
    weak var delegate: DatePickerViewControllerDelegate?
    
    private var selectedTime: TimeModel
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .View.defaultNavigationText
        label.text = "Choose Time"
        
        return label
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.date = Date()
        picker.locale = Calendar.custom.locale
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        picker.datePickerMode = .time
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        return picker
    }()
    
    init(selectedTime: TimeModel) {
        self.selectedTime = selectedTime
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        datePicker.addTarget(self, action: #selector(handleDateSelection), for: .valueChanged)
        setupNavigationItem()
        setupViews()
        setupConstraints()
    }
}

// MARK: - Actions
private extension DatePickerViewController {
    @objc
    private func handleDateSelection() {
        let components = Calendar.custom.dateComponents([.hour, .minute], from: datePicker.date)
        
        guard let hour = components.hour, let minute = components.minute else { return }
        
        selectedTime = TimeModel(hour: hour, minute: minute)
    }
    
    @objc
    private func addItemTapped() {
        delegate?.datePicker(didSelect: selectedTime)
        
        dismiss(animated: true)
    }
}


// MARK: - Setup UI
private extension DatePickerViewController {
    func setupNavigationItem() {
        navigationItem.titleView = titleLabel
        
        let rightBarButtonItem = UIBarButtonItem(
            title: "Update",
            style: .plain,
            target: self,
            action: #selector(addItemTapped)
        )
        
        rightBarButtonItem.tintColor = .View.defaultNavigationText
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func setupViews() {
        view.backgroundColor = .View.defaultBackground
        view.addSubview(datePicker)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultOffset),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultOffset),
            datePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: Constants.datePickerHeight)
        ])
    }
}

// MARK: - Constants
private extension DatePickerViewController {
    private enum Constants {
        static let defaultOffset: CGFloat = 16
        static let datePickerHeight: CGFloat = 260
    }
}
