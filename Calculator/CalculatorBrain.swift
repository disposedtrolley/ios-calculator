//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by James Liu on 23/10/17.
//  Copyright © 2017 James Liu. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    private var calculationSequence: [String] = []
    var lastActionWasEquals = false
    
    private enum Operation {
        case constant(Double)   // associated value
        case unaryOperation((Double) -> Double)     // function that takes and returns a Double
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "√": Operation.unaryOperation(sqrt),
        "cos": Operation.unaryOperation(cos),
        "±": Operation.unaryOperation({ -$0 }),
        "×": Operation.binaryOperation({ $0 * $1 }),
        "÷": Operation.binaryOperation({ $0 / $1 }),
        "+": Operation.binaryOperation({ $0 + $1 }),
        "−": Operation.binaryOperation({ $0 - $1 }),
        "=": Operation.equals
    ]

    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            
            updateCalculationSequence(with: symbol)
            
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if resultIsPending && accumulator != nil {
                    performPendingBinaryOperation()
                }
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                }
                accumulator = nil
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    mutating func resetCalculatorBrain() {
        accumulator = nil
        calculationSequence = []
        lastActionWasEquals = false
        pendingBinaryOperation = nil
    }
    
    private mutating func performPendingBinaryOperation() {
        if resultIsPending && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
            lastActionWasEquals = true
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        updateCalculationSequence(with: String(operand))
        accumulator = operand
    }
    
    private mutating func updateCalculationSequence(with item: String) {
        if item != "=" {
            calculationSequence.append(item)
        }
        if lastActionWasEquals { lastActionWasEquals = false }
    }
    
    private mutating func insertParenthesesInSequence(from index1: Int, to index2: Int) {
        calculationSequence.insert("(", at: index1)
        calculationSequence.insert(")", at: index2)
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    var resultIsPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }
    
    var description: String {
        get {
            return calculationSequence.joined(separator: " ")
        }
    }
}
