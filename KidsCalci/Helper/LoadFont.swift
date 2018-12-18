//
//  LoadFont.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 06/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import Foundation
import UIKit





/*func loadFont(fontName: String, baseFolderPath: String) -> Bool {
    let basePath = baseFolderPath as NSString
    let fontFilePath = basePath.appendingPathComponent(fontName)
    let fontUrl = NSURL(fileURLWithPath: fontFilePath)
    //if let inData = NSData(contentsOfURL: fontUrl as URL) {
       
    let data = NSData(contentsOf: fontUrl as URL) as Data? // <==== Added 'as Data?'
        if let data = data {
        
        var error: Unmanaged<CFError>?
        let cfdata = CFDataCreate(nil, UnsafePointer<UInt8>(data.bytes), data.length)
        if let provider = CGDataProviderCreateWithCFData(cfdata) {
            if let font = CGFontCreateWithDataProvider(provider) {
                if (!CTFontManagerRegisterGraphicsFont(font, &error)) {
                   
                    print("Failed to load font: \(error)")
                    //Logger.info("Failed to load font: \(error)")
                }
                return true
            }
        }
    }
    return false
}*/
