//
//  SATextField.swift
//  ScheduleApp
//
//  Created by Айбол on 24.07.2023.
//

import UIKit

// MARK: - SATextField
final class SATextField: UIView {
    struct ViewProperties {
        enum TextFieldType {
            case editable
            case tappable
        }
        
        let title: String
        let placeholder: String?
        let keyboardType: UIKeyboardType
        let type: TextFieldType
        
        init(
            title: String,
            placeholder: String? = nil,
            keyboardType: UIKeyboardType,
            type: TextFieldType
        ) {
            self.title = title
            self.placeholder = placeholder
            self.keyboardType = keyboardType
            self.type = type
        }
    }
    
    var onTap: SACommand?
    var onEdit: ((String) -> Void)?
    
    var text: String? {
        didSet {
            textField.text = text
            
            onEdit?(text ?? .init())
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .Text.lightGrayText
        
        return label
    }()
    
    private let textField = UITextField()
    
    init(viewProperties: ViewProperties) {
        super.init(frame: .zero)
        
        titleLabel.text = viewProperties.title
        
        textField.keyboardType = viewProperties.keyboardType
        textField.returnKeyType = .done
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .sentences
        textField.clearsOnBeginEditing = false
        textField.setLeftPaddingPoints(8)
        textField.placeholder = viewProperties.placeholder
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        switch viewProperties.type {
        case .editable:
            textField.isEnabled = true
        case .tappable:
            textField.isEnabled = false
            
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(textFieldDidTap)))
        }
        
        textField.layer.cornerRadius = 8
        textField.backgroundColor = .TextField.background
        
        setupViews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITextInputDelegate
extension SATextField: UITextFieldDelegate {
    
}

private extension SATextField {
    @objc
    private func textFieldDidTap() {
        onTap?()
    }
    
    @objc
    private func textFieldDidChange() {
        text = textField.text
    }
}

// MARK: - Setup UI
private extension SATextField {
    func setupViews() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        addSubview(textField)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
