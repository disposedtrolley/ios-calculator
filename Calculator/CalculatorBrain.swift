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
    private var lastActionWasEquals = false
    
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
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
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
        print(operand)
        updateCalculationSequence(with: String(operand))
        accumulator = operand
    }
    
    private mutating func updateCalculationSequence(with item: String) {
        if lastActionWasEquals {
            loggedSequence = loggedSequence.filter({ $0 != "=" })   // remove equals sign from the sequence as the operation is continuing
            lastActionWasEquals = false
        }
        if let operation = operations[item], case .unaryOperation = operation {
            insertParenthesesInSequence(from: 0, to: loggedSequence.count - 1)      // insert parentheses to wrap operands of unary operations
            loggedSequence.insert(item, at: 0)      // prepend the unary operation
        } else {
            loggedSequence.append(item)
        }
    }
    
    private mutating func insertParenthesesInSequence(from index1: Int, to index2: Int) {
        loggedSequence.insert("(", at: index1 - 1)
        loggedSequence.insert(")", at: index2 + 1)
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
    
    var description: String {
        get {
            var sequence = loggedSequence.joined(separator: " ")
            if resultIsPending {
                sequence = "\(sequence)  ..."
            }
            return sequence
        }
    }
}
