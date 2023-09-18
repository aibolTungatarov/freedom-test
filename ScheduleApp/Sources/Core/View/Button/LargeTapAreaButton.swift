//
//  LargeTapAreaButton.swift
//  ScheduleApp
//
//  Created by Айбол on 27.07.2023.
//

import UIKit

class LargeTapAreaButton: UIButton {
    private let inset: CGFloat
    
    init(inset: CGFloat = 8) {
        self.inset = inset
        
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        bounds.insetBy(dx: -inset, dy: -inset).contains(point)
    }
}
