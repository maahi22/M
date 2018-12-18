//
//  NSExpression+Maths.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 03/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import Foundation

extension NSExpression {
    
    func toFloatingPoint() -> NSExpression {
        switch expressionType {
        case .constantValue:
            if let value = constantValue as? NSNumber {
                return NSExpression(forConstantValue: NSNumber(value: value.doubleValue))
            }
        case .function:
            let newArgs = arguments.map { $0.map { $0.toFloatingPoint() } }
            return NSExpression(forFunction: operand, selectorName: function, arguments: newArgs)
        case .conditional:
            return NSExpression(forConditional: predicate, trueExpression: self.true.toFloatingPoint(), falseExpression: self.false.toFloatingPoint())
        case .unionSet:
            return NSExpression(forUnionSet: left.toFloatingPoint(), with: right.toFloatingPoint())
        case .intersectSet:
            return NSExpression(forIntersectSet: left.toFloatingPoint(), with: right.toFloatingPoint())
        case .minusSet:
            return NSExpression(forMinusSet: left.toFloatingPoint(), with: right.toFloatingPoint())
        case .subquery:
            if let subQuery = collection as? NSExpression {
                return NSExpression(forSubquery: subQuery.toFloatingPoint(), usingIteratorVariable: variable, predicate: predicate)
            }
        case .aggregate:
            if let subExpressions = collection as? [NSExpression] {
                return NSExpression(forAggregate: subExpressions.map { $0.toFloatingPoint() })
            }
        case .anyKey:
            fatalError("anyKey not yet implemented")
        case .block:
            fatalError("block not yet implemented")
        case .evaluatedObject, .variable, .keyPath:
            break // Nothing to do here
        }
        return self
    }
    
    
    
    
    
    func toFloatingPointDivision() -> NSExpression {
        switch expressionType {
        case .function where function == "divide:by:":
            guard let args = arguments else { break }
            let newArgs = args.map({ arg -> NSExpression in
                if arg.expressionType == .constantValue {
                    if let value = arg.constantValue as? Double {
                        return NSExpression(forConstantValue: value)
                    } else {
                        return arg
                    }
                } else {
                    return NSExpression(block: { (object, arguments, context) in
                        // NB: The type of `+[NSExpression expressionForBlock:arguments]` is incorrect.
                        // It claims the arguments is an array of NSExpressions, but it's not, it's
                        // actually an array of the evaluated values. We can work around this by going
                        // through NSArray.
                        guard let arg = (arguments as NSArray).firstObject else { return NSNull() }
                        return (arg as? Double) ?? arg
                    }, arguments: [arg.toFloatingPointDivision()])
                }
            })
            return NSExpression(forFunction: operand, selectorName: function, arguments: newArgs)
        case .function:
            guard let args = arguments else { break }
            let newArgs = args.map({ $0.toFloatingPointDivision() })
            return NSExpression(forFunction: operand, selectorName: function, arguments: newArgs)
        case .conditional:
            return NSExpression(forConditional: predicate,
                                trueExpression: self.true.toFloatingPointDivision(),
                                falseExpression: self.false.toFloatingPointDivision())
        case .unionSet:
            return NSExpression(forUnionSet: left.toFloatingPointDivision(), with: right.toFloatingPointDivision())
        case .intersectSet:
            return NSExpression(forIntersectSet: left.toFloatingPointDivision(), with: right.toFloatingPointDivision())
        case .minusSet:
            return NSExpression(forMinusSet: left.toFloatingPointDivision(), with: right.toFloatingPointDivision())
        case .subquery:
            if let subQuery = collection as? NSExpression {
                return NSExpression(forSubquery: subQuery.toFloatingPointDivision(), usingIteratorVariable: variable, predicate: predicate)
            }
        case .aggregate:
            if let subExpressions = collection as? [NSExpression] {
                return NSExpression(forAggregate: subExpressions.map({ $0.toFloatingPointDivision() }))
            }
        case .block:
            guard let args = arguments else { break }
            let newArgs = args.map({ $0.toFloatingPointDivision() })
            return NSExpression(block: expressionBlock, arguments: newArgs)
        case .constantValue, .anyKey:
        break // Nothing to do here
        case .evaluatedObject, .variable, .keyPath:
            // FIXME: These should probably be wrapped in blocks like the one
            // used in the `.function` case.
            break
        }
        return self
    }
    
    
    
    
    
}


