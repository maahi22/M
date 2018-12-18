//
//  CAGradientLayer+Bond.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 03/09/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import Foundation
import UIKit

extension CAGradientLayer {
    class func gradientLayerForBounds(bounds: CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = bounds
        
        let color1 = UIColor.black.cgColor as CGColor
        let color2 = UIColor.clear.cgColor as CGColor
        layer.colors = [ color1, color2]
        layer.startPoint = CGPoint(x: 1, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        layer.opacity = 0.2
        //layer.colors = [ color1, color2]//[UIColor.black.withAlphaComponent(0.7).cgColor,UIColor.black.withAlphaComponent(0.5).cgColor,UIColor.black.withAlphaComponent(0.01).cgColor]
        return layer
    }
}
