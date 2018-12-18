//
//  ContinueVC.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 13/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import UIKit

class ContinueVC: UIViewController {

    
    
    let gradientLayer = CAGradientLayer()
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var backView: UIView!
    
    
    @IBOutlet weak var imgView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
       
        /*gradientLayer.frame = self.backView.bounds
        let color1 = UIColor.hexStringToUIColor(hex: topOrangegradiant).cgColor as CGColor
        let color2 = UIColor.hexStringToUIColor(hex: bottomPinkgradiant).cgColor as CGColor
        gradientLayer.colors = [ color1, color2]
        gradientLayer.locations = [0.0, 0.90]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        backView.backgroundColor = .clear
        self.backView.layer.insertSublayer(gradientLayer, at: 0)*/
        
       // backImageView.image = UIImage(named: "splash")
        imgView.image = UIImage(named: "splash")
        imgView.layer.masksToBounds = true
        
        
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal("We designed ",centerAlignSts: true)
            .bold("KiddieCal ",centerAlignSts: true)
            .normal("especially for children in the 6-12 age group as a part of our Early Learning Series. \n\n",centerAlignSts: true)
        
            .normal("Little ones use ",centerAlignSts: true)
            .bold("voice ",centerAlignSts: true)
            .normal("to calculate, or learn the sound associated with each digit as it’s pressed. It’s a fun way to make numbers their best friends for life!",centerAlignSts: false)
        
        txtView.attributedText =  formattedString
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    
    //removing back text
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(true)
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationController?.isNavigationBarHidden = false
        }
    
    @IBAction func continueClick(_ sender: Any) {
        KidsCalciUserDefaults.setContinue()
        guard let navViewController = TellUsMoreVC.getStoryboardInstance(),
            let  viewController = navViewController.topViewController as? TellUsMoreVC
            else { return  }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
   

}


extension ContinueVC{
    static func getStoryboardInstance() -> UINavigationController?{
        let storyborad = UIStoryboard(name: String(describing: self), bundle: nil)
        guard let navViewController = storyborad.instantiateInitialViewController()  as? UINavigationController else { return nil }
        return navViewController
    }
}

extension ContinueVC:UITextViewDelegate {

}


