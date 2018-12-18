//
//  MathsHelper.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 10/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import Foundation

//func splitStringBy(_ numberStr:String) -> [Str]

func forTrailingZero(temp: Double) -> String {
    let tempVar = String(format: "%g", temp)
    return tempVar
}

func resultWithCalculation(_ expStr:String) -> String{
    var reultStr = expStr
   
    if reultStr.contains("e+"){
        return reultStr
        
    }else if reultStr.contains(".") && !reultStr.contains("e+"){
        let resultArr = reultStr.components(separatedBy: ".")
        let  decimalVal = resultArr[1]//string.prefix(4)
        if decimalVal.contains("1")||decimalVal.contains("2")||decimalVal.contains("3")||decimalVal.contains("4")||decimalVal.contains("5")||decimalVal.contains("6")||decimalVal.contains("7")||decimalVal.contains("8")||decimalVal.contains("9"){
            return reultStr
        }else{
            return resultArr[0]
        }
//        let characterset = CharacterSet(charactersIn: "123456789")
//        if decimalVal.rangeOfCharacter(from: characterset.inverted) != nil {
//            //print("string contains special characters")
//            return resultArr[0]
//        }
    }
    
    return reultStr
    
}



func checkExperationLengthExceeded(_ experationStr:String ,mathOperator:String) ->Bool{
    var expLengthExceedstatus = false
    if mathOperator != nil {
       
        let resultArr = experationStr.components(separatedBy: mathOperator)
        guard let expStr = resultArr.last else{   return expLengthExceedstatus }
        if expStr.count >= 14{
            expLengthExceedstatus = true
        }
    }else{
        if experationStr.count >= 14{
            expLengthExceedstatus = true
        }
    }
    
    return expLengthExceedstatus
    
}

func checkFirstCharIsOperator(_ expresion:String)-> Bool{
    
    if expresion.count == 1 && (expresion == "+" || expresion == "-" || expresion == "*" || expresion == "x" || expresion == "%" || expresion == "/" || expresion == "=") {
        return true
    }
    return false
   
}

func checkFirstCharIsZero(_ expresion:String)-> Bool{
    if expresion.count == 1 && (expresion == "0") {
        return true
    }
    return false
}

func checkLastCharIsOperator(_ expresion:String)-> Bool{
    if expresion.count > 0 && (expresion.last == "+" || expresion.last  == "-" || expresion.last  == "*" || expresion.last  == "x" || expresion.last  == "×"  || expresion.last  == "X"  || expresion.last  == "%" || expresion.last  == "/") {
        return true
    }
    return false
    
}

func checkLastCharIsDot(_ expresion:String)-> Bool{
    if expresion.count > 0 && (expresion.last == ".") {
        return true
    }
    return false
    
}

func checkMyFirstCalOperator(_ expresion:String)-> Bool{
    
    if expresion.contains(".") ||  expresion.contains("*") || expresion.contains("/") || expresion.contains("%") || expresion.contains("multiply") || expresion.contains("Multiply") || expresion.contains("divide") || expresion.contains("Divide") || expresion.contains("by") || expresion.contains("By") || expresion.contains("Buy")  || expresion.contains("buy") || expresion.contains("in2") || expresion.contains("into") || expresion.contains("Into") || expresion.contains("÷") || expresion.contains("percentage") || expresion.contains("x") || expresion.contains("×") || expresion.contains("X") || expresion.contains("dot")  || expresion.contains("point")  || expresion.contains("Dot")  || expresion.contains("Point")  {
        
        return true
    }
    return false
    
}


func checkDotOperator(_ expresion:String, lastOprt:String)-> Bool{
    
    if lastOprt != "" {
        let resultArr = expresion.components(separatedBy: lastOprt)
        guard let expStr = resultArr.last else{   return true }
        if expStr.contains("."){
            return true
        }else{
            return false
        }
    }else if expresion.contains("."){
        return true
    }
    return false
}

//let ACCEPTABLE_operator = "+-/*=%"
func getLastOperator(_ experationStr :String)-> String {

    var returnval = ""
    let reversed = String(experationStr.reversed())
    if reversed.count == 0 {
        return returnval
    }
    
    
   /* for (index, char) in reversed.enumerated() {
        
        if char == "+" ||  char == "-" ||  char == "*" ||  char == "/" ||  char == "%"{
            
            print(char)
            returnval = "\(char)"
            break
        }else{
            returnval = ""
        }
    }*/
    
    
    
    var value1 = 0
    for (index, char) in reversed.enumerated() {
        
        
        if char == "0" ||  char == "1" ||  char == "2" ||  char == "3" ||  char == "4" ||  char == "5" ||  char == "6" ||  char == "7" ||  char == "8" ||  char == "9" ||  char == "."{
            
            if value1 > 0 {
                value1 = 0
                break
            }
            
            
        }else {//Check operator
            
            print(char)
            returnval = "\(char)"
            if value1 == 1 {
                returnval = "\(char)"
                break
            }
            
            value1 = value1 + 1
            /*}else{
             returnval = ""
             }*/
        }
    }
    
    
    
    return returnval
}

/*
 // String literal
 let s = "Hello World"
 
 // Reverse its characters
 
 let reversed = String(s.characters.reverse())
 print(reversed)
 
*/
func AddPluseMinuse (_ experationStr :String , lastOperator:String) -> String{
    
    if experationStr.count == 0 {
        return experationStr
    }
    
    
    //Check ALL 0
    let zeoStr = experationStr
    let testNumber = zeoStr.replacingOccurrences(of: "0", with: "")
    if testNumber.count == 0 {
        return experationStr
    }
    
    
    
    //Non Zero case
    let lastOperatorN = getLastOperator(experationStr)
    
    if lastOperatorN != "" {
        
        var resultArr = experationStr.components(separatedBy: lastOperatorN)
        guard let expStr = resultArr.last else{   return experationStr }
        var Str = ""
        if experationStr.contains(expStr){
            
            if resultArr.count >= 2{
                
                if resultArr[resultArr.count - 2] == ""{
                  //return  experationStr.replacingOccurrences(of: "--", with: "-")
                    Str = expStr
                    resultArr.remove(at: resultArr.count - 2)
                
                }else{
                    if expStr.contains("-"){
                        Str = expStr.replacingOccurrences(of: "-", with: "")
                    }else{
                        Str = expStr.replacingOccurrences(of: expStr, with: "-\(expStr)")
                    }
                }
                
                
                
            }else{
                
                if expStr.contains("-"){
                    Str = expStr.replacingOccurrences(of: "-", with: "")
                }else{
                    Str = expStr.replacingOccurrences(of: expStr, with: "-\(expStr)")
                }
            }
        }else{
            Str = expStr
        }
        
        resultArr.removeLast()
        resultArr.append(Str)
        let stringRepresentation = resultArr.joined(separator: lastOperatorN)
        return stringRepresentation
        
        
    }else{
        
        
        
        if experationStr.contains("-"){
           return experationStr.replacingOccurrences(of: "-", with: "")
        }else{
            let str = experationStr.replacingOccurrences(of: experationStr, with: "-\(experationStr)")
            return str
        }
        
    }
    
}




