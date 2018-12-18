//
//  ELSeriesVC.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 07/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import UIKit



class ELSeriesVC: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var txtAppDescription: UITextView!
    @IBOutlet weak var appListCollectionView: UICollectionView!
    @IBOutlet weak var backImageView: UIImageView!
    let gradientLayer = CAGradientLayer()
    
    @IBOutlet weak var backLeadingConstraint: NSLayoutConstraint!
    
    var menuItems :[AppModel] = [AppModel]()
    
    //Constraint change
    @IBOutlet weak var descTxtproportionWithConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblEarlyproportionWidth: NSLayoutConstraint!
    @IBOutlet weak var appDescTxtproportionWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var collViewproportionWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var constraintLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintTitleTop: NSLayoutConstraint!
    @IBOutlet weak var constraintAppDescTop: NSLayoutConstraint!
    @IBOutlet weak var constraintCollHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintCollTop: NSLayoutConstraint!
    @IBOutlet weak var constraintCollbuttom: NSLayoutConstraint!
    
    
    
    
    
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        txtDescription.setContentOffset(CGPoint.zero, animated: false)
//    }

   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let navController = navigationController!
        let image = UIImage(named: "ic_evantiv_logo")
        let imageView = UIImageView(image: image)
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        let bannerX = bannerWidth / 2 - (image?.size.width)! / 2
        let bannerY = bannerHeight / 2 - (image?.size.height)! / 2
      
        
        let deviceType = UIDevice.DeviceType.self
        
        self.txtDescription.scrollRangeToVisible(NSMakeRange(0, 0))
        //txtDescription.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        self.automaticallyAdjustsScrollViewInsets = false

        
         if deviceType.IS_IPHONE_4_OR_LESS{
            DispatchQueue.main.async { [weak self] in
                guard let strongself = self else { return }
                
                strongself.constraintTitleTop.constant = 3.0
                strongself.constraintAppDescTop.constant = 0.0
                strongself.constraintCollTop.constant = 0.0
                strongself.constraintCollbuttom.constant = 0.0
                strongself.constraintLabelHeight.constant = 19.0
                strongself.backLeadingConstraint.constant = 5.0
                
                let newMult:CGFloat = 0.55
                strongself.constraintCollHeight = strongself.constraintCollHeight.setMultiplier( newMult)
                let newMultiplier:CGFloat = 0.93
                strongself.descTxtproportionWithConstraint = strongself.descTxtproportionWithConstraint.setMultiplier( newMultiplier)
                let newMultiplier2:CGFloat = 0.89
                strongself.lblEarlyproportionWidth = strongself.lblEarlyproportionWidth.setMultiplier( newMultiplier2)
                strongself.appDescTxtproportionWidthConstraint = strongself.appDescTxtproportionWidthConstraint.setMultiplier( newMultiplier)
                let newMultiplier3:CGFloat = 0.80
                strongself.collViewproportionWidthConstraint = strongself.collViewproportionWidthConstraint.setMultiplier( newMultiplier3)
                
                strongself.view.layoutIfNeeded()
            }
        
        }else if deviceType.IS_IPHONE_5{
            DispatchQueue.main.async { [weak self] in
                
                guard let strongself = self else { return }
                let newMultiplier:CGFloat = 0.93
                strongself.descTxtproportionWithConstraint = strongself.descTxtproportionWithConstraint.setMultiplier( newMultiplier)
                let newMultiplier2:CGFloat = 0.89
                strongself.lblEarlyproportionWidth = strongself.lblEarlyproportionWidth.setMultiplier( newMultiplier2)
                strongself.appDescTxtproportionWidthConstraint = strongself.appDescTxtproportionWidthConstraint.setMultiplier( newMultiplier)
                let newMultiplier3:CGFloat = 0.80
                strongself.collViewproportionWidthConstraint = strongself.collViewproportionWidthConstraint.setMultiplier( newMultiplier3)
                strongself.backLeadingConstraint.constant = 5.0
                strongself.view.layoutIfNeeded()
            }
        }
        
       
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
        
        loadText()
        
        self.navigationController?.navigationBar.transparentNavigationBar()
        appListCollectionView.register(AppCollCell.nib, forCellWithReuseIdentifier: AppCollCell.identifier)
    }

    
    func loadText()  {
        
        let formattedString = NSMutableAttributedString()
        formattedString
            .bold("evantiv ",centerAlignSts: false)
            .normal("Early Learning Series is a series of apps that seeks to make learning fun for kids between the ages of 6 and 12.\n\nFrom simple apps that introduce numbers and sounds, to building a basic vocabulary, these apps are purposely simple. And we’re building more, by the dozen! Hope your kids love using these apps as much as we enjoy building ‘em!",centerAlignSts: false)
        
        txtDescription.attributedText =  formattedString
        let size = returnDynamicFont(12.0)
        if let barlow = UIFont(name: "Barlow-Regular", size: size) {
            txtAppDescription.font = UIFont(name: "Barlow-Regular", size: size)
        }else{
            txtAppDescription.font = UIFont.systemFont(ofSize: size)
        }
        txtAppDescription.text = eventtive2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getMenuItems() { [weak self](menuItems) in
            guard let strongSelf = self else{return}
            strongSelf.menuItems = menuItems
            strongSelf.appListCollectionView.reloadData()
        }
        txtDescription.isScrollEnabled = true
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
        txtDescription.isScrollEnabled = false
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    //MARK: - Menu Items Model
    fileprivate func getMenuItems(completion:([AppModel])->())  {
        let appsItems = [
            AppModel(name: "FirstCal",  imageicon:"ic_firstCal", redirectUrl: ""),
            AppModel(name: "Wordlle",  imageicon:"ic_wordlle", redirectUrl: ""),
            AppModel(name: "firststorybook",  imageicon:"ic_firststorybook", redirectUrl: ""),
            AppModel(name: "Clock",  imageicon:"ic_clock", redirectUrl: ""),
            AppModel(name: "KiddieCal",  imageicon:"ic_kiddieCal", redirectUrl: ""),
            AppModel(name: "Painting",  imageicon:"ic_painting", redirectUrl: "")
        ]
        
        completion(appsItems)
    }
    
    
    
    
    @IBAction func dissmissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}

extension ELSeriesVC{
    static func getStoryboardInstance() -> UINavigationController?{
        let storyborad = UIStoryboard(name: String(describing: self), bundle: nil)
        guard let navViewController = storyborad.instantiateInitialViewController()  as? UINavigationController else { return nil }
        return navViewController
    }
}


extension ELSeriesVC:UICollectionViewDelegate{
    
}

extension ELSeriesVC:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppCollCell.identifier, for: indexPath) as? AppCollCell else { return UICollectionViewCell() }
        let apps = menuItems[indexPath.row]
        cell.imageicon.image = UIImage(named: apps.imageicon)
        //cell.imageicon.backgroundColor = .gray
        return cell
    }
    
    
}


extension ELSeriesVC:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        var cellSize:CGSize!
        let deviceType = UIDevice.DeviceType.self
        var width = (SCREEN_SIZE.width/3) - 60
        if deviceType.IS_IPHONE_5{
            width = (SCREEN_SIZE.width/3) - 55
        }else if deviceType.IS_IPHONE_4_OR_LESS{
            width = (SCREEN_SIZE.width/3) - 55
        }
        cellSize = CGSize(width: width, height: width)
        return cellSize
    }
    
    
}
