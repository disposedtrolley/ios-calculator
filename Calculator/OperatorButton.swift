//
//  OperatorButton.swift
//  Calculator
//
//  Created by James Liu on 23/10/17.
//  Copyright © 2017 James Liu. All rights reserved.
//

import UIKit
import Chameleon

class OperatorButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setButtonColors()
        
    }
    
    func setButtonColors() {
        var backgroundColor: UIColor
        switch self.currentTitle! {
        case "=":
            backgroundColor = UIColor.flatRed()
        case "C":
            backgroundColor = UIColor.flatRed()
        default:
            backgroundColor = UIColor.flatMint()
        }
        self.backgroundColor = backgroundColor
        self.setTitleColor(UIColor.white, for: UIControlState.normal)
    }
}
