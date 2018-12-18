//
//  UINavigationBar+transparentBar.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 07/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import Foundation
import UIKit


extension UINavigationBar {
    
    func transparentNavigationBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
    
    func transparentNavigationBar2() {
        
        
        if let navHeight:CGFloat = self.frame.height {
            self.frame = CGRect(x:0, y:0, width:SCREEN_SIZE.width, height:navHeight  + 20)
        }else{ // 20 for status bar height
            self.frame = CGRect(x:0, y:0, width:SCREEN_SIZE.width, height:64)
        }
        
        if let img = UIImage(named: "gradientNavigationImg"){
            self.setBackgroundImage(img, for: .default)
        }else{
            self.setBackgroundImage(UIImage(), for: .default)
        }
        
       // self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
        
       
    }
    
    func transparentNavigationBar3() {//iPhoneX
        
        if let navHeight:CGFloat = self.frame.height {
            self.frame = CGRect(x:0, y:0, width:SCREEN_SIZE.width, height:navHeight  + 20)
        }else{ // 20 for status bar height
            self.frame = CGRect(x:0, y:0, width:SCREEN_SIZE.width, height:64)
        }
        
        if let img = UIImage(named: "gradientNavigationImgiPhoneX"){
            self.setBackgroundImage(img, for: .default)
        }else{
            self.setBackgroundImage(UIImage(), for: .default)
        }
        
        // self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
        
        
    }
}
