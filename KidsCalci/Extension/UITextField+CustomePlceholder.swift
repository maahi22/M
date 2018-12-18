//
//  UITextField+CustomePlceholder.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 11/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import Foundation
import UIKit

extension UITextField{

    func updatePlaceholderColor() {
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
    }

}
