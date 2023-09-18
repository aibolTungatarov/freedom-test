//
//  MainEventCell.swift
//  ScheduleApp
//
//  Created by Айбол on 28.07.2023.
//

import UIKit

final class MainEventCell: UITableViewCell {
    struct ViewModel {
        let title: String
        let time: String
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .View.defaultNavigationText
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .View.defaultNavigationText
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let containerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: ViewModel) {
        titleLabel.text = viewModel.title
        timeLabel.text = viewModel.time
    }
}

// MARK: - Setup UI
private extension MainEventCell {
    func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear
        containerView.backgroundColor = .Calendar.background
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        
        contentView.addSubview(containerView)
        
        [lineView, titleLabel, timeLabel].forEach(containerView.addSubview)
    }
    
    func setupConstraints() {
        containerView.pinToEdges(of: contentView, edgeInsets: UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
        
        NSLayoutConstraint.activate([
            lineView.widthAnchor.constraint(equalToConstant: Constants.lineViewWidth),
            lineView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 6),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            titleLabel.leadingAnchor.constraint(equalTo: lineView.trailingAnchor, constant: 8),
            
            lineView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -6),
            lineView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            
            timeLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            titleLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -16),
        ])
    }
}

// MARK: - Constants
private extension MainEventCell {
    private enum Constants {
        static let lineViewWidth: CGFloat = 2
    }
}
