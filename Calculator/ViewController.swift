//
//  ViewController.swift
//  Calculator
//
//  Created by James Liu on 22/10/17.
//  Copyright © 2017 James Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var calculationSequence: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    var floatingPointPresent = false
    private var brain = CalculatorBrain()

    override func viewDidLoad() {
        displayValue = 0
        calculationSequenceValue = " "
    }
    
    // Computed Properties
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)     // newValue is whatever is on the right hand side of the assignment
        }
    }
    
    var calculationSequenceValue: String {
        get {
            return String(calculationSequence.text!)
        }
        set {
            calculationSequence.text = String(newValue)
        }
    }
    
    @IBAction func addFloatingPoint(_ sender: UIButton) {
        let floatingPoint = sender.currentTitle!
        if !floatingPointPresent && userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + floatingPoint
            floatingPointPresent = true
        }
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
            floatingPointPresent = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
        calculationSequenceValue = brain.description
    }
}
