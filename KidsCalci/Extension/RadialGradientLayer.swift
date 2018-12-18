//
//  RadialGradientLayer.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 24/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import UIKit

class RadialGradientLayer: CALayer {

    required override init() {
        super.init()
        needsDisplayOnBoundsChange = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required override init(layer: Any) {
        super.init(layer: layer)
    }
    
    
    
    public var colors = [UIColor.hexStringToUIColor(hex: radialWhiteGradient).cgColor, UIColor.hexStringToUIColor(hex: radialGrayGradient).cgColor]
    
    override func draw(in ctx: CGContext) {
        ctx.saveGState()
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var locations = [CGFloat]()
        for i in 0...colors.count-1 {
            locations.append(CGFloat(i) / CGFloat(colors.count))
        }
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)
        let center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
        let radius = max(bounds.width+100 , bounds.height+100 )
        ctx.drawRadialGradient(gradient!, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: radius, options: CGGradientDrawingOptions(rawValue: 0))
    }
    
}
