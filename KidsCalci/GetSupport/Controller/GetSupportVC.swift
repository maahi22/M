//
//  GetSupportVC.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 07/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import UIKit

class GetSupportVC: UIViewController {

    @IBOutlet var getSupportClient:GetSupportClient!
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var lblLine1: UILabel!
    @IBOutlet weak var lblLine2: UILabel!
    @IBOutlet weak var lblLine3: UILabel!
    @IBOutlet weak var lblLine1HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblLine2HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblLine3HeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var middleMultiplier: NSLayoutConstraint!
    @IBOutlet weak var constraintNameTop: NSLayoutConstraint!
    @IBOutlet weak var constraintEmailTop: NSLayoutConstraint!
    @IBOutlet weak var constraintDescTop: NSLayoutConstraint!
    @IBOutlet weak var constraintGetTop: NSLayoutConstraint!
    
    let gradientLayer = CAGradientLayer()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblLine1.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        lblLine2.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        lblLine3.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        lblLine1HeightConstraint.constant = 0.5
        lblLine2HeightConstraint.constant = 0.5
        lblLine3HeightConstraint.constant = 0.5
        
        //Load gradient
        gradientLayer.frame = self.view.bounds
        let color1 = UIColor.hexStringToUIColor(hex: topOrangegradiant).cgColor as CGColor
        let color2 = UIColor.hexStringToUIColor(hex: bottomPinkgradiant).cgColor as CGColor
        gradientLayer.colors = [ color1, color2]
        gradientLayer.locations = [0.0, 0.90]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        backImageView.backgroundColor = .clear
        self.backImageView.layer.insertSublayer(gradientLayer, at: 0)
        //End
       
        txtName.updatePlaceholderColor()
        txtEmail.updatePlaceholderColor()
        txtDescription.setPlaceholder(getSupportDescPlaceholder)
        
        self.navigationController?.navigationBar.transparentNavigationBar()
    
        let deviceType = UIDevice.DeviceType.self
        
        if deviceType.IS_IPHONE_4_OR_LESS{
            DispatchQueue.main.async { [weak self] in
                guard let strongself = self else { return }
               // let newMultiplier:CGFloat = 1.9
               
              //  strongself.middleMultiplier = strongself.middleMultiplier.setMultiplier( newMultiplier)
                strongself.constraintNameTop.constant = 45.0
                strongself.constraintEmailTop.constant = 5.0
                strongself.constraintDescTop.constant = 25.0
                strongself.constraintGetTop.constant = 2.0
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func backClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    
    @IBAction func submitInformation(_ sender: Any) {
   
        guard  let name = txtName.text,
            let emailId = txtEmail.text,
            let issue = txtDescription.text else {
        
                showAlertMessage(vc: self, title: .none, message: fillAllField)
                return
        }
        
        
        if name.isEmptyOrWhitespace(){
            showAlertMessage(vc: self, title: .none, message: "Please enter name")
            return
        }
        
        if emailId.isEmptyOrWhitespace(){
            showAlertMessage(vc: self, title: .none, message: "Please enter Email")
            return
        }
        
        if issue.isEmptyOrWhitespace(){
            showAlertMessage(vc: self, title: .none, message: "Please describe your issue")
            return
        }
        
        
        if !emailId.isValidEmail() {
            showAlertMessage(vc: self, title: .none, message: alertValidEmail)
            return
        }
        
      
        
        
        showLoadingHUD()
        getSupportClient.sendSupportQuery(issue, name: name, email: emailId) { [weak self]  (isSuccess, message) in
            guard let strongSelf = self else{return}
            strongSelf.dismissLoadingHUD()
            
            if isSuccess {
                strongSelf.txtName.text = ""
                strongSelf.txtEmail.text = ""
                strongSelf.txtDescription.text = ""
                strongSelf.txtDescription.checkPlaceholder()
                
            }else{
                
            }
            
            
            let action = UIAlertAction(title: AlertBtnOk, style: .default, handler: nil)
            showAlertMessage(vc: strongSelf, title: "", message: message, actionTitle: AlertBtnOk, handler: { (action) in
                strongSelf.dismiss(animated: true, completion: nil)
            })
            
        }
        
    }
    

    @IBAction func dissmissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension GetSupportVC{
    
    static func getStoryboardInstance() -> UINavigationController?{
        let storyborad = UIStoryboard(name: String(describing: self), bundle: nil)
        guard let navViewController = storyborad.instantiateInitialViewController()  as? UINavigationController else { return nil }
        return navViewController
    }
}


extension GetSupportVC:UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        textView.checkPlaceholder()
        
    }
    
    
}
