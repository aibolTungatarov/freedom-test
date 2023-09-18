//
//  UIView+Constraints.swift
//  ScheduleApp
//
//  Created by Айбол on 27.07.2023.
//

import UIKit

extension UIView {
    func pinToEdges(of superview: UIView, edgeInsets: UIEdgeInsets = .zero, safeArea: Bool = true) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: edgeInsets.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -edgeInsets.right),
            topAnchor.constraint(equalTo: superview.topAnchor, constant: edgeInsets.top),
        ])
        
        if safeArea {
            bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        }
    }
    
    func pinToTopEdges(of superview: UIView, height: CGFloat, insets: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets),
            topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor),
            heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    func pinToTopCenter(of superview: UIView, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor),
            heightAnchor.constraint(equalToConstant: height),
            centerXAnchor.constraint(equalTo: superview.centerXAnchor)
        ])
    }
    
    func pinToTopLeft(of superview: UIView, insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left)
        ])
    }
    
    func pinToTopRight(of superview: UIView, insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: insets.top),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right)
        ])
    }
    
    func set(size: CGSize) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height),
        ])
    }
    
    func set(size: CGFloat) {
        set(size: CGSize(width: size, height: size))
    }
}
