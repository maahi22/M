//
//  String+Expression.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 03/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import Foundation


extension String {
    
    
    
    func isEmptyOrWhitespace() -> Bool {
        
        if(self.isEmpty) {
            return true
        }
        
        return (self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "")
        
        
        //trim//stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "")
    }
    
    
    
        var htmlToAttributedString: NSAttributedString? {
            guard let data = data(using: .utf8) else { return NSAttributedString() }
            do {
                return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
            } catch {
                return NSAttributedString()
            }
        }
        var htmlToString: String {
            return htmlToAttributedString?.string ?? ""
        }
    
    var isNumeric: Bool {
        guard self.characters.count > 0 else { return false }
        let nums: Set<Character> = [ "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self.characters).isSubset(of: nums)
    }
    
    func fileName() -> String {
        return NSURL(fileURLWithPath: self).deletingPathExtension?.lastPathComponent ?? ""
    }
    
    func fileExtension() -> String {
        return NSURL(fileURLWithPath: self).pathExtension ?? ""
    }
    
    private func allNumsToDouble() -> String {
        
        let symbolsCharSet = ".,"
        let fullCharSet = "0123456789" + symbolsCharSet
        var i = 0
        var result = ""
        var chars = Array(self)
        while i < chars.count {
            if fullCharSet.contains(chars[i]) {
                var numString = String(chars[i])
                i += 1
                loop: while i < chars.count {
                    if fullCharSet.contains(chars[i]) {
                        numString += String(chars[i])
                        i += 1
                    } else {
                        break loop
                    }
                }
                if let num = Double(numString) {
                    result += "\(num)"
                } else {
                    result += numString
                }
            } else {
                result += String(chars[i])
                i += 1
            }
        }
        return result
    }
    
    func calculate() -> Double? {
        let transformedString = allNumsToDouble()
        let expr = NSExpression(format: transformedString)
        return expr.expressionValue(with: nil, context: nil) as? Double
    }
    
    
    
    
    
    func substring(from:Int, toSubstring s2 : String) -> Substring? {
        guard let r = self.range(of:s2) else {return nil}
        var s = self.prefix(upTo:r.lowerBound)
        s = s.dropFirst(from)
        return s
    }
    
    func indicesOf(string: String) -> [Int] {
        var indices = [Int]()
        var searchStartIndex = self.startIndex
        
        while searchStartIndex < self.endIndex,
            let range = self.range(of: string, range: searchStartIndex..<self.endIndex),
            !range.isEmpty
        {
            let index = distance(from: self.startIndex, to: range.lowerBound)
            indices.append(index)
            searchStartIndex = range.upperBound
        }
        
        return indices
    }
}
