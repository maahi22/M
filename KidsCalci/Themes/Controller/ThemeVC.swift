//
//  ThemeVC.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 01/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import UIKit
import SKActivityIndicatorView


protocol ThemeVCDelegate:class {
    
    //func loadThemeView()
    
}


class ThemeVC: UIViewController {

   
    @IBOutlet var themeViewModel:ThemeViewModel!
    @IBOutlet var themeClient:ThemeClient!
    @IBOutlet weak var themeCollectionView: UICollectionView!
    weak var delegate:ThemeVCDelegate?
    @IBOutlet weak var backImageView: UIImageView!
    let gradientLayer = RadialGradientLayer()
    var networkActiveStatus =  true
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet private weak var collectionViewLayout: UICollectionViewFlowLayout!
    private var indexOfCellBeforeDragging = 0
    
    
    @IBOutlet weak var labelTopConstraint: NSLayoutConstraint!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewLayout.minimumLineSpacing = 0
        //Load gradient
        gradientLayer.frame = self.view.bounds
        backImageView.backgroundColor = .clear
        self.backImageView.layer.insertSublayer(gradientLayer, at: 0)
        //End
        self.navigationController?.navigationBar.transparentNavigationBar()
     
        themeCollectionView.register(ThemeCell.nib, forCellWithReuseIdentifier: ThemeCell.identifier)
        
        
        let deviceType = UIDevice.DeviceType.self
        if deviceType.IS_IPHONE_X {
            labelTopConstraint.constant = 50.0
        }
        
        
//        let label = UILabel()
//        label.textColor = UIColor.white
//        label.text = "Select Theme \n Tap to apply"
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        
        
        
        //showLoadingHUD()
        SKActivityIndicator.show("Downloading..")
        self.backButton.isHidden = false
        themeViewModel.getThemes { [weak self] (isSuccess, message) in
            guard let strongSelf = self else{return}
            //strongSelf.dismissLoadingHUD()
            SKActivityIndicator.dismiss()
            
            
            if isSuccess{
                DispatchQueue.main.async {
                    strongSelf.themeCollectionView.reloadData()
                }
            }else{
                strongSelf.networkActiveStatus = false
                showAlertMessage(vc: strongSelf, title: .Error, message: message)
                DispatchQueue.main.async {
                    strongSelf.themeCollectionView.reloadData()
                }
            }
            
            strongSelf.backButton.isHidden = true
            
        }
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SKActivityIndicator.dismiss()
    }
    
    
    @IBAction func backClik(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
        dismiss(animated: true, completion: nil)
    }
    

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureCollectionViewLayoutItemSize()
    }
    
    
    
    
    func brodcastLoadTheme()  {
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: NSNotification.Name(rawValue: Notification_THEME_APPLIED), object: nil)
    }
    
    
}

extension ThemeVC:CAAnimationDelegate{
    
}


extension ThemeVC{
    static func getStoryboardInstance() -> UINavigationController?{
        let storyborad = UIStoryboard(name: String(describing: self), bundle: nil)
        guard let navViewController = storyborad.instantiateInitialViewController()  as? UINavigationController else { return nil }
        return navViewController
    }
}

extension ThemeVC :UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item != 0 {
            
