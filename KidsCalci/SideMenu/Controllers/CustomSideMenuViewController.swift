//
//  CustomSideMenuViewController.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 07/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import UIKit
import SideMenuController


class CustomSideMenuViewController: SideMenuController {

    
    let gradientLayer = CAGradientLayer()
    
    required init?(coder aDecoder: NSCoder) {
        SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: "menu")
        SideMenuController.preferences.drawing.sidePanelPosition = .overCenterPanelLeft
        SideMenuController.preferences.drawing.sidePanelWidth = 280
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .showUnderlay
        super.init(coder: aDecoder)
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //Load gradient
        gradientLayer.frame = self.view.bounds
        let color1 = UIColor.hexStringToUIColor(hex: topOrangegradiant).cgColor as CGColor
        let color2 = UIColor.hexStringToUIColor(hex: bottomPinkgradiant).cgColor as CGColor
        gradientLayer.colors = [ color1, color2]
        gradientLayer.locations = [0.0, 0.90]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
         self.view.layer.insertSublayer(gradientLayer, at: 0)
        //End
        
        call()
        
    }

    
    
    func call()  {
        performSegue(withIdentifier: SideMenuOptions.showHome.rawValue, sender: nil)
        performSegue(withIdentifier: SideMenuOptions.containSideMenu.rawValue, sender: nil)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showHome" {
            guard let navViewController = ViewController.getStoryboardInstance(),
                let viewController = navViewController.topViewController as? ViewController
                else { return  }
            viewController.loadTheme()
            print("containSideMenu")
        }
        
    }
    
    
    func sideMenuControllerDidHide(_ sideMenuController: SideMenuController){
        print("sideMenuControllerDidHide")
    }
    func sideMenuControllerDidReveal(_ sideMenuController: SideMenuController){
        print("sideMenuControllerDidReveal")
    }
    
    
}
