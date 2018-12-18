//
//  TryCatch.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 06/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import Foundation
import UIKit

/*
func `try`(`try`:@escaping ()->()) -> TryCatch {
    return TryCatch(`try`)
}
class TryCatch {
    let tryFunc : ()->()
    var catchFunc = { (e:NSException!)->() in return }
    var finallyFunc : ()->() = {}
    
    init(_ `try`:@escaping ()->()) {
        tryFunc = `try`
    }
    
    func `catch`(`catch`:@escaping (NSException)->()) -> TryCatch {
        // objc bridging needs NSException!, not NSException as we'd like to expose to clients.
        catchFunc = { (e:NSException!) in `catch`(e) }
        return self
    }
    
    func finally(finally:@escaping ()->()) {
        finallyFunc = finally
    }
    
    deinit {
        TryCatch(tryFunc, catchFunc, finallyFunc)
    }
}
 
 
 
 
 `try` {
 let expn = NSExpression(format: "60****2")
 
 //let resultFloat = expn.expressionValueWithObject(nil, context: nil).floatValue
 // Other things...
 }.`catch` { e in
 // Handle error here...
 print("Error: \(e)")
 }
 
 
 
 //https://stackoverflow.com/questions/24710424/catch-an-exception-for-invalid-user-input-in-swift
*/
