//
//  ViewController.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 01/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//https://useyourloaf.com/blog/synthesized-speech-from-text/
//https://www.raywenderlich.com/2411-how-to-make-a-narrated-book-using-avspeechsynthesizer-in-ios-7

import UIKit
import Speech
import Expression
import Toast_Swift



class ViewController: UIViewController {

    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var btnThemeChange: UIButton!
    @IBOutlet weak var lblExpresion: UILabel!
    @IBOutlet weak var barbuttonMute: UIBarButtonItem!
    @IBOutlet weak var labelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblExpHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topImageConstraint: NSLayoutConstraint!//88
    @IBOutlet weak var bottomImgConstraint: NSLayoutConstraint!//-34
   // @IBOutlet weak var resultBackgroundViewTopMinConstraint: NSLayoutConstraint!
    @IBOutlet weak var backImgView: UIImageView!
    @IBOutlet weak var resultBackgroundView: UIView!
    @IBOutlet weak var keybordBackView: UIView!
    
    
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var keybordbackImgView: UIImageView!
    @IBOutlet weak var parentScrollView: UIScrollView!
    
    
    
    
    
    let gradientLayer = CAGradientLayer()
    
    
    @IBOutlet weak var lbl1Back: UILabel!
    @IBOutlet weak var lbl2Back: UILabel!
    @IBOutlet weak var lbl3Back: UILabel!
    @IBOutlet weak var lbl4Back: UILabel!
    @IBOutlet weak var lblEqualBack: UILabel!
    
    let audioEngine = AVAudioEngine()
    var recognitionRequest : SFSpeechAudioBufferRecognitionRequest!
    var recognitionTask : SFSpeechRecognitionTask?
    let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    var speechSynthesizer:AVSpeechSynthesizer!

    let ACCEPTABLE_CHARACTERS = "0123456789+-/*=%"
    var equalClickSts = false
    var equalLastNum = ""
    var lastOprator = ""
    var resultString = ""
    var isSpeaking = true//mute button
    var speechStatus = false
    var isCancelStatus = false
    var speechInvalidStatus = false
    
    
    
