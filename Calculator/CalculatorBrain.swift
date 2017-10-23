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
    private var loggedSequence: [String] = []
    
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
            logCalculationSequenceItem(symbol)
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
            print(description)
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
            print(description)
            clearLoggedCalculationSequence()
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
        accumulator = operand
        logCalculationSequenceItem(String(operand))
    }
    
    mutating func logCalculationSequenceItem(_ item: String) {
        loggedSequence.append(item)
    }
    
    mutating func clearLoggedCalculationSequence() {
        loggedSequence.removeAll()
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    private var resultIsPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }
    
    private var description: String {
        get {
            var sequence = loggedSequence.joined(separator: " ")
            if resultIsPending {
                sequence = "\(sequence)  ..."
            }
            return sequence
        }
    }
}
