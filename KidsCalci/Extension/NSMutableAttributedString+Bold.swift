//
//  NSMutableAttributedString+Bold.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 12/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
   
    @discardableResult func bold(_ text: String, centerAlignSts:Bool) -> NSMutableAttributedString {
       
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 3.5
        if centerAlignSts {
            style.alignment = .center
        }
        let size = returnDynamicFont(12.0)
        
        if let barlowBold = UIFont(name: "Barlow-Bold", size: size) {
            let attrs = [NSAttributedStringKey.font:  barlowBold, NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.paragraphStyle : style]
            let boldString = NSMutableAttributedString(string:text, attributes: attrs)
            append(boldString)
        }else{
            let attrs = [NSAttributedStringKey.font:  UIFont.boldSystemFont(ofSize: size), NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.paragraphStyle : style]
            let normal = NSAttributedString(string: text, attributes: attrs)
            append(normal)
        }
        
        
        
        return self
    }
    
    @discardableResult func normal(_ text: String, centerAlignSts:Bool) -> NSMutableAttributedString {
       
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 3.5
        if centerAlignSts {
            style.alignment = .center
        }
        let size = returnDynamicFont(12.0)
        
        
        if let barlowBold = UIFont(name: "Barlow-Regular", size: size) {
            let attrs = [NSAttributedStringKey.font:  barlowBold, NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.paragraphStyle : style]
            let boldString = NSMutableAttributedString(string:text, attributes: attrs)
            append(boldString)
        }else{
            let attrs = [NSAttributedStringKey.font:  UIFont.systemFont(ofSize: size), NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.paragraphStyle : style]
            let normal = NSAttributedString(string: text, attributes: attrs)
            append(normal)
        }
        return self
    }
    
    
    
    
    
    
}
