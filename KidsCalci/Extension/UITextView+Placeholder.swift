//
//  UITextView+Placeholder.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 08/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import Foundation
import UIKit


extension UITextView{
    
    func setPlaceholder() {
        
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Enter Description"
        placeholderLabel.font = UIFont.systemFont(ofSize: (self.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        placeholderLabel.tag = 222
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (self.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        placeholderLabel.isHidden = !self.text.isEmpty
        
        self.addSubview(placeholderLabel)
    }
    
    func setPlaceholder(_ placeholderString :String) {
        
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholderString
        placeholderLabel.font = UIFont.systemFont(ofSize: (self.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        placeholderLabel.tag = 222
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (self.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        placeholderLabel.isHidden = !self.text.isEmpty
        
        self.addSubview(placeholderLabel)
    }
    
    
    func checkPlaceholder() {
        let placeholderLabel = self.viewWithTag(222) as! UILabel
        placeholderLabel.isHidden = !self.text.isEmpty
    }
    
    
//    func setFirstLetterBold() {
//        if (text?.count)! > 0 {
//            let attText = NSMutableAttributedString(string: String(text!.characters.first!) + String(text!.characters.dropFirst()))
//            attText.setAttributes([NSFontAttributeName:UIFont.boldSystemFontOfSize(font.pointSize)], range: NSRange(location: 0, length: 1))
//            attributedText = attText
//        }
//    }
    
}
