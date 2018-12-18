//
//  UILabel+AutoResize.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 10/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import Foundation
import UIKit


extension UILabel {
    
    func retrieveTextHeight () -> CGFloat {
        let attributedText = NSAttributedString(string: self.text!, attributes: [NSAttributedStringKey.font:self.font])
       
        let rect = attributedText.boundingRect(with: CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(rect.size.height)
    }
    
    
    var defaultFont: UIFont? {
        get { return self.font }
        set {
            /* When ViewController still in navigation stack
             and appear each time, the font label will decrease
             till will disappear, so we need to call dp just one
             time for each label .*/
            if self.tag == 0 {  // self.tag = 0 is default value .
                self.tag = 1
                let newFontSize = self.font.pointSize.dp // we get old font size and adaptive it with multiply it with dp.
                let oldFontName = self.font.fontName
                self.font = UIFont(name: oldFontName, size: newFontSize) // and set new font here .
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    //Resizing bases of iphone size
    open override func awakeFromNib() {
        super.awakeFromNib()
        if let font = self.font {
            let deviceType = UIDevice.DeviceType.self
            var screenRatio = UIScreen.main.bounds.size.width / 320.0
            if deviceType.IS_IPAD{
                screenRatio = UIScreen.main.bounds.size.width / 620.0
            }
            let fontSize = font.pointSize * screenRatio
            self.font = UIFont(name: font.fontName, size: fontSize)!
           // self.minimumScaleFactor = 0.3
        }
    }
    
}
