//
//  SorryVC.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 07/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import UIKit


protocol SorryVCDelegate:class {
    func dismissView()
}

class SorryVC: UIViewController {

    weak var delegate:SorryVCDelegate?
    @IBOutlet var feedbackClient:FeedbackClient!
    @IBOutlet weak var txtViewInfo: UITextView!
    @IBOutlet weak var backImageView: UIImageView!
    let gradientLayer = CAGradientLayer()
    var sorryTag = ""
    
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblLine1: UILabel!
    @IBOutlet weak var lblLine1HeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var constraintSubTitleBottom: NSLayoutConstraint!
    
    
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
        backImageView.backgroundColor = .clear
        self.backImageView.layer.insertSublayer(gradientLayer, at: 0)
        //End
        
         lblLine1.backgroundColor = UIColor.white.withAlphaComponent(0.5)
         lblLine1HeightConstraint.constant = 0.5
        
        self.navigationController?.navigationBar.transparentNavigationBar()
        txtViewInfo.translatesAutoresizingMaskIntoConstraints = true
        txtViewInfo.setPlaceholder()
        //txtViewInfo.becomeFirstResponder()
        
        let imgBackArrow = UIImage(named: "backArrow")
        navigationController?.navigationBar.backIndicatorImage = imgBackArrow
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBackArrow
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        let deviceType = UIDevice.DeviceType.self
        if deviceType.IS_IPHONE_X{
            constraintSubTitleBottom.constant = 35.0
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    
    @IBAction func backClick(_ sender: Any) {
        if let navController = self.navigationController {
           // self.delegate?.dismissView()
            navController.popViewController(animated: true)
        }
    }
    
    
    @IBAction func submitFeedback(_ sender: Any) {
    
        guard
            let feedback = txtViewInfo.text, !feedback.isEmpty else {
                showAlertMessage(vc: self, title: .none, message: AlertInsertDesc)
                return
        }
        
        if feedback.isEmptyOrWhitespace(){
            showAlertMessage(vc: self, title: .none, message: "Insert proper Text")
            return
        }
        
        
        
        
        
        showLoadingHUD()
        feedbackClient.sendFeedback(sorryTag, betterment: feedback) { [weak self]  (isSuccess, message) in
            
            guard let strongSelf = self else{return}
            strongSelf.dismissLoadingHUD()
            if isSuccess {
                strongSelf.txtViewInfo.text = ""
            }else{
                
            }
            
           // showAlertMessage(vc: strongSelf, title: .Message, message: message)
            let action = UIAlertAction(title: AlertBtnOk, style: .default, handler: nil)
            showAlertMessage(vc: strongSelf, title: "", message: message, actionTitle: AlertBtnOk, handler: { (action) in
                
                if let navController = strongSelf.navigationController {
                    strongSelf.delegate?.dismissView()
                    navController.popViewController(animated: true)
                    
                }
                
            })
        }
    
    }
    
    
    
    
    
//https://stackoverflow.com/questions/38714272/how-to-make-uitextview-height-dynamic-according-to-text-length
}


extension SorryVC{
    static func getStoryboardInstance() -> UINavigationController?{
        let storyborad = UIStoryboard(name: String(describing: self), bundle: nil)
        guard let navViewController = storyborad.instantiateInitialViewController()  as? UINavigationController else { return nil }
        return navViewController
    }
}

extension SorryVC:UITextViewDelegate {
    
    /*func textViewDidChange(_ textView: UITextView) {
        let sizeToFitIn = CGSize(width: self.txtViewInfo.bounds.size.width, height: CGFloat(MAXFLOAT)) //CGSize(self.txtViewInfo.bounds.size.width, CGFloat(MAXFLOAT))
        let newSize = self.txtViewInfo.sizeThatFits(sizeToFitIn)
        self.textViewHeight.constant = newSize.height
    }*/

    func textViewDidBeginEditing(_ textView: UITextView) {
       // let fixedWidth = textView.frame.size.width
       // textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        textView.checkPlaceholder()
        
        
        
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame
    }
    
    
}
