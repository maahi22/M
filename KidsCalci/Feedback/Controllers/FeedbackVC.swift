//
//  FeedbackVC.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 07/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import UIKit

class FeedbackVC: UIViewController {

    @IBOutlet weak var lblHowdoyouLike: UILabel!
    @IBOutlet var feedbackClient:FeedbackClient!
    @IBOutlet weak var backImageView: UIImageView!
    
    @IBOutlet weak var lblLine1: UILabel!
    @IBOutlet weak var lblLine2: UILabel!
    @IBOutlet weak var lblLine3: UILabel!
    
    @IBOutlet weak var lblLine1HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblLine2HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblLine3HeightConstraint: NSLayoutConstraint!
    
    
    let gradientLayer = CAGradientLayer()
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblLine1.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        lblLine2.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        lblLine3.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        lblLine1HeightConstraint.constant = 0.5
        lblLine2HeightConstraint.constant = 0.5
        lblLine3HeightConstraint.constant = 0.5
        
        
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
        
        
        self.navigationController?.navigationBar.transparentNavigationBar()
       

        
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func clickLoveIt(_ sender: Any) {
        showLoadingHUD()
        feedbackClient.sendFeedback("love_it", betterment: "Love it") { [weak self] (status, message) in
            guard let strongSelf = self else{return}
            strongSelf.dismissLoadingHUD()
            
            
            let action = UIAlertAction(title: AlertBtnOk, style: .default, handler: nil)
            showAlertMessage(vc: strongSelf, title: "", message: message, actionTitle: AlertBtnOk, handler: { (action) in
                
                  strongSelf.dismiss(animated: true, completion: nil)
                
            })
            
            //showAlertMessage(vc: strongSelf, title: .Message, message: message)
        }
    }
    
    @IBAction func clickItsOk(_ sender: Any) {
        guard let navViewController = SorryVC.getStoryboardInstance(),
            let viewController = navViewController.topViewController as? SorryVC
            else { return  }
        viewController.sorryTag = "its_okay"
        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func clickNeedWork(_ sender: Any) {
        guard let navViewController = SorryVC.getStoryboardInstance(),
            let viewController = navViewController.topViewController as? SorryVC
            else { return  }
        viewController.sorryTag = "needs_work"
        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    
    }
    
    
    @IBAction func dissmissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension FeedbackVC{
    static func getStoryboardInstance() -> UINavigationController?{
        let storyborad = UIStoryboard(name: String(describing: self), bundle: nil)
        guard let navViewController = storyborad.instantiateInitialViewController()  as? UINavigationController else { return nil }
        return navViewController
    }
}

extension FeedbackVC:SorryVCDelegate {
    func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    
}