    fileprivate var operations = [String]() {
        didSet {
            //operations.reverse()
            self.historyTableView.isHidden = false
            self.historyTableView.reloadData()
        }
    }
    
    
    
    
    fileprivate var ShowcurrentText = "0.0"
    fileprivate var currentText = "0" {
        didSet {
            
            if !currentText.contains("="){
                
                var resultStr = currentText
                if resultStr.contains("/") {
                    resultStr = resultStr.replacingOccurrences(of: "/", with: "÷")
                }
                if resultStr.contains("*") {
                    resultStr = resultStr.replacingOccurrences(of: "*", with: "x")
                }
                lblResult.text = resultStr
                self.historyTableView.reloadData()
            }else{

                lblResult.text = currentText
                self.historyTableView.reloadData()
            }
            
            self.labelHeightConstraint.constant = self.lblResult.retrieveTextHeight()
            self.lblExpHeightConstraint.constant = self.lblExpresion.retrieveTextHeight()
            
            if currentText.isEmpty {
                lblResult.text = ""
                currentText = "0"
                lastOprator = ""
            }
            
            if lblResult.text == " "{
                lblResult.text = ""
                currentText = "0"
                lastOprator = ""
            }
        }
    }
    
    
    @objc func appMovedToBackground() {
        //print("App moved to background!")
        if (self.speechSynthesizer != nil) {
            self.speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.speechSynthesizer != nil) {
            self.speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
    }
    
    deinit {
        if (self.speechSynthesizer != nil) {
            self.speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
    }
    
    
    
    
    
    
    
    override func viewDidLayoutSubviews() {
       DispatchQueue.main.async { [weak self] in
        guard let strongSelf = self else { return }
        
        
       
        
        strongSelf.parentScrollView.contentSize.height = strongSelf.historyTableView.contentSize.height + strongSelf.lblResult.frame.size.height + strongSelf.lblExpresion.frame.size.height + 15
    
        strongSelf.historyTableView.frame = CGRect(x: strongSelf.historyTableView.frame.origin.x, y: strongSelf.historyTableView.frame.origin.y, width: strongSelf.historyTableView.frame.size.width, height: strongSelf.historyTableView.contentSize.height)
        
        
        
        if strongSelf.parentScrollView.contentSize.height > strongSelf.parentScrollView.frame.height {
            
            strongSelf.lblExpresion.frame.origin.y = strongSelf.historyTableView.frame.origin.y + strongSelf.historyTableView.contentSize.height
            strongSelf.lblResult.frame.origin.y = strongSelf.historyTableView.frame.origin.y + strongSelf.historyTableView.contentSize.height + strongSelf.lblExpresion.frame.height
       
        
            let bottomOffset = CGPoint(x: 0, y: strongSelf.parentScrollView.contentSize.height - strongSelf.parentScrollView.bounds.size.height)
            strongSelf.parentScrollView.setContentOffset(bottomOffset, animated: true)
        
        }
        
        

        }
      //  lblExpresion.
        
        
    }
    
    
    var loadSts = false
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //register TableCell
        historyTableView.register(HistoryCell.nib, forCellReuseIdentifier: HistoryCell.identifier)
        self.historyTableView.isHidden = true
        historyTableView.estimatedRowHeight = 40.0
        historyTableView.rowHeight = UITableViewAutomaticDimension
        
        
        //Load gradient
        gradientLayer.frame = self.view.bounds
        let color1 = UIColor.hexStringToUIColor(hex: leftRedGradient).cgColor as CGColor
        let color2 = UIColor.hexStringToUIColor(hex: rightYellowGradient).cgColor as CGColor
        gradientLayer.colors = [ color1, color2]
        gradientLayer.locations = [0.0, 0.90]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        backImgView.backgroundColor = .clear
        self.backImgView.layer.insertSublayer(gradientLayer, at: 0)
        //End
        
        
        
        
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
        if  !KidsCalciUserDefaults.getTellUsMore(){
            KidsCalciUserDefaults.setHowManyTimeOpenApp()
        }
        
        isSpeaking = true
        let img = UIImage(named: "muteSpekerOn")
        barbuttonMute.image = img
        
        let deviceType = UIDevice.DeviceType.self
        if deviceType.IS_IPHONE_X {
           
        }else if deviceType.IS_IPHONE_6P{
        
            topImageConstraint.constant = -64
            bottomImgConstraint.constant = 0
           // resultBackgroundViewTopMinConstraint.constant = 30
            
        }else if deviceType.IS_IPHONE_6{
            
            topImageConstraint.constant = -64
            bottomImgConstraint.constant = 0
           // resultBackgroundViewTopMinConstraint.constant = 25
            
        }else{
            topImageConstraint.constant = -64
            bottomImgConstraint.constant = 0
          //  resultBackgroundViewTopMinConstraint.constant = 10
            
        }
        
        loadTheme()
        startRecognise()
        self.speechSynthesizer = AVSpeechSynthesizer()
        self.speechSynthesizer .delegate = self
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            print(documentDirectory)
        } catch {
            print(error)
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        let deviceType = UIDevice.DeviceType.self
        
       if deviceType.IS_IPHONE_X {
        self.navigationController?.navigationBar.transparentNavigationBar3()
       }else{
            self.navigationController?.navigationBar.transparentNavigationBar2()
        }
        self.navigationController?.navigationBar.backgroundColor = .clear
       /* if let img = UIImage(named: "gradientNavigationImg"){
            setNavigationBar(height:0, color:UIColor(patternImage: img)) //Custom Navigation bar
        }else{
            self.navigationController?.navigationBar.transparentNavigationBar()
            self.navigationController?.navigationBar.backgroundColor = .clear
        }*/
        
        self.lbl1Back.backgroundColor = .clear
        self.lbl2Back.backgroundColor = .clear
        self.lbl3Back.backgroundColor = .clear
        self.lbl4Back.backgroundColor = .clear
        self.lblEqualBack.backgroundColor = .clear
        
        loadTheme()
        startRecognise()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    
    
    /**
     Custom Navigation Bar
     */
    private lazy var customBar:  UINavigationBar = UINavigationBar()
    func setNavigationBar(height:CGFloat, color:UIColor){
        if let navHeight = navigationController?.navigationBar.frame.height{
            customBar.frame = CGRect(x:0, y:0, width:SCREEN_SIZE.width, height:navHeight + height + 20)
        }else{ // 20 for status bar height
            customBar.frame = CGRect(x:0, y:0, width:SCREEN_SIZE.width, height:64)
        }
        
        if let img = UIImage(named: "gradientNavigationImg"){
            customBar.backgroundColor = .clear
            customBar.setBackgroundImage(img,  for: .default)
        }else{
            customBar.backgroundColor = color
        }
        customBar.shadowImage = UIImage()
        customBar.isTranslucent = true
        self.view.addSubview(customBar)
    }
    
    func imageLayerForGradientBackground() -> UIImage {
        var updatedFrame = navigationController?.navigationBar.bounds
        // take into account the status bar
        updatedFrame?.size.height += 20
        let layer = CAGradientLayer.gradientLayerForBounds(bounds: updatedFrame!)
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
    
    
    @IBAction func themeChange(_ sender: Any) {
   
    let themeFolderName = KidsCalciUserDefaults.getTheme()
        if themeFolderName == "1"{
            KidsCalciUserDefaults.setTheme("2")
        }else if themeFolderName == "2"{
            KidsCalciUserDefaults.setTheme("0")
        }else{
            KidsCalciUserDefaults.setTheme("1")
        }
        
        self.lbl1Back.backgroundColor = .clear
        self.lbl2Back.backgroundColor = .clear
        self.lbl3Back.backgroundColor = .clear
        self.lbl4Back.backgroundColor = .clear
        self.lblEqualBack.backgroundColor = .clear
        self.loadTheme()
    }
    
    
    
    
    
    
    @IBAction func muteSpeker(_ sender: Any) {
        if isSpeaking{
            isSpeaking = false
            let img = UIImage(named: "muteSpekerOff")
            barbuttonMute.image = img
            self.speechSynthesizer.pauseSpeaking(at: .immediate)
        }else{
            isSpeaking = true
            let img = UIImage(named: "muteSpekerOn")
            barbuttonMute.image = img
            self.speechSynthesizer.continueSpeaking()
        }
    }
    
    
    
    @IBAction func showMenu(_ sender: Any) {
        let storyborad = UIStoryboard(name: "MenuVC", bundle: nil)
        let viewController = storyborad.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        let transition = CATransition()
        transition.duration = 1.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(viewController, animated: false, completion: nil)
    }
    
    func AddTost(_ msg:String){
        // basic usage
        self.view.makeToast(msg)
    }
    
    
    func loadTheme()  {
        
        let themeFolderName = KidsCalciUserDefaults.getTheme()
        
        gradientLayer.frame = self.view.bounds
        if themeFolderName == "1"{
            resultBackgroundView.backgroundColor = .clear
            backImgView.backgroundColor = UIColor.hexStringToUIColor(hex: theme1Color)
            keybordBackView.backgroundColor = UIColor.hexStringToUIColor(hex: darkBlueKeyboardColor)
            let color1 = UIColor.clear
            let color2 = UIColor.clear
            gradientLayer.colors = [color1,color2]
            self.backImgView.layer.insertSublayer(gradientLayer, at: 0)
            
            self.keybordbackImgView.isHidden = false
            self.keybordbackImgView.image = UIImage()
            self.keybordbackImgView.backgroundColor = UIColor.hexStringToUIColor(hex: darkBlueKeyboardColor)
            
            DispatchQueue.main.async { [weak self] in
                // Do task in main queue
                guard let strongSelf = self else { return }
                
                strongSelf.lblEqualBack.backgroundColor = UIColor.hexStringToUIColor(hex: themeLightGrayColor)
                strongSelf.lblEqualBack.alpha = 0.2
                strongSelf.lblResult.textColor = .white
                strongSelf.lblExpresion.textColor = .white
                
                
                if let btn10 = strongSelf.view.viewWithTag(10) as? UIButton {
                    btn10.titleLabel?.textColor = .white
                    btn10.setTitleColor(.white, for: .normal)
                    btn10.backgroundColor = UIColor.hexStringToUIColor(hex: darkBlueKeyboardColor)
                }
                if let btn50 = strongSelf.view.viewWithTag(50) as? UIButton {//dot
                    btn50.titleLabel?.textColor = .white
                    btn50.setTitleColor(.white, for: .normal)
                    btn50.backgroundColor = UIColor.hexStringToUIColor(hex: darkBlueKeyboardColor)
                }
                if let btn1 = strongSelf.view.viewWithTag(1) as? UIButton {
                    btn1.titleLabel?.textColor = .white
                    btn1.setTitleColor(.white, for: .normal)
                    btn1.backgroundColor = UIColor.hexStringToUIColor(hex: darkBlueKeyboardColor)
                }
                if let btn2 = strongSelf.view.viewWithTag(2) as? UIButton {
                    btn2.titleLabel?.textColor = .white
                    btn2.setTitleColor(.white, for: .normal)
                    btn2.backgroundColor = UIColor.hexStringToUIColor(hex: darkBlueKeyboardColor)
                }
                if let btn3 = strongSelf.view.viewWithTag(3) as? UIButton {
                    btn3.titleLabel?.textColor = .white
                    btn3.setTitleColor(.white, for: .normal)
                    btn3.backgroundColor = UIColor.hexStringToUIColor(hex: darkBlueKeyboardColor)
                }
                if let btn4 = strongSelf.view.viewWithTag(4) as? UIButton {
                    btn4.titleLabel?.textColor = .white
                    btn4.setTitleColor(.white, for: .normal)
                    btn4.backgroundColor = UIColor.hexStringToUIColor(hex: darkBlueKeyboardColor)
                }
                if let btn5 = strongSelf.view.viewWithTag(5) as? UIButton {
                    btn5.titleLabel?.textColor = .white
                    btn5.setTitleColor(.white, for: .normal)
                    btn5.backgroundColor = UIColor.hexStringToUIColor(hex: darkBlueKeyboardColor)
                }
                if let btn6 = strongSelf.view.viewWithTag(6) as? UIButton {
                    btn6.titleLabel?.textColor = .white
                    btn6.setTitleColor(.white, for: .normal)
                    btn6.backgroundColor = UIColor.hexStringToUIColor(hex: darkBlueKeyboardColor)
                }
                if let btn7 = strongSelf.view.viewWithTag(7) as? UIButton {
                    btn7.titleLabel?.textColor = .white
                    btn7.setTitleColor(.white, for: .normal)
                    btn7.backgroundColor = UIColor.hexStringToUIColor(hex: darkBlueKeyboardColor)
                }
                if let btn8 = strongSelf.view.viewWithTag(8) as? UIButton {
                    btn8.titleLabel?.textColor = .white
                    btn8.setTitleColor(.white, for: .normal)
                    btn8.backgroundColor = UIColor.hexStringToUIColor(hex: darkBlueKeyboardColor)
                }
                if let btn9 = strongSelf.view.viewWithTag(9) as? UIButton {
                    btn9.titleLabel?.textColor = .white
                    btn9.setTitleColor(.white, for: .normal)
                    btn9.backgroundColor = UIColor.hexStringToUIColor(hex: darkBlueKeyboardColor)
                }
                if let btn25 = strongSelf.view.viewWithTag(25) as? UIButton {
                    btn25.titleLabel?.textColor = .white
                    btn25.setTitleColor(.white, for: .normal)
                    btn25.backgroundColor = UIColor.hexStringToUIColor(hex: darkBlueKeyboardColor)
                    
                }
                if let btn26 = strongSelf.view.viewWithTag(26) as? UIButton {
                    btn26.titleLabel?.textColor = .white
                    btn26.setTitleColor(.white, for: .normal)
                    btn26.setImage(UIImage(named: "pluseMinusWhite"), for: .normal)
                    btn26.backgroundColor = UIColor.hexStringToUIColor(hex: darkBlueKeyboardColor)
                }
                
                if let btn32 = strongSelf.view.viewWithTag(32) as? UIButton {//equal
                    btn32.titleLabel?.textColor = .white
                    btn32.setTitleColor(.white, for: .normal)
                    
                    //btn32.alpha = 0.7
                    // btn32.backgroundColor = UIColor.hexStringToUIColor(hex: darkBlueKeyboardColor)
                }
                
                
                if let btn27 = strongSelf.view.viewWithTag(27) as? UIButton {
                    btn27.titleLabel?.textColor = UIColor.hexStringToUIColor(hex: theme1TextRedColor)
                    btn27.setTitleColor(UIColor.hexStringToUIColor(hex: theme1TextRedColor), for: .normal)
                    btn27.backgroundColor = UIColor.hexStringToUIColor(hex: darkBlueKeyboardColor)
                }
                if let btn28 = strongSelf.view.viewWithTag(28) as? UIButton {
                    btn28.titleLabel?.textColor = UIColor.hexStringToUIColor(hex: theme1TextRedColor)
                    btn28.setTitleColor(UIColor.hexStringToUIColor(hex: theme1TextRedColor), for: .normal)
                    btn28.backgroundColor = UIColor.hexStringToUIColor(hex: darkBlueKeyboardColor)
                }
                if let btn29 = strongSelf.view.viewWithTag(29) as? UIButton {
                    btn29.titleLabel?.textColor = UIColor.hexStringToUIColor(hex: theme1TextRedColor)
                    btn29.setTitleColor(UIColor.hexStringToUIColor(hex: theme1TextRedColor), for: .normal)
                    btn29.backgroundColor = UIColor.hexStringToUIColor(hex: darkBlueKeyboardColor)
                }
                if let btn30 = strongSelf.view.viewWithTag(30) as? UIButton {
                    btn30.titleLabel?.textColor = UIColor.hexStringToUIColor(hex: theme1TextRedColor)
                    btn30.setTitleColor(UIColor.hexStringToUIColor(hex: theme1TextRedColor), for: .normal)
                    btn30.backgroundColor = UIColor.hexStringToUIColor(hex: darkBlueKeyboardColor)
                }
                if let btn31 = strongSelf.view.viewWithTag(31) as? UIButton {
                    btn31.titleLabel?.textColor = UIColor.hexStringToUIColor(hex: theme1TextRedColor)
                    btn31.setTitleColor(UIColor.hexStringToUIColor(hex: theme1TextRedColor), for: .normal)
                    btn31.backgroundColor = UIColor.hexStringToUIColor(hex: darkBlueKeyboardColor)
                }
                
                if let btn51 = strongSelf.view.viewWithTag(51) as? UIButton {//speker
                    btn51.backgroundColor = UIColor.clear
                    btn51.setImage(UIImage(named: "speaker1"), for: .normal)
                }
                
            }
            
            
            
            
            
        }else if themeFolderName == "2"{
            
            
            self.resultBackgroundView.backgroundColor = UIColor.hexStringToUIColor(hex: themeLightGrayColor)
            if !loadSts{
                let color1 = UIColor.hexStringToUIColor(hex: themeLightGrayColor).cgColor
                let color2 = UIColor.hexStringToUIColor(hex: themeLightGrayColor).cgColor
                self.gradientLayer.colors = [color1,color2]
                self.backImgView.layer.insertSublayer(self.gradientLayer, at: 0)
                //self.backImgView.layer.insertSublayer(CAGradientLayer(), at: 0)
            }
            
            
            
            self.backImgView.backgroundColor = UIColor.hexStringToUIColor(hex: themeLightGrayColor)
            
            self.keybordBackView.backgroundColor = UIColor.clear
            self.keybordbackImgView.isHidden = false
            self.keybordbackImgView.image = UIImage(named: "1_themeBack")
            
            self.lblResult.textColor = UIColor.hexStringToUIColor(hex: theme2TextColor)
            self.lblExpresion.textColor = UIColor.hexStringToUIColor(hex: theme2TextColor)
            
            
            DispatchQueue.main.async { [weak self] in
                // Do task in main queue
                guard let strongSelf = self else { return }
                
                
                //                strongSelf.resultBackgroundView.backgroundColor = UIColor.hexStringToUIColor(hex: themeLightGrayColor)
                //                strongSelf.backImgView.backgroundColor = UIColor.hexStringToUIColor(hex: themeLightGrayColor)
                //                strongSelf.keybordBackView.backgroundColor = UIColor.clear
                //                let color1 = UIColor.hexStringToUIColor(hex: themeLightGrayColor).cgColor
                //                let color2 = UIColor.hexStringToUIColor(hex: themeLightGrayColor).cgColor
                //                strongSelf.gradientLayer.colors = [color1,color2]
                //                strongSelf.backImgView.layer.insertSublayer(strongSelf.gradientLayer, at: 0)
                //
                //                strongSelf.keybordbackImgView.isHidden = false
                //                strongSelf.keybordbackImgView.image = UIImage(named: "1_themeBack")
                //
                //                strongSelf.lblResult.textColor = UIColor.hexStringToUIColor(hex: theme2TextColor)
                //                strongSelf.lblExpresion.textColor = UIColor.hexStringToUIColor(hex: theme2TextColor)
                
                strongSelf.keybordBackView.backgroundColor = .white
                strongSelf.lbl1Back.backgroundColor = UIColor.hexStringToUIColor(hex: themeLightGrayColor)
                strongSelf.lbl2Back.backgroundColor = UIColor.hexStringToUIColor(hex: themeLightGrayColor)
                strongSelf.lbl3Back.backgroundColor = UIColor.hexStringToUIColor(hex: themeLightGrayColor)
                strongSelf.lbl4Back.backgroundColor = UIColor.hexStringToUIColor(hex: themeLightGrayColor)
                strongSelf.lblEqualBack.backgroundColor = UIColor.hexStringToUIColor(hex: themeLightGrayColor)
                
                strongSelf.lbl1Back.alpha = 0.2
                strongSelf.lbl2Back.alpha = 0.2
                strongSelf.lbl3Back.alpha = 0.2
                strongSelf.lbl4Back.alpha = 0.2
                strongSelf.lblEqualBack.alpha = 0.2
                
                
                if let btn10 = strongSelf.view.viewWithTag(10) as? UIButton {
                    btn10.titleLabel?.textColor = .white
                    btn10.setTitleColor(.white, for: .normal)
                    btn10.backgroundColor = .clear
                }
                if let btn50 = strongSelf.view.viewWithTag(50) as? UIButton {//dot
                    btn50.titleLabel?.textColor = .white
                    btn50.setTitleColor(.white, for: .normal)
                    btn50.backgroundColor = .clear
                }
                if let btn1 = strongSelf.view.viewWithTag(1) as? UIButton {
                    btn1.titleLabel?.textColor = .white
                    btn1.setTitleColor(.white, for: .normal)
                    btn1.backgroundColor = .clear
                }
                if let btn2 = strongSelf.view.viewWithTag(2) as? UIButton {
                    btn2.titleLabel?.textColor = .white
                    btn2.setTitleColor(.white, for: .normal)
                    btn2.backgroundColor = .clear
                }
                if let btn3 = strongSelf.view.viewWithTag(3) as? UIButton {
                    btn3.titleLabel?.textColor = .white
                    btn3.setTitleColor(.white, for: .normal)
                    btn3.backgroundColor = .clear
                }
                if let btn4 = strongSelf.view.viewWithTag(4) as? UIButton {
                    btn4.titleLabel?.textColor = .white
                    btn4.setTitleColor(.white, for: .normal)
                    btn4.backgroundColor = .clear
                }
                if let btn5 = strongSelf.view.viewWithTag(5) as? UIButton {
                    btn5.titleLabel?.textColor = .white
                    btn5.setTitleColor(.white, for: .normal)
                    btn5.backgroundColor = .clear
                }
                if let btn6 = strongSelf.view.viewWithTag(6) as? UIButton {
                    btn6.titleLabel?.textColor = .white
                    btn6.setTitleColor(.white, for: .normal)
                    btn6.backgroundColor = .clear
                }
                if let btn7 = strongSelf.view.viewWithTag(7) as? UIButton {
                    btn7.titleLabel?.textColor = .white
                    btn7.setTitleColor(.white, for: .normal)
                    btn7.backgroundColor = .clear
                }
                if let btn8 = strongSelf.view.viewWithTag(8) as? UIButton {
                    btn8.titleLabel?.textColor = .white
                    btn8.setTitleColor(.white, for: .normal)
                    btn8.backgroundColor = .clear
                }
                if let btn9 = strongSelf.view.viewWithTag(9) as? UIButton {
                    btn9.titleLabel?.textColor = .white
                    btn9.setTitleColor(.white, for: .normal)
                    btn9.backgroundColor = .clear
                }
                if let btn25 = strongSelf.view.viewWithTag(25) as? UIButton {
                    btn25.titleLabel?.textColor = .white
                    btn25.setTitleColor(.white, for: .normal)
                    btn25.backgroundColor = .clear
                    
                }
                if let btn26 = strongSelf.view.viewWithTag(26) as? UIButton {
                    btn26.titleLabel?.textColor = .white
                    btn26.setTitleColor(.white, for: .normal)
                    btn26.setImage(UIImage(named: "pluseMinusWhite"), for: .normal)
                    btn26.backgroundColor = .clear
                }
                
                if let btn32 = strongSelf.view.viewWithTag(32) as? UIButton {//equal
                    btn32.titleLabel?.textColor = .white
                    btn32.setTitleColor(.white, for: .normal)
                    //btn32.alpha = 0.7
                    btn32.backgroundColor = .clear
                }
                
                
                if let btn27 = strongSelf.view.viewWithTag(27) as? UIButton {
                    btn27.titleLabel?.textColor = .white
                    btn27.setTitleColor(.white, for: .normal)
                    btn27.backgroundColor = .clear
                }
                if let btn28 = strongSelf.view.viewWithTag(28) as? UIButton {
                    btn28.titleLabel?.textColor = .white
                    btn28.setTitleColor(.white, for: .normal)
                    btn28.backgroundColor = .clear
                }
                if let btn29 = strongSelf.view.viewWithTag(29) as? UIButton {
                    btn29.titleLabel?.textColor = .white
                    btn29.setTitleColor(.white, for: .normal)
                    btn29.backgroundColor = .clear
                }
                if let btn30 = strongSelf.view.viewWithTag(30) as? UIButton {
                    btn30.titleLabel?.textColor = .white
                    btn30.setTitleColor(.white, for: .normal)
                    btn30.backgroundColor = .clear
                }
                if let btn31 = strongSelf.view.viewWithTag(31) as? UIButton {
                    btn31.titleLabel?.textColor = .white
                    btn31.setTitleColor(.white, for: .normal)
                    btn31.backgroundColor = .clear
                }
                
                if let btn51 = strongSelf.view.viewWithTag(51) as? UIButton {//speker
                    //btn51.titleLabel?.textColor = .white
                    btn51.backgroundColor = .clear
                    btn51.setTitleColor(.white, for: .normal)
                    btn51.setImage(UIImage(named: "speaker2"), for: .normal)
                }
                
            }
            
            
            
            
        }else{
            //Load gradient
            resultBackgroundView.backgroundColor = .clear
            let color1 = UIColor.hexStringToUIColor(hex: leftRedGradient).cgColor as CGColor
            let color2 = UIColor.hexStringToUIColor(hex: rightYellowGradient).cgColor as CGColor
            gradientLayer.colors = [ color1, color2]
            gradientLayer.locations = [0.2, 1.0]
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            backImgView.backgroundColor = .clear
            self.backImgView.layer.insertSublayer(gradientLayer, at: 0)
            
            //End
            keybordbackImgView.isHidden = false
            self.keybordbackImgView.image = UIImage()
            self.keybordbackImgView.backgroundColor = .white
            DispatchQueue.main.async { [weak self] in
                // Do task in main queue
                guard let strongSelf = self else { return }
                
                strongSelf.keybordBackView.backgroundColor = .white
                strongSelf.lbl1Back.backgroundColor = UIColor.hexStringToUIColor(hex: themeLightGrayColor)
                strongSelf.lbl2Back.backgroundColor = UIColor.hexStringToUIColor(hex: themeLightGrayColor)
                strongSelf.lbl3Back.backgroundColor = UIColor.hexStringToUIColor(hex: themeLightGrayColor)
                strongSelf.lbl4Back.backgroundColor = UIColor.hexStringToUIColor(hex: themeLightGrayColor)
                strongSelf.lblEqualBack.backgroundColor = UIColor.hexStringToUIColor(hex: themeLightGrayColor)
                
                strongSelf.lbl1Back.alpha = 0.2
                strongSelf.lbl2Back.alpha = 0.2
                strongSelf.lbl3Back.alpha = 0.2
                strongSelf.lbl4Back.alpha = 0.2
                strongSelf.lblEqualBack.alpha = 0.2
                
                strongSelf.lblResult.textColor = .white
                strongSelf.lblExpresion.textColor = .white
                
                
                
                if let btn10 = strongSelf.view.viewWithTag(10) as? UIButton {
                    btn10.titleLabel?.textColor = UIColor.hexStringToUIColor(hex: theme0TextRedColor)
                    btn10.setTitleColor(UIColor.hexStringToUIColor(hex: theme0TextRedColor), for: .normal)
                    btn10.backgroundColor = UIColor.clear
                }
                if let btn50 = strongSelf.view.viewWithTag(50) as? UIButton {//dot
                    btn50.titleLabel?.textColor = UIColor.hexStringToUIColor(hex: theme0TextRedColor)
                    btn50.setTitleColor(UIColor.hexStringToUIColor(hex: theme0TextRedColor), for: .normal)
                    btn50.backgroundColor = UIColor.clear
                }
                if let btn1 = strongSelf.view.viewWithTag(1) as? UIButton {
                    btn1.titleLabel?.textColor = UIColor.hexStringToUIColor(hex: theme0TextRedColor)
                    btn1.setTitleColor(UIColor.hexStringToUIColor(hex: theme0TextRedColor), for: .normal)
                    btn1.backgroundColor = UIColor.clear
                }
                if let btn2 = strongSelf.view.viewWithTag(2) as? UIButton {
                    btn2.titleLabel?.textColor = UIColor.hexStringToUIColor(hex: theme0TextRedColor)
                    btn2.setTitleColor(UIColor.hexStringToUIColor(hex: theme0TextRedColor), for: .normal)
                    btn2.backgroundColor = UIColor.clear
                }
                if let btn3 = strongSelf.view.viewWithTag(3) as? UIButton {
                    btn3.titleLabel?.textColor = UIColor.hexStringToUIColor(hex: theme0TextRedColor)
                    btn3.setTitleColor(UIColor.hexStringToUIColor(hex: theme0TextRedColor), for: .normal)
                    btn3.backgroundColor = UIColor.clear
                }
                if let btn4 = strongSelf.view.viewWithTag(4) as? UIButton {
                    btn4.titleLabel?.textColor = UIColor.hexStringToUIColor(hex: theme0TextRedColor)
                    btn4.setTitleColor(UIColor.hexStringToUIColor(hex: theme0TextRedColor), for: .normal)
                    btn4.backgroundColor = UIColor.clear
                }
                if let btn5 = strongSelf.view.viewWithTag(5) as? UIButton {
                    btn5.titleLabel?.textColor = UIColor.hexStringToUIColor(hex: theme0TextRedColor)
                    btn5.setTitleColor(UIColor.hexStringToUIColor(hex: theme0TextRedColor), for: .normal)
                    btn5.backgroundColor = UIColor.clear
                }
                if let btn6 = strongSelf.view.viewWithTag(6) as? UIButton {
                    btn6.titleLabel?.textColor = UIColor.hexStringToUIColor(hex: theme0TextRedColor)
                    btn6.setTitleColor(UIColor.hexStringToUIColor(hex: theme0TextRedColor), for: .normal)
                    btn6.backgroundColor = UIColor.clear
                }
                if let btn7 = strongSelf.view.viewWithTag(7) as? UIButton {
                    btn7.titleLabel?.textColor = UIColor.hexStringToUIColor(hex: theme0TextRedColor)
                    btn7.setTitleColor(UIColor.hexStringToUIColor(hex: theme0TextRedColor), for: .normal)
                    btn7.backgroundColor = UIColor.clear
                }
                if let btn8 = strongSelf.view.viewWithTag(8) as? UIButton {
                    btn8.titleLabel?.textColor = UIColor.hexStringToUIColor(hex: theme0TextRedColor)
                    btn8.setTitleColor(UIColor.hexStringToUIColor(hex: theme0TextRedColor), for: .normal)
                    btn8.backgroundColor = UIColor.clear
                }
                if let btn9 = strongSelf.view.viewWithTag(9) as? UIButton {
                    btn9.titleLabel?.textColor = UIColor.hexStringToUIColor(hex: theme0TextRedColor)
                    btn9.setTitleColor(UIColor.hexStringToUIColor(hex: theme0TextRedColor), for: .normal)
                    btn9.backgroundColor = UIColor.clear
                }
                if let btn25 = strongSelf.view.viewWithTag(25) as? UIButton {//C
                    btn25.titleLabel?.textColor = UIColor.hexStringToUIColor(hex: theme0TextRedColor)
                    btn25.setTitleColor(UIColor.hexStringToUIColor(hex: theme0TextRedColor), for: .normal)
                    btn25.backgroundColor = UIColor.clear
                    
                }
                if let btn26 = strongSelf.view.viewWithTag(26) as? UIButton {//
                    btn26.titleLabel?.textColor = UIColor.hexStringToUIColor(hex: theme0TextRedColor)
                    btn26.setTitleColor(UIColor.hexStringToUIColor(hex: theme0TextRedColor), for: .normal)
                    btn26.setImage(UIImage(named: "pluseMinusBlack"), for: .normal)
                    btn26.backgroundColor = UIColor.clear
                }
                
                if let btn32 = strongSelf.view.viewWithTag(32) as? UIButton {//equal
                    btn32.titleLabel?.textColor = UIColor.hexStringToUIColor(hex: theme0TextRedColor)
                    btn32.setTitleColor(UIColor.hexStringToUIColor(hex: theme0TextRedColor), for: .normal)
                    btn32.backgroundColor = UIColor.clear
                    // btn32.alpha = 0.4
                }
                
                
                if let btn27 = strongSelf.view.viewWithTag(27) as? UIButton {//%
                    btn27.titleLabel?.textColor = UIColor.hexStringToUIColor(hex: theme0TextRedColor)
                    btn27.setTitleColor(UIColor.hexStringToUIColor(hex: theme0TextRedColor), for: .normal)
                    btn27.backgroundColor = UIColor.clear
                }
                if let btn28 = strongSelf.view.viewWithTag(28) as? UIButton {//devide
                    btn28.titleLabel?.textColor = UIColor.hexStringToUIColor(hex: theme0TextRedColor)
                    btn28.setTitleColor(UIColor.hexStringToUIColor(hex: theme0TextRedColor), for: .normal)
                    btn28.backgroundColor = UIColor.clear
                }
                if let btn29 = strongSelf.view.viewWithTag(29) as? UIButton {//X
                    btn29.titleLabel?.textColor = UIColor.hexStringToUIColor(hex: theme0TextRedColor)
                    btn29.setTitleColor(UIColor.hexStringToUIColor(hex: theme0TextRedColor), for: .normal)
                    btn29.backgroundColor = UIColor.clear
                }
                if let btn30 = strongSelf.view.viewWithTag(30) as? UIButton {//-
                    btn30.titleLabel?.textColor = UIColor.hexStringToUIColor(hex: theme0TextRedColor)
                    btn30.setTitleColor(UIColor.hexStringToUIColor(hex: theme0TextRedColor), for: .normal)
                    btn30.backgroundColor = UIColor.clear
                }
                if let btn31 = strongSelf.view.viewWithTag(31) as? UIButton {//+
                    btn31.titleLabel?.textColor = UIColor.hexStringToUIColor(hex: theme0TextRedColor)
                    btn31.setTitleColor(UIColor.hexStringToUIColor(hex: theme0TextRedColor), for: .normal)
                    btn31.backgroundColor = UIColor.clear
                }
                
                if let btn51 = strongSelf.view.viewWithTag(51) as? UIButton {//speker
                    btn51.backgroundColor = UIColor.clear
                    btn51.setImage(UIImage(named: "speaker"), for: .normal)
                }
                
            }
            
        }
        
        historyTableView.reloadData()
        loadSts = true
    }
        
    
    
    //*********LOng press clear
    
    @IBAction func longPressBack(_ sender: UILongPressGestureRecognizer) {
        //print("longPressBack")
        if (sender.state == .began) {
            clearAll()
            return
        }
    }
    
    
    //*********Click Number
    @IBAction func numberClick(_ sender: UIButton) {
        
        lblExpresion.text = ""//ADDED
        if currentText.contains("inf") || currentText.contains("-inf") || currentText.contains("nan"){
            currentText = "0"
            lblExpresion.text = ""
        }
        
        if speechStatus {
            currentText = "0"
            lblExpresion.text = ""
            //lblResult.text = ""
            speechStatus = false
        }//Check speech
        
        
        if equalClickSts {
            blankLastequalOperator()//Added in kidde calsi
        }
        
        // blankLastequalOperator()
        equalClickSts = false
        var tagvalue = sender.tag
        if tagvalue == 10 {
            tagvalue = 0
        }
        
        let currentString = "\(tagvalue)"
       
        
        
        //Check zero
        let lastOp = getLastOperator(currentText)
        if lastOp == ""{
            if currentText == "0" && currentString == "0"{//Zero at first place
                return
            }else if currentText == "0" && currentString != "0"{//Zero at first place insert new no
                //currentText = "\(currentText.dropLast())"
                // currentText.append(currentString)
                currentText = currentString
                speakText(text: currentString)
                return
            }
        }else{
            let resultArr = currentText.components(separatedBy: lastOp)
            if let expStr = resultArr.last {
                if expStr == "0" && currentString == "0"{//Zero at first place
                    return
                }else if expStr == "0" && currentString != "0"{//Zero at first place insert new no
                    currentText = "\(currentText.dropLast())"
                    currentText.append(currentString)
                    speakText(text: currentString)
                    return
                }
            }
        }
        //ENDED
        
        
        if currentText == "0" || currentText.contains("=") {
            lblExpresion.text = ""
            currentText = currentString
            if checkExperationLengthExceeded(currentText ,mathOperator:lastOprator){
                self.AddTost(AlertMaxNoExceed)
                return
            }
            
        }else if currentText == "0" || currentText.contains("=") {//Added
            //lblExpresion.text = ""
            currentText = currentText.appending(currentString)//currentString
            if checkExperationLengthExceeded(currentText ,mathOperator:lastOprator){
                self.AddTost(AlertMaxNoExceed)
                return
            }
        
        }else {
          
            if checkExperationLengthExceeded(currentText ,mathOperator:lastOprator){
                self.AddTost(AlertMaxNoExceed)
                return
            }
            
            currentText = currentText.appending(currentString)
        }
       speakText(text: currentString)
    
    }
    
    
    
    
    //Click Calculation
    @IBAction func clickOperations(_ sender: UIButton) {
        
        
        if currentText.contains("inf"){
            currentText = "0"
            lblExpresion.text = ""
        }
        
        
        let tagvalue = sender.tag
        switch tagvalue {
        case 51:
            //speakText(text: "C")
            checkSpeechStatus()
            equalClickSts = false
            AddSpeakChildVC()
        case 50:
            //Check last dot only number enter
            if checkLastCharIsDot(currentText){
                return
            }//ENDED
            checkSpeechStatus()
            equalClickSts = false
            let currentString = "."
           
            if currentText == "0" || currentText.contains("=") {
                if checkDotOperator(currentText, lastOprt: lastOprator) && currentText == ""{//if contain
                    currentText = "0."
                    return
                }
                lblExpresion.text = ""
                currentText = currentString
            }else {
                if checkDotOperator(currentText, lastOprt: lastOprator){//if contain
                    return
                }
                
                currentText = currentText.appending(currentString)
            }
            speakText(text: "point")
        case 26://+/-
            print("+/-")
            //Check last dot only number enter
            if checkLastCharIsDot(currentText){
                return
            }//ENDED
            
            checkSpeechStatus()
            equalClickSts = false
            
           // self.removeResult()
            if currentText == "0"   || currentText.contains("="){
                //currentText = currentString
               /* if checkLastCharIsOperator(currentText){
                    currentText = "\(currentText.dropLast())"
                    currentText.append(currentString)
                }else{
                    currentText = currentString
                }*/
                
                return
                
            }else {
                //currentText = currentText.appending(currentString)
                if checkLastCharIsOperator(currentText){
                    //currentText = "\(currentText.dropLast())"
                    //currentText.append(currentString)
                    speakText(text: InvalidTextInput)
                    return
                }else{
                    
                    
                    currentText = AddPluseMinuse(currentText, lastOperator: lastOprator)//currentText.appending(currentString)
                }
                
            }
            if checkFirstCharIsOperator(currentText){
                currentText = "0"
                return
            }
            //speakText(text: currentString)
           
            
            
        case 25:
            print("backSpace")
            if speechStatus {
                return
            }
            speechStatus = false
            
            if equalClickSts{
                return
            }
            
            if currentText == "0.0" || currentText == "0"{
                currentText = "0"
                
                let exp = lblExpresion.text
                if let ex = exp {
                    if  (ex.count) > 0 {
                        lblExpresion.text = "\(ex.dropLast())"
                    }
                }
            }else{
                currentText = "\(currentText.dropLast())"
            }
            
        case 27:
            
            //Check last dot only number enter
            if checkLastCharIsDot(currentText){
                return
            }//ENDED
            
            checkSpeechStatus()
            equalClickSts = false
            let currentString = "%"
            self.removeResult()
            if currentText == "0"  || currentText.contains("=") {
                if checkLastCharIsOperator(currentText){
                    currentText = "\(currentText.dropLast())"
                    currentText.append(currentString)
                }else{
                    currentText = currentString
                }
            }else {
                if checkLastCharIsOperator(currentText){
                    currentText = "\(currentText.dropLast())"
                    currentText.append(currentString)
                }else{
                    currentText = currentText.appending(currentString)
                }
            }
            
            if checkFirstCharIsOperator(currentText){
                currentText = "0"
                return
            }
            
            speakText(text: currentString)
            lastOprator = currentString
        case 28:
            //Check last dot only number enter
            if checkLastCharIsDot(currentText){
                return
            }//ENDED
            
            checkSpeechStatus()
            equalClickSts = false
            let currentString = "/"
            self.removeResult()
            if currentText == "0"  || currentText.contains("=") {
                //currentText = currentString
                if checkLastCharIsOperator(currentText){
                    currentText = "\(currentText.dropLast())"
                    currentText.append(currentString)
                }else{
                    currentText = currentString
                }
            }else {
                if checkLastCharIsOperator(currentText){
                    currentText = "\(currentText.dropLast())"
                    currentText.append(currentString)
                }else{
                    currentText = currentText.appending(currentString)
                }
            }
            if checkFirstCharIsOperator(currentText){
                currentText = ""
                return
            }
            speakText(text: currentString)
            lastOprator = currentString
        case 29:
            
            //Check last dot only number enter
            if checkLastCharIsDot(currentText){
                return
            }//ENDED
            
            checkSpeechStatus()
            equalClickSts = false
            let currentString = "*"
            self.removeResult()
            if currentText == "0"   || currentText.contains("="){
                //currentText = currentString
                if checkLastCharIsOperator(currentText){
                    currentText = "\(currentText.dropLast())"
                    currentText.append(currentString)
                }else{
                    currentText = currentString
                }
            
            }else {
                //currentText = currentText.appending(currentString)
                if checkLastCharIsOperator(currentText){
                    currentText = "\(currentText.dropLast())"
                    currentText.append(currentString)
                }else{
                    currentText = currentText.appending(currentString)
                }
            
            }
            if checkFirstCharIsOperator(currentText){
                currentText = "0"
                return
            }
            speakText(text: currentString)
            lastOprator = currentString
        case 30:
            //Check last dot only number enter
            if checkLastCharIsDot(currentText){
                return
            }//ENDED
            checkSpeechStatus()
            equalClickSts = false
            let currentString = "-"
            
            
            self.removeResult()
            if currentText == "0"  || currentText.contains("=") {
                //currentText = currentString
                if checkLastCharIsOperator(currentText){
                    currentText = "\(currentText.dropLast())"
                    currentText.append(currentString)
                }else{
                    currentText = currentString
                }
            }else {
                if checkLastCharIsOperator(currentText){
                    currentText = "\(currentText.dropLast())"
                    currentText.append(currentString)
                }else{
                    currentText = currentText.appending(currentString)
                }
            }
            if checkFirstCharIsOperator(currentText){
                currentText = "0"
                return
            }
            
            
            speakText(text: currentString)
            lastOprator = currentString
        case 31:
            
            //Check last dot only number enter
            if checkLastCharIsDot(currentText){
                return
            }//ENDED
            
            checkSpeechStatus()
            equalClickSts = false
            let currentString = "+"
            self.removeResult()
            if currentText == "0"   || currentText.contains("="){
                if checkLastCharIsOperator(currentText){
                    currentText = "\(currentText.dropLast())"
                    currentText.append(currentString)
                }else{
                    currentText = currentString
                }
            }else {
                if checkLastCharIsOperator(currentText){
                    currentText = "\(currentText.dropLast())"
                    currentText.append(currentString)
                }else{
                    currentText = currentText.appending(currentString)
                }
            }
            if checkFirstCharIsOperator(currentText){
                currentText = "0"
                return
            }
            
            speakText(text: currentString)
            lastOprator = currentString
        case 32://32 Equal
            
            //Check last dot only number enter
            if checkLastCharIsDot(currentText){
                return
            }//ENDED
            
            checkSpeechStatus()
            if currentText != nil && currentText != "0" && currentText != "" {
              
                if equalClickSts{
                    removeResult()
                    currentText = currentText.appending("\(lastOprator)\(equalLastNum)")
                }else if checkFirstCharIsOperator(currentText){
                    currentText = "0"
                    return
                }
            
                if !equalClickSts  && !currentText.contains("+") && !currentText.contains("-") && !currentText.contains("%") && !currentText.contains("*") && !currentText.contains("x") && !currentText.contains("/") && !currentText.contains("÷") && !currentText.contains("×"){
                    
                    return
                }
                
                let lastOp = getLastOperator(currentText)
                if lastOp == ""{
                    return
                }else if ( lastOp == "-" && currentText.prefix(1) == "-"){
                    var resultArr = currentText.components(separatedBy: "-")
                    if resultArr.count == 2 && resultArr[0] == ""{
                        return
                    }
                    
                    
                }
                
                
                equalClickSts = true
                doMath()
            }
            
        default:
            print("Default")
            
        }
         
    }
    
    
    func checkSpeechStatus(){
        if speechStatus {
            currentText = "0"
            lblExpresion.text = ""
            //lblResult.text = ""
            speechStatus = false
        }
    }
    
    
    func  clickC()  {
        if speechStatus {
            return
        }
        speechStatus = false
        
        if equalClickSts{
            return
        }
        
        if currentText == "0.0" || currentText == "0"{
            currentText = "0"
            
            let exp = lblExpresion.text
            if let ex = exp {
                if  (ex.count) > 0 {
                    lblExpresion.text = "\(ex.dropLast())"
                }
            }
        }else{
            currentText = "\(currentText.dropLast())"
        }
    }
    
    
    
    func clearAll(){
        equalClickSts = false
        currentText = "0"
        //lblResult.text = ""
        lblExpresion.text = ""
        speakText(text: "Clear All")
        operations.removeAll()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            // your code here
            guard let strongSelf = self else { return }
            //strongSelf.clickC()
            strongSelf.currentText = "0"
            strongSelf.lblExpresion.text = " "
        }
    }
    
    func blankLastequalOperator()  {
        lastOprator = ""
        equalLastNum = ""
    }
    
    func removeResult()  {
        if currentText.contains("="){
            lblExpresion.text = ""
            currentText = currentText.replacingOccurrences(of: "=", with: "")
        }
    }
    
    
    // Check microphone and Speech recog
    func showPermisssionAlert(_ permission:String){

        let alertController = UIAlertController(title: permission, message: "Please go to Settings and turn on the permissions", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in }
                )
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
        
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //Check microphone
    var microphoneSts = false
    func checkMicrophone() {
        
        switch AVAudioSession.sharedInstance().recordPermission() {
        case AVAudioSessionRecordPermission.granted:
            print("Permission granted")
            microphoneSts = true
        case AVAudioSessionRecordPermission.denied:
            print("Pemission denied")
            self.showPermisssionAlert("Microphone")
            microphoneSts =  false
        case AVAudioSessionRecordPermission.undetermined:
            print("Request permission here")
            AVAudioSession.sharedInstance().requestRecordPermission({ [weak self] (granted) in
                
                guard let strongSelf = self else { return }
                // Handle granted
                if granted {
                    strongSelf.microphoneSts = true
                }else{
                    strongSelf.microphoneSts =  false
                    strongSelf.showPermisssionAlert("Microphone")
                }
                
                //return true
            })
            
        }
    }
    func AddSpeakChildVC(){
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.lblExpresion.text = ""
            strongSelf.currentText = "0"
        }
        
        self.speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        checkMicrophone() //{
        CallSpeak()
        
    }
    
    
    func CallSpeak(){
       
        SFSpeechRecognizer.requestAuthorization {[weak self] (authStatus)  in
            guard let strongSelf = self else { return }
            switch authStatus {
            case .authorized:
                if strongSelf.microphoneSts {
                    DispatchQueue.main.async {
                        let storyborad = UIStoryboard(name: "SpeakVC", bundle: nil)
                        let viewController = storyborad.instantiateViewController(withIdentifier: "SpeakVC") as! SpeakVC
                        viewController.delegate = self
                        strongSelf.addChildViewController(viewController)
                        strongSelf.view.addSubview(viewController.view)
                        viewController.didMove(toParentViewController: strongSelf)
                    }
                }
            case .denied:
                print("User denied access to speech recognition")
                strongSelf.showPermisssionAlert("Speech Recognition")
                
            case .restricted:
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                print("Speech recognition not yet authorized")
                
            }
            
        }
    }
    

    
    
    
   
    //Calculations
    func doMath(){

        guard  let lastChar = currentText.last else {
            equalClickSts = false
            return
        }
        
        if "+-/*=%".contains(lastChar){
             equalClickSts = false
            return
        }
       
        //Get last operator with number
        let array = currentText.components(separatedBy: lastOprator)
        if array.count == 0 {
            equalClickSts = false
            return
        }
        equalLastNum = (array.last)!
        
        
        
//        guard currentText != "" else { return }
//        if operations.count == 0{
//            operations.append(currentText)
//        }else{
//            operations[0] = currentText
//        }
        
        ShowcurrentText = currentText
        
        
        if currentText.contains("%") {
            //currentText = currentText.replacingOccurrences(of: "%", with: "*(").appending("/100)")
            currentText = currentText.replacingOccurrences(of: "%", with: "*1/100*")
        }
        if currentText.contains("÷") {
            currentText = currentText.replacingOccurrences(of: "÷", with: "/")
        }
        if currentText.contains("x") {
            currentText = currentText.replacingOccurrences(of: "x", with: "*")
        }
        
        
        //Show expression
//        if currentText.contains("%") {
//            currentText = currentText.replacingOccurrences(of: "%", with: "*").appending("/100")
//        }
        
        
        if ShowcurrentText.contains("/") {
            ShowcurrentText = ShowcurrentText.replacingOccurrences(of: "/", with: "÷")
        }
        if ShowcurrentText.contains("*") {
            ShowcurrentText = ShowcurrentText.replacingOccurrences(of: "*", with: "x")
        }
        //End
        
        
        
        if  getResultByExperation(currentText){
            
        }else{
            
            
            
            var expression:NSExpression!
            
            if currentText.contains("."){
                expression = NSExpression(format: currentText)
            }else{
                if currentText.contains(":"){
                    expression = NSExpression(format: currentText)
                }else{
                    expression = NSExpression(format: currentText + ".0")
                }
            }
            
            guard let mathValue = expression.expressionValue(with: nil, context: nil) as? Double else { return }
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 8
            guard let value = formatter.string(from: NSNumber(value: mathValue)) else { return }
            //Only Result For voice cal   speakText(text: currentText + "=" + value)
            speakText(text: currentText + "=" + value)
            
            lblExpresion.text = ShowcurrentText//currentText
            currentText = "= " + value
            //Adding in history array
            AddOperations(ShowcurrentText)
            AddOperations(currentText)
            
        }
    }
    
    
    
    func SpechTextChanges (_ insertText:String) ->String{
       
        var returnText = insertText
        
        if returnText.contains("/"){
            returnText = returnText.replacingOccurrences(of: "/", with: " Divided by ")
        }
        if returnText.contains("*"){
            returnText = returnText.replacingOccurrences(of: "*", with: " Multiplied by ")
        }
        
        if returnText.contains("X") || returnText.contains("x") || returnText.contains("×"){
            returnText = returnText.replacingOccurrences(of: "X", with: " Multiplied by ")
            returnText = returnText.replacingOccurrences(of: "x", with: " Multiplied by ")
            returnText = returnText.replacingOccurrences(of: "×", with: " Multiplied by ")
        }
        
        if returnText.contains("-"){
            returnText = returnText.replacingOccurrences(of: "-", with: " Minus ")
        }
        
        if returnText.contains("%"){
            returnText = returnText.replacingOccurrences(of: "%", with: " Percentage ")
        }
        
        if returnText.contains("+"){
            returnText = returnText.replacingOccurrences(of: "+", with: " Plus ")
        }
        
//        if returnText.contains("."){
//            returnText = returnText.replacingOccurrences(of: ".", with: "Point")
//        }
        
        if returnText.contains("C") && returnText.count == 1{
            returnText = returnText.replacingOccurrences(of: "C", with: "Please Speak to Calculate.")
        }
        
        if returnText.contains("Divide By100=") && returnText.contains("Multiply By"){
            returnText = returnText.replacingOccurrences(of: "Divide By100=", with: " = ")
            returnText = returnText.replacingOccurrences(of: "Multiply By", with: " Percentage ")
        }
        
        return returnText
    }
    
    func speakText(text:String){
        //Text to speech
        
        print(text)
        
        DispatchQueue.main.async { [weak self] in
            
            guard let strongSelf = self else { return }
            var speakingText = text
            
            if speakingText.contains(InvalidInput) || speakingText.contains(InvalidTextInput){
                if strongSelf.isSpeaking {
                    strongSelf.speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
                    //if self.speechSynthesizer == nil{
                    strongSelf.speechSynthesizer = AVSpeechSynthesizer()
                    //}
                    let speechUttrance = AVSpeechUtterance(string:speakingText)
                    speechUttrance.rate = AVSpeechUtteranceDefaultSpeechRate
                    speechUttrance.voice = AVSpeechSynthesisVoice(language: "en-US")
                    strongSelf.speechSynthesizer.speak(speechUttrance)
                    strongSelf.speechInvalidStatus = true
                    strongSelf.historyTableView.reloadData()
                }
                return
                
                
            }else if speakingText.contains("Clear All") {
                if strongSelf.isSpeaking {
                    strongSelf.speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
                    if strongSelf.speechSynthesizer == nil{
                        strongSelf.speechSynthesizer = AVSpeechSynthesizer()
                    }
                    let speechUttrance = AVSpeechUtterance(string:"Clear")
                    speechUttrance.voice = AVSpeechSynthesisVoice(language: "en-US")
                    speechUttrance.pitchMultiplier = 1
                    speechUttrance.rate = AVSpeechUtteranceMaximumSpeechRate/1.77
                    strongSelf.speechSynthesizer.speak(speechUttrance)
                    strongSelf.speechInvalidStatus = true
                    strongSelf.historyTableView.reloadData()
                }
                
                return
            }
            
            
            speakingText = strongSelf.SpechTextChanges(text)
            
            
            if strongSelf.isSpeaking {
                strongSelf.speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            }
            
            let speechUttrance = AVSpeechUtterance(string:speakingText)
            if speakingText.contains("="){
                speechUttrance.rate = AVSpeechUtteranceDefaultSpeechRate
                strongSelf.speechInvalidStatus = false
                
                strongSelf.historyTableView.reloadData()
                
            }else{
                speechUttrance.rate = AVSpeechUtteranceMaximumSpeechRate/1.72
            }
            speechUttrance.voice = AVSpeechSynthesisVoice(language: "en-US")
            if strongSelf.isSpeaking {
                strongSelf.speechSynthesizer.speak(speechUttrance)
            }
            
            
        }
    }
    
    
    
    
    //Speak and records
    func startRecognise(){
        let audioSession = AVAudioSession.sharedInstance()  //2
        do
        {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setMode(AVAudioSessionModeDefault)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        }
        catch{
            print("audioSession properties weren't set because of an error.")
        }
        
    }
    
    
    func recordAndRecognizeSpeech(){
        
        if recognitionTask != nil {  //1
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        resultString = ""
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()  //3
        let inputNode = audioEngine.inputNode
        ////            else {
        ////            fatalError("Audio engine has no input node")
        ////        }  //4
        //
        //        guard let recognitionRequest = recognitionRequest else {
        //            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        //        } //5
        //
        //        recognitionRequest.shouldReportPartialResults = true  //6
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { [weak self] (result, error)  in  //7
            
            guard let strongSelf = self else{return}
            var isFinal = false  //8
            if result != nil {
                
                
                if let str = result?.bestTranscription.formattedString {
                    strongSelf.resultString = str
                }
                isFinal = (result?.isFinal)!
                
                print(strongSelf.resultString)
            
                
                strongSelf.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                strongSelf.recognitionRequest = nil
                strongSelf.recognitionTask = nil
                strongSelf.returnExperation(strongSelf.resultString)
                  
            }
            
        })
        
        
        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        audioEngine.inputNode.installTap(onBus:0,bufferSize:1024, format :recordingFormat){buffer,_ in
            self.recognitionRequest?.append(buffer)
        }
        
        guard let myrecognizer = SFSpeechRecognizer() else{
            return
        }
        
        if !myrecognizer.isAvailable{
            return
        }
        
        audioEngine.prepare()  //12
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }
    
    
}


extension ViewController: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("speech finished")
    }
    
}

