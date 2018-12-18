//
//  TellUsMoreVC.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 13/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import UIKit

class TellUsMoreVC: UIViewController {

    @IBOutlet var tellUsMoreClient:TellUsMoreClient!
    let gradientLayer = CAGradientLayer()
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    
    
    @IBOutlet weak var lblLine1: UILabel!
    @IBOutlet weak var lblLine2: UILabel!
    @IBOutlet weak var lblLine1HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblLine2HeightConstraint: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        gradientLayer.frame = self.view.bounds
        let color1 = UIColor.hexStringToUIColor(hex: topOrangegradiant).cgColor as CGColor
        let color2 = UIColor.hexStringToUIColor(hex: bottomPinkgradiant).cgColor as CGColor
        gradientLayer.colors = [ color1, color2]
        gradientLayer.locations = [0.0, 0.90]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        // self.topBackgroundView.layer.insertSublayer(gradientLayer, at: 0)
        backImageView.backgroundColor = .clear
        self.backImageView.layer.insertSublayer(gradientLayer, at: 0)
        //End
        lblLine1.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        lblLine2.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        lblLine1HeightConstraint.constant = 0.5
        lblLine2HeightConstraint.constant = 0.5
        
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        
        txtName.updatePlaceholderColor()
        txtAge.updatePlaceholderColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.transparentNavigationBar()
        self.navigationController?.navigationBar.backgroundColor = .clear
        //self.navigationController?.isNavigationBarHidden = true
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    
    
    @IBAction func submitClick(_ sender: Any) {
  
        guard
            let name = txtName.text,
            let age = txtAge.text else {
                
                showAlertMessage(vc: self, title: .none, message: fillAllField)
                return
        }
        
        if name.isEmptyOrWhitespace(){
            showAlertMessage(vc: self, title: .none, message: "Please enter name")
            return
        }
        
        if age.isEmptyOrWhitespace(){
            showAlertMessage(vc: self, title: .none, message: "Please enter age")
            return
        }
        
        if age == "0" || age == "00" {
            showAlertMessage(vc: self, title: .none, message: "Please enter a valid  age")
            return
        }
        
        
        showLoadingHUD()
        tellUsMoreClient.sendUserInfo(name, age: age) { [weak self]  (isSuccess, message) in
            guard let strongSelf = self else{return}
            strongSelf.dismissLoadingHUD()
            
            if isSuccess {
                KidsCalciUserDefaults.setTellUsMore()
                strongSelf.loadMainViews()
            }else{
                showAlertMessage(vc: strongSelf, title: .Message, message: message)
                
            }
            
        }
        
    }
    
    
    
    @IBAction func skipClick(_ sender: Any) {
        
//        if  !KidsCalciUserDefaults.getTellUsMore(){
//            KidsCalciUserDefaults.setHowManyTimeOpenApp()
//        }
        
        loadMainViews()
    }
    
    
    func loadMainViews()  {
        guard let mainView = UIStoryboard(name: Screens.SideMenu.rawValue, bundle: nil).instantiateInitialViewController() as? CustomSideMenuViewController
            else{
                return
        }
        self.present(mainView, animated: true, completion: nil)
    }
    

}


extension TellUsMoreVC{
    static func getStoryboardInstance() -> UINavigationController?{
        let storyborad = UIStoryboard(name: String(describing: self), bundle: nil)
        guard let navViewController = storyborad.instantiateInitialViewController()  as? UINavigationController else { return nil }
        return navViewController
    }
}

extension TellUsMoreVC: UITextFieldDelegate {
   
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let charsLimit = 2
        
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
       
        
        let startingLength = textField.text?.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace =  range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace
        
        if newLength <= charsLimit{
            return string == numberFiltered
        }else{
            return false
        }
        
        
    }
    
    
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//
//
//
//
//        return newLength <= charsLimit
//    }
}


