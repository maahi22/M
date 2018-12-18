//
//  UIDevice+ScreenSize.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 20/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    //Iphone size
    enum UIUserInterfaceIdiom : Int
    {
        case Unspecified
        case Phone
        case Pad
    }
    
    
    struct ScreenSize
    {
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    
    struct DeviceType
    {
        static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 480.0
        static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        static let IS_IPHONE_X         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
        static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    }
    
    
    /*
     enum DeviceType: String {
     case iPhone4_4S = "iPhone 4 or iPhone 4S"
     case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
     case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
     case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
     case iPhoneX = "iPhone X"
     case unknown = "iPadOrUnknown"
     }
     
     var deviceType: DeviceType {
     switch UIScreen.main.nativeBounds.height {
     case 960:
     return .iPhone4_4S
     case 1136:
     return .iPhones_5_5s_5c_SE
     case 1334:
     return .iPhones_6_6s_7_8
     case 1920, 2208:
     return .iPhones_6Plus_6sPlus_7Plus_8Plus
     case 2436:
     return .iPhoneX
     default:
     return .unknown
     }
     }
     }
     
     
     // Get device type (with help of above extension) and assign font size accordingly.
     let label = UILabel()
     
     let deviceType = UIDevice.current.deviceType
     
     switch deviceType {
     
     case .iPhone4_4S:
     label.font = UIFont.systemFont(ofSize: 10)
     
     case .iPhones_5_5s_5c_SE:
     label.font = UIFont.systemFont(ofSize: 12)
     
     case .iPhones_6_6s_7_8:
     label.font = UIFont.systemFont(ofSize: 14)
     
     case .iPhones_6Plus_6sPlus_7Plus_8Plus:
     label.font = UIFont.systemFont(ofSize: 16)
     
     case .iPhoneX:
     label.font = UIFont.systemFont(ofSize: 18)
     
     default:
     print("iPad or Unkown device")
     label.font = UIFont.systemFont(ofSize: 20)
     
 */
    
    
}
