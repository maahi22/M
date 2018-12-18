//
//  UIButton+FontSize.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 21/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        if let font = self.titleLabel?.font {
            let screenRatio = UIScreen.main.bounds.size.width / 320.0
            let fontSize = font.pointSize * screenRatio
            self.titleLabel?.font = UIFont(name: font.fontName, size: fontSize)!
        }
        
    }
}