            if themeViewModel.dataActiveStatus {
                guard let them = themeViewModel.themesByRealmAt(for: indexPath) else {return}
                
                //Check already aplied
                let themeFolderName = KidsCalciUserDefaults.getTheme()
                if them.path.fileName().lowercased() == themeFolderName.lowercased() {
                    showAlertMessage(vc: self, title: .none, message: ThemeAlredyAplied)
                    return
                }
                
                SKActivityIndicator.show("Applying theme..")
                self.backButton.isHidden = false
               // showLoadingHUD()
                themeClient.offLineLoadtheme(them) { [weak self] (success, msg) in
                    guard let strongSelf = self else{return}
                    //strongSelf.dismissLoadingHUD()
                    if success{
                        let path = them.path
                        KidsCalciUserDefaults.setTheme(path.fileName())
                        strongSelf.brodcastLoadTheme()
                        DispatchQueue.main.async {
                                if let navController = strongSelf.navigationController {
                                    navController.popViewController(animated: true)
                                    navController.dismiss(animated: true, completion: nil)
                                }
                        }
                        
                        SKActivityIndicator.dismiss()
                        strongSelf.backButton.isHidden = true
                    }else{
                        SKActivityIndicator.dismiss()
                        strongSelf.backButton.isHidden = true
                        showAlertMessage(vc: strongSelf, title: .Message, message: msg)
                    }
                }
                
                
                
            }else{
                guard let them = themeViewModel.themesAt(for: indexPath) else {return}
                //Check already aplied
                let themeFolderName = KidsCalciUserDefaults.getTheme()
                if them.path?.fileName().lowercased() == themeFolderName.lowercased() {
                    showAlertMessage(vc: self, title: .none, message: ThemeAlredyAplied)
                    return
                }
                
               //Check already downloaded
                guard let zipPath = them.path else{ return}
                if checkDirectoryExist(zipPath.fileName()){
                    SKActivityIndicator.show("Applying theme..")
                }else{
                    SKActivityIndicator.show("Downloading..")
                }
                
                self.backButton.isHidden = false
                themeClient.downloadZipFile(them) { [weak self] (success, msg) in
                    guard let strongSelf = self else{return}
                    if success{
                        //strongSelf.themeCollectionView.reloadData()
                        guard let path = them.path else {return}
                        KidsCalciUserDefaults.setTheme(path.fileName())
                        strongSelf.brodcastLoadTheme()
                        DispatchQueue.main.async {
                                if let navController = strongSelf.navigationController {
                                    navController.popViewController(animated: true)
                                    navController.dismiss(animated: true, completion: nil)
                                }
                        }
                        SKActivityIndicator.dismiss()
                        strongSelf.backButton.isHidden = true
                        
                    }else{
                        SKActivityIndicator.dismiss()
                        strongSelf.backButton.isHidden = true
                        showAlertMessage(vc: strongSelf, title: .Error, message: msg)
                    }
                }
                
            }
        
        }else{
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                //Check already aplied
                let themeFolderName = KidsCalciUserDefaults.getTheme()
                if "" == themeFolderName.lowercased() {
                    showAlertMessage(vc: strongSelf, title: .none, message: ThemeAlredyAplied)
                    return
                }
                
                KidsCalciUserDefaults.removeCustomeTheme()
                strongSelf.brodcastLoadTheme()
                    if let navController = strongSelf.navigationController {
                        navController.popViewController(animated: true)
                        navController.dismiss(animated: true, completion: nil)
                    }
            }
        }
    }
    
    
    
    
    
    
    
    
    private func calculateSectionInset() -> CGFloat {
        let deviceIsIpad = UIDevice.current.userInterfaceIdiom == .pad
        let deviceOrientationIsLandscape = UIDevice.current.orientation.isLandscape
        let cellBodyViewIsExpended = deviceIsIpad || deviceOrientationIsLandscape
        let cellBodyWidth: CGFloat = 236 + (cellBodyViewIsExpended ? 174 : 0)
        
        let buttonWidth: CGFloat = 50
        
        let inset = (collectionViewLayout.collectionView!.frame.width - cellBodyWidth + buttonWidth) / 4
        return inset
    }
    
    private func configureCollectionViewLayoutItemSize() {
        let inset: CGFloat = calculateSectionInset() // This inset calculation is some magic so the next and the previous cells will peek from the sides. Don't worry about it
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        collectionViewLayout.itemSize = CGSize(width: collectionViewLayout.collectionView!.frame.size.width - inset * 2, height: collectionViewLayout.collectionView!.frame.size.height)
    }
    
    private func indexOfMajorCell() -> Int {
        let itemWidth = collectionViewLayout.itemSize.width
        let proportionalOffset = collectionViewLayout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(themeViewModel.numberThemes() - 1, index))
        return safeIndex
    }
    // =================================
    // MARK: - UICollectionViewDelegate:
    // =================================
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset
        
        // calculate where scrollView should snap to:
        let indexOfMajorCell = self.indexOfMajorCell()
        
        // calculate conditions:
        let swipeVelocityThreshold: CGFloat = 0.5 // after some trail and error
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < themeViewModel.numberThemes() && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        if didUseSwipeToSkipCell {
            
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = collectionViewLayout.itemSize.width * CGFloat(snapToIndex)
            
            // Damping equal 1 => no oscillations => decay animation:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
            
        } else {
            // This is a much better way to scroll to a cell:
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    
    
    
    
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let padding = 10
        var cellSize:CGSize!
        var width = (SCREEN_SIZE.width) - 90
        let height = (SCREEN_SIZE.height) - 160
        let deviceType = UIDevice.DeviceType.self
        if deviceType.IS_IPHONE_4_OR_LESS{
            width = (SCREEN_SIZE.width) - 45
        }
        
        cellSize = CGSize(width: width, height: height)
        
        return cellSize
    }*/
    
}

/*extension ThemeVC:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       //let padding = 10
        var cellSize:CGSize!
        var width = (SCREEN_SIZE.width) - 90
        let height = (SCREEN_SIZE.height) - 160
        let deviceType = UIDevice.DeviceType.self
        if deviceType.IS_IPHONE_4_OR_LESS{
            width = (SCREEN_SIZE.width) - 45
        }
        
        cellSize = CGSize(width: width, height: height)
        
        return cellSize
    }
    
}*/

extension ThemeVC:UICollectionViewDataSource{
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return themeViewModel.numberThemes()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThemeCell.identifier, for: indexPath) as? ThemeCell else { return UICollectionViewCell() }
       if themeViewModel.dataActiveStatus {
            cell.RealmThemes = themeViewModel.themesByRealmAt(for: indexPath)
        }else{
            cell.Themes = themeViewModel.themesAt(for: indexPath)
        }
        return cell
    }
}
