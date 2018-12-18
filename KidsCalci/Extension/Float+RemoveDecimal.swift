//
//  Float+RemoveDecimal.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 06/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import Foundation
import UIKit



//extension Float {
//    var cleanValue: String {
//        return self % 1 == 0 ? String(format: "%.0f", self) : String(self)
//    }
//}

extension Float{
    var cleanValue: String{
        //return String(format: 1 == floor(self) ? "%.0f" : "%.2f", self)
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.8f", self)//
    }
}



extension CGFloat{
    var cleanValue: String{
        //return String(format: 1 == floor(self) ? "%.0f" : "%.2f", self)
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.8f", self)//
    }
    
    var shortValue: String {
        return String(format: "%g", self)
    }
    
    
    
}
