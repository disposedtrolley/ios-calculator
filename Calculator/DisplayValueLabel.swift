//
//  DisplayValueLabel.swift
//  Calculator
//
//  Created by James Liu on 24/10/17.
//  Copyright © 2017 James Liu. All rights reserved.
//

import UIKit

class DisplayValueLabel: UILabel {
    
    let formatter = NumberFormatter()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 6
        formatter.groupingSeparator = ""
    }
    
    override public var text: String? {
        didSet {
            if let text = text { formatText(text) }
        }
    }
    
    private func formatText(_ text: String) {
        if text.last != "." {
            let currentValue = Double(text)!
            super.text = formatter.string(from: NSNumber(value: currentValue))
        }
    }
}
