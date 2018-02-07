//
//  CalcModel.swift
//  RPNCalc
//
//  Created by Cao Xuyang on 2018/2/2.
//  Copyright © 2018年 COMP47390-41550. All rights reserved.
//

import Foundation

class CalcModel{
    private var stack = [Operation]()
    var supportedOperators : [String : Operation]
    var result: [Double] = []

    enum Operation: CustomStringConvertible {
        case operand(Double)
        case unaryOperator(String, (Double) -> Double)
        case binaryOperator(String, (Double, Double) -> Double)
        var description: String {
            get {
                switch self {
                case .operand(let value):
                    return "\(value)"
                case .binaryOperator(let symbol, _):
                    return symbol
                // UnaryOperator
                case .unaryOperator(let symbol, _):
                    return symbol
                
                }
            } }
    }
    
    
    init(){
        func newOperator(_ operation: Operation) {
            supportedOperators[operation.description] = operation
        }
        supportedOperators = [String: Operation]()
        supportedOperators["+"] = Operation.binaryOperator("+", +)
        supportedOperators["-"] = Operation.binaryOperator("-") {$1 - $0}
        supportedOperators["×"] = Operation.binaryOperator("×", *)
        supportedOperators["÷"] = Operation.binaryOperator("÷") {$1 / $0}
        supportedOperators["±"] = Operation.unaryOperator("±", -)
        newOperator(Operation.unaryOperator("±", -))
        newOperator(Operation.unaryOperator("COS", cos))
        newOperator(Operation.unaryOperator("SIN", sin))
        newOperator(Operation.unaryOperator("√", sqrt))
    }
    
    func pushOperand(_ operandValue: Double) -> [Double] {
        stack.append(Operation.operand(operandValue))
        return evaluateStack()
    }
    
    func performOperation(_ symbol: String) -> [Double]
    {
        
        if let operation = supportedOperators[symbol]{
            if checkOperands(symbol){
                stack.append(operation)
            }
            else{
                print("Invalid number of operands")
            }
        }
        return evaluateStack()
    }
    
    private func checkOperands(_ symbol: String) -> Bool{
        switch symbol {
        case "+","-","x","÷":
            return stack.count >= 2
        case "SIN","COS","±":
            return stack.count > 0
        case "√":
            if stack.count > 0 {
                
                if let num = result.first {
                    
                    return num >= 0
                }
                
            }
            return false
        default:
            print("Unknown operator, maybe you forget to add it to the function checkOperands")
            return false
        }
    }
    
    private func evaluateStack() -> [Double] {
        let (_, leftOverStack) = evaluateStack(true, stack)
        print("stack is \(stack) and [Double] is \(result) with \(leftOverStack) left over")
        return result
    }
    func allClear() -> [Double]{
        result = []
        stack = []
        return result
    }
    
    private func evaluateStack(_ changeArray: Bool, _ stack: [Operation]) -> (result: [Double], leftOverStack: [Operation]){
        if !stack.isEmpty {
            var leftOverStack = stack
            let operation = leftOverStack.removeLast()
            switch operation {
            case .operand(let operand):
                if(changeArray){
                    result.append(operand)
                } else {
                    let newRes = [operand]
                    return (newRes,leftOverStack)
                }
                return (result, leftOverStack)
                
            case .unaryOperator(_, let operation):
                let firstEval = evaluateStack(false, leftOverStack)
                if let firstEvalResult = firstEval.result.last {
                    if(changeArray){
                        result.removeLast()
                        result.append(operation(firstEvalResult))
                    }
                    return (result,firstEval.leftOverStack)
                }
                
            case .binaryOperator(_, let operation):
                let firstEval = evaluateStack(false, leftOverStack)
                if let firstEvalResult = firstEval.result.last {
                    if(changeArray){
                        result.removeLast()
                    }

                    let secondEval = evaluateStack(false, firstEval.leftOverStack)
                    if let secondEvalResult = secondEval.result.last {
                        if(changeArray){
                            result.removeLast()
                            //print("first: \(firstEvalResult), second: \(secondEvalResult), result: \(operation(firstEvalResult,secondEvalResult))")
                            result.append(operation(firstEvalResult,secondEvalResult))
                        }
                        return (result,secondEval.leftOverStack)
                        }
                }
            
            }
        }
        return ([], stack)
    }
}
