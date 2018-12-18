//
//  Section.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 07/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import Foundation


enum MenuItemType{
    case feedback
    case getSupport
    case none
    
}
struct Section {
    
    let name:String
    let items:[String]
    let image:String
    let selImage:String
    let expanded:Bool
    let itemType:MenuItemType
    
}