extension ViewController{
    
    static func getStoryboardInstance() -> UINavigationController?{
        let storyborad = UIStoryboard(name: String(describing: self), bundle: nil)
        guard let navViewController = storyborad.instantiateInitialViewController()  as? UINavigationController else { return nil }
        return navViewController
    }
}







extension ViewController:SpeakDelegate{
    
    func CancelScreen() {
        startRecognise()
       // lblExpresion.text = ""
       // currentText = "0"
    }
    
   
    
    func getResultByExperation(_ experation:String) -> Bool {
        do {
            let result = try Expression(experation).evaluate()
           // var finalResult = 0.0
            let str = "\(result)"
            
            if str == "inf" || str == "-inf" || str == "nan"{
                currentText = "0"
                lblExpresion.text = ""
                speakText(text: InvalidTextInput)
                return true
            }
           
            
            if str.contains("E") || str.contains("e"){
                let finalResult = result
                print("result: \(result) finalResult :\(finalResult)" )
              
                if speechStatus {
                    ShowcurrentText = experation
                    //For showing
                    if ShowcurrentText.contains("*1/100*") {
                        ShowcurrentText = ShowcurrentText.replacingOccurrences(of: "*1/100*", with: "%")
                    }
                    if ShowcurrentText.contains("/") {
                        ShowcurrentText = ShowcurrentText.replacingOccurrences(of: "/", with: "÷")
                    }
                    if ShowcurrentText.contains("*") {
                        ShowcurrentText = ShowcurrentText.replacingOccurrences(of: "*", with: "x")
                    }
                    
                    lblExpresion.text = ShowcurrentText//experation
                    currentText = "= \(resultWithCalculation(String(finalResult)))"
                    
           //Only Result For voice cal             speakText(text: ShowcurrentText + "=" + "\(resultWithCalculation(String(finalResult)))")
                    speakText(text: "=" + "\(resultWithCalculation(String(finalResult)))")
                    //Saving History
                    AddOperations(ShowcurrentText)
                    AddOperations(currentText)
                
                }else{
                    //Only Result For voice cal     speakText(text: ShowcurrentText + "=" + "\(resultWithCalculation(String(finalResult)))")
                    speakText(text: "=" + "\(resultWithCalculation(String(finalResult)))")
                    lblExpresion.text = ShowcurrentText//experation
                    currentText = "= \(resultWithCalculation(String(finalResult)))"
                    //Saving History
                    AddOperations(ShowcurrentText)
                    AddOperations(currentText)
                }
                
                
                
                
            }else{
                let finalResult = result.roundOffString
                print("result: \(result) finalResult :\(finalResult)" )
              
                if speechStatus {
                    if  !experation.contains("+") && !experation.contains("-") && !experation.contains("/") && !experation.contains("*") && !experation.contains("x") && !experation.contains("÷")  && !experation.contains("%") {
                        currentText = experation
                        return true
                    }
                    ShowcurrentText = experation
                    //For showing
                    if ShowcurrentText.contains("*1/100*") {
                        ShowcurrentText = ShowcurrentText.replacingOccurrences(of: "*1/100*", with: "%")
                    }
                    if ShowcurrentText.contains("/") {
                        ShowcurrentText = ShowcurrentText.replacingOccurrences(of: "/", with: "÷")
                    }
                    if ShowcurrentText.contains("*") {
                        ShowcurrentText = ShowcurrentText.replacingOccurrences(of: "*", with: "x")
                    }
                    
                    
                    
                    lblExpresion.text = ShowcurrentText
                    currentText = "= \(resultWithCalculation(String(finalResult)))"
                    //Only Result For voice cal      speakText(text: ShowcurrentText + "=" + "\(resultWithCalculation(String(finalResult)))")
                    speakText(text:"=" + "\(resultWithCalculation(String(finalResult)))")
                    //Saving History
                    AddOperations(ShowcurrentText)
                    AddOperations(currentText)
                }else{
                    
                    if  !experation.contains("+") && !experation.contains("-") && !experation.contains("/") && !experation.contains("*") && !experation.contains("x") && !experation.contains("÷")   && !experation.contains("%"){
                        currentText = experation
                        return true
                    }
                    //Only Result For voice cal      speakText(text: ShowcurrentText + "=" + "\(resultWithCalculation(String(finalResult)))")
                    speakText(text:"=" + "\(resultWithCalculation(String(finalResult)))")
                    lblExpresion.text = ShowcurrentText
                    currentText = "= \(resultWithCalculation(String(finalResult)))"
                    //Saving History
                    AddOperations(ShowcurrentText)
                    AddOperations(currentText)
                }
               
            }
            
        
            return true
        } catch {
            print("Catch -> \(experation)")
            return false
        }
        
        
    }
    
    
    func AddOperations(_ text:String) {
        self.operations.append(text)
        
    }
    
    
    func returnExperation(_ experation: String) {
        
        speechStatus = true
        startRecognise()
        lblExpresion.text = ""
        currentText = "0"
    
        /*if checkMyFirstCalOperator(experation){
            speakText(text: InvalidInput)
            return
        }*/
        
        
        
        
        var mutablestr = experation
        print("experation:-> ", experation)
       
        
        if  mutablestr.contains("equals") || mutablestr.contains("equal to"){
            mutablestr = experation.replacingOccurrences(of: "equals", with: "")
            mutablestr = experation.replacingOccurrences(of: "equal to", with: "")
        }
        
        if  mutablestr.contains("x"){
            mutablestr = mutablestr.replacingOccurrences(of: "x", with: "/")
        }
        
        if  mutablestr.contains(","){
            mutablestr = experation.replacingOccurrences(of: ",", with: "")
        }
        mutablestr = mutablestr.replacingOccurrences(of: " ", with: "")
        mutablestr = mutablestr.replacingOccurrences(of: "  ", with: "")
        if  mutablestr.contains("%"){
            mutablestr = mutablestr.replacingOccurrences(of: "%", with: "*1/100*")
        }
        let trimmed = mutablestr.trimmingCharacters(in: .whitespacesAndNewlines)

        print("Testing mutablestr +\(mutablestr)  \(trimmed)")
        
        if getResultByExperation(trimmed){
            
        }else{
            
            //When fail
            var pureExperation = experation
            if  pureExperation.contains("equals") || pureExperation.contains("equal to"){
                pureExperation = pureExperation.replacingOccurrences(of: "equals", with: "=")
                pureExperation = pureExperation.replacingOccurrences(of: "equal to", with: "=")
            }
            
            if  pureExperation.contains("plus") || pureExperation.contains("Plus")  {
                pureExperation = pureExperation.replacingOccurrences(of: "plus", with: "+")
                pureExperation = pureExperation.replacingOccurrences(of: "Plus", with: "+")
            }
            
            if  pureExperation.contains("add") || pureExperation.contains("Add")  {
                pureExperation = pureExperation.replacingOccurrences(of: "add", with: "+")
                pureExperation = pureExperation.replacingOccurrences(of: "Add", with: "+")
            }
            
            if  pureExperation.contains("equal"){
                pureExperation = pureExperation.replacingOccurrences(of: "equal", with: "=")
            }
            
            if  pureExperation.contains("One") || pureExperation.contains("one"){
                pureExperation = pureExperation.replacingOccurrences(of: "One", with: "1")
                pureExperation = pureExperation.replacingOccurrences(of: "one", with: "1")
            }
            
            if  pureExperation.contains("Three") || pureExperation.contains("three"){
                pureExperation = pureExperation.replacingOccurrences(of: "Three", with: "3")
                pureExperation = pureExperation.replacingOccurrences(of: "three", with: "3")
            }
            if  pureExperation.contains("Four") || pureExperation.contains("four") || pureExperation.contains("for"){
                pureExperation = pureExperation.replacingOccurrences(of: "Four", with: "4")
                pureExperation = pureExperation.replacingOccurrences(of: "four", with: "4")
                pureExperation = pureExperation.replacingOccurrences(of: "for", with: "4")
            }
            
            if  pureExperation.contains("Five") || pureExperation.contains("five"){
                pureExperation = pureExperation.replacingOccurrences(of: "Five", with: "5")
                pureExperation = pureExperation.replacingOccurrences(of: "five", with: "5")
            }
            
            if  pureExperation.contains("Six") || pureExperation.contains("six"){
                pureExperation = pureExperation.replacingOccurrences(of: "Six", with: "6")
                pureExperation = pureExperation.replacingOccurrences(of: "six", with: "6")
            }
            
            if  pureExperation.contains("Seven") || pureExperation.contains("seven"){
                pureExperation = pureExperation.replacingOccurrences(of: "Seven", with: "7")
                pureExperation = pureExperation.replacingOccurrences(of: "seven", with: "7")
            }
            
            if  pureExperation.contains("Eight") || pureExperation.contains("eight"){
                pureExperation = pureExperation.replacingOccurrences(of: "Eight", with: "8")
                pureExperation = pureExperation.replacingOccurrences(of: "eight", with: "8")
            }
            if  pureExperation.contains("Nine") || pureExperation.contains("nine"){
                pureExperation = pureExperation.replacingOccurrences(of: "Nine", with: "9")
                pureExperation = pureExperation.replacingOccurrences(of: "nine", with: "9")
            }
            
            if  pureExperation.contains("Ten") || pureExperation.contains("ten"){
                pureExperation = pureExperation.replacingOccurrences(of: "Ten", with: "10")
                pureExperation = pureExperation.replacingOccurrences(of: "ten", with: "10")
            }
            
            if  pureExperation.contains("Two"){
                pureExperation = pureExperation.replacingOccurrences(of: "Two", with: "2")
            }
            
            if  pureExperation.contains("two"){
                pureExperation = pureExperation.replacingOccurrences(of: "two", with: "2")
            }
            
//            if ( pureExperation.contains("To") || pureExperation.contains("To ") || pureExperation.contains("to") ||  pureExperation.contains("to")) {
//                pureExperation = pureExperation.replacingOccurrences(of: "To", with: "2")
//                pureExperation = pureExperation.replacingOccurrences(of: "to", with: "2")
//            }
            
            
            /*if  pureExperation.contains("to ") ||  pureExperation.contains(" to"){
             pureExperation = pureExperation.replacingOccurrences(of: "to", with: "2")
             }*/
            
            if  pureExperation.contains("Too"){
                pureExperation = pureExperation.replacingOccurrences(of: "Too", with: "2")
            }
            
            if  pureExperation.contains("too"){
                pureExperation = pureExperation.replacingOccurrences(of: "too", with: "2")
            }
            
            
            
            
            if  pureExperation.contains("×"){
                pureExperation = pureExperation.replacingOccurrences(of: "×", with: "*")
            }
            
            if  pureExperation.contains("÷"){
                pureExperation = pureExperation.replacingOccurrences(of: "÷", with: "/")
            }
            
            
            if  pureExperation.contains("Into") ||  pureExperation.contains("Indu"){
                pureExperation = pureExperation.replacingOccurrences(of: "Into", with: "*")
                pureExperation = pureExperation.replacingOccurrences(of: "Indu", with: "*")
            }
            if  pureExperation.contains("into") || pureExperation.contains("in2"){
                pureExperation = pureExperation.replacingOccurrences(of: "into", with: "*")
                pureExperation = pureExperation.replacingOccurrences(of: "in2", with: "*")
            }
            
            
            if  pureExperation.contains("multiply by") || pureExperation.contains("Multiply by") ||  pureExperation.contains("Multiplied by") || pureExperation.contains("multiplied by"){
                pureExperation = pureExperation.replacingOccurrences(of: "multiply by", with: "*")
                pureExperation = pureExperation.replacingOccurrences(of: "Multiply by", with: "*")
                pureExperation = pureExperation.replacingOccurrences(of: "Multiplied by", with: "*")
                pureExperation = pureExperation.replacingOccurrences(of: "multiplied by", with: "*")
            }
            
             if pureExperation.contains("multiplied") || pureExperation.contains("Multiplied") {
                pureExperation = pureExperation.replacingOccurrences(of: "multiplied", with: "*")
                pureExperation = pureExperation.replacingOccurrences(of: "Multiplied", with: "*")
            }
            
            if  pureExperation.contains("multiply") || pureExperation.contains("Multiply"){
                pureExperation = pureExperation.replacingOccurrences(of: "multiply", with: "*")
                pureExperation = pureExperation.replacingOccurrences(of: "Multiply", with: "*")
            }
            
            
            if  pureExperation.contains("divided by") || pureExperation.contains("Divided by"){
                pureExperation = pureExperation.replacingOccurrences(of: "divided by", with: "/")
                pureExperation = pureExperation.replacingOccurrences(of: "Divided by", with: "/")
            }
            
            if  pureExperation.contains("Divided") || pureExperation.contains("divided"){
                pureExperation = pureExperation.replacingOccurrences(of: "Divided", with: "/")
                pureExperation = pureExperation.replacingOccurrences(of: "divided", with: "/")
            }
            if  pureExperation.contains("Divide") || pureExperation.contains("divide"){
                pureExperation = pureExperation.replacingOccurrences(of: "Divide", with: "/")
                pureExperation = pureExperation.replacingOccurrences(of: "divide", with: "/")
            }
            
            if  pureExperation.contains("Divides") || pureExperation.contains("divides"){
                pureExperation = pureExperation.replacingOccurrences(of: "Divides", with: "/")
                pureExperation = pureExperation.replacingOccurrences(of: "divides", with: "/")
            }
            /*if  pureExperation.contains("by"){
                pureExperation = pureExperation.replacingOccurrences(of: "by", with: "/")
            }
            if  pureExperation.contains("By"){
                pureExperation = pureExperation.replacingOccurrences(of: "By", with: "/")
            }
            
            if  pureExperation.contains("buy"){
                pureExperation = pureExperation.replacingOccurrences(of: "buy", with: "/")
            }
            if  pureExperation.contains("Buy"){
                pureExperation = pureExperation.replacingOccurrences(of: "Buy", with: "/")
            }*/
            
            
            if  pureExperation.contains("legs"){
                pureExperation = pureExperation.replacingOccurrences(of: "legs", with: "100000")
            }
            
            if  pureExperation.contains("leg"){
                pureExperation = pureExperation.replacingOccurrences(of: "leg", with: "100000")
            }
            
            if  pureExperation.contains("Hundred") || pureExperation.contains("hundred"){
                pureExperation = pureExperation.replacingOccurrences(of: "Hundred", with: "100")
                pureExperation = pureExperation.replacingOccurrences(of: "hundred", with: "100")
            }
            
            if  pureExperation.contains("=="){
                pureExperation = pureExperation.replacingOccurrences(of: "==", with: "")
            }
            
            if  pureExperation.contains("% of"){
                pureExperation = pureExperation.replacingOccurrences(of: "% of", with: "*1/100*")
            }
            if  pureExperation.contains("% at"){
                pureExperation = pureExperation.replacingOccurrences(of: "% at", with: "*1/100*")
            }
            
            if  pureExperation.contains("% is"){
                pureExperation = pureExperation.replacingOccurrences(of: "% is", with: "*1/100*")
            }
            
            
            if  pureExperation.contains("Percent of") || pureExperation.contains("percent of"){
                pureExperation = pureExperation.replacingOccurrences(of: "Percent of", with: "*1/100*")
                pureExperation = pureExperation.replacingOccurrences(of: "percent of", with: "*1/100*")
            }
            
            if  pureExperation.contains("Percentage of") || pureExperation.contains("percentage of"){
                pureExperation = pureExperation.replacingOccurrences(of: "Percentage of", with: "*1/100*")
                pureExperation = pureExperation.replacingOccurrences(of: "percentage of", with: "*1/100*")
            }
            if  pureExperation.contains("Percentage") || pureExperation.contains("percentage"){
                pureExperation = pureExperation.replacingOccurrences(of: "Percentage", with: "*1/100*")
                pureExperation = pureExperation.replacingOccurrences(of: "percentage", with: "*1/100*")
            }
            if  pureExperation.contains("Percent") || pureExperation.contains("percent"){
                pureExperation = pureExperation.replacingOccurrences(of: "Percent", with: "*1/100*")
                pureExperation = pureExperation.replacingOccurrences(of: "percent", with: "*1/100*")
            }
            
            if  pureExperation.contains("% of") || pureExperation.contains("% age of"){
                pureExperation = pureExperation.replacingOccurrences(of: "% of", with: "*1/100*")
                pureExperation = pureExperation.replacingOccurrences(of: "% age of", with: "*1/100*")
            }
            
            
            
            
            if  pureExperation.contains("%"){
                pureExperation = pureExperation.replacingOccurrences(of: "%", with: "*1/100*")
            }
            
            
            
            pureExperation = pureExperation.replacingOccurrences(of: " ", with: "")
            pureExperation = pureExperation.replacingOccurrences(of: "  ", with: "")
            print("Testing +\(pureExperation)")
            
            
            
            if getResultByExperation(pureExperation){
                
            }else{
                
                if  pureExperation.contains("=") {
                    pureExperation = pureExperation.replacingOccurrences(of: "=", with: "")
                    let firstChr = pureExperation.prefix(1)
                    let lastChr = pureExperation.suffix(1)
                    
                    if firstChr == "+" || firstChr == "-" || firstChr == "/" || firstChr == "%" ||  firstChr == "*"{
                        pureExperation = String(pureExperation.dropFirst())
                    }else if lastChr == "+" || lastChr == "-" || lastChr == "/" || lastChr == "%" ||  lastChr == "*"{
                        pureExperation = String(pureExperation.dropLast())
                    }
                    var filtered = removeSpecialCharsFromString(pureExperation)
                    if  filtered.contains("++"){
                        filtered = filtered.replacingOccurrences(of: "++", with: "+")
                    }
                    if  filtered.contains("--"){
                        filtered = filtered.replacingOccurrences(of: "--", with: "-")
                    }
                    if  filtered.contains("**"){
                        filtered = filtered.replacingOccurrences(of: "**", with: "*")
                    }
                    if  filtered.contains("+++"){
                        filtered = filtered.replacingOccurrences(of: "+++", with: "+")
                    }
                    print(filtered)
                    self.currentText = filtered
                    self.doMath()
                    
                }else{
                    speakText(text: InvalidInput)
                    return
                }
            }
            
        }
        
    }
    
    
}




extension ViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if speechStatus {
            if speechInvalidStatus {
                return operations.count
            }else{
                if operations.count == 1 {
                    return 0
                }else{
                    return (operations.count - 2)
                }
            }
        }else{
            if operations.count == 1 {
                return 0
            }else if equalClickSts{
                return (operations.count - 2)
            }else{
                return operations.count
            }
        }
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.identifier, for: indexPath)  as? HistoryCell else { return UITableViewCell() }
        cell.label.alpha = 0.28
        cell.label.text = operations[indexPath.row]
        //cell.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi));
        
        let themeFolderName = KidsCalciUserDefaults.getTheme()
        if themeFolderName == "1"{
            cell.label.textColor = .white
        }else if themeFolderName == "2"{
             cell.label.textColor = UIColor.hexStringToUIColor(hex: theme2TextColor)
        }else{
             cell.label.textColor = .white
        }
        
        return cell
    }
    
    
}







