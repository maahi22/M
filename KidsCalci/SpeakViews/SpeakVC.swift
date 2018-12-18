//
//  SpeakVC.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 02/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import UIKit
import Speech
import AVFoundation
import AudioToolbox
//import SwiftySound

protocol SpeakDelegate:class {
    
    func returnExperation(_ experation: String)
    func CancelScreen()
}


class SpeakVC: UIViewController, SFSpeechRecognizerDelegate,AVAudioPlayerDelegate {

    weak var delegate:SpeakDelegate?
    @IBOutlet weak var spekerImgView: UIImageView!
    @IBOutlet weak var roundBackImgView: UIImageView!
    
    @IBOutlet weak var backImgView: UIImageView!
    @IBOutlet weak var micView: UIView!
    
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))!
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest!
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    var speechSynthesizer:AVSpeechSynthesizer!
    var resultString = ""
    var player: AVAudioPlayer?
    
    
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        speechRecognitionTimeout2?.invalidate()
        speechRecognitionTimeout?.invalidate()
        
    }
    
    
    func showPermisssionAlert(_ permission:String){
        
        let alertController = UIAlertController(title: permission, message: "Please go to Settings and turn on the permissions", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            
            
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.dissmissView()
                strongSelf.delegate?.CancelScreen()
            }
            
            
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in }
                )
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.dissmissView()
                strongSelf.delegate?.CancelScreen()
            }
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    
    
    }
    
    
    @objc func appMovedToBackground() {
        //print("App moved to background!")
        if (self.speechSynthesizer != nil) {
            self.speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
        
        self.audioEngine.pause()
        /*self.audioEngine.inputNode.removeTap(onBus: 0)
        self.recognitionTask = nil
        self.recognitionRequest = nil
        self.recognitionTask = nil*/
        
        /*DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.dissmissView()
            strongSelf.delegate?.CancelScreen()
        }*/
    }
    
    
    func checkMicrophone(){
        
        
        switch AVAudioSession.sharedInstance().recordPermission() {
        case AVAudioSessionRecordPermission.granted:
            print("Permission granted")
            
        case AVAudioSessionRecordPermission.denied:
            print("Pemission denied")
            
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.willMove(toParentViewController: nil)
                strongSelf.view.removeFromSuperview()
                strongSelf.removeFromParentViewController()
                strongSelf.delegate?.CancelScreen()
            }
            self.showPermisssionAlert("Microphone")
            showAlertMessage(vc: self, title: .Message, message: "denied")
        // return
        case AVAudioSessionRecordPermission.undetermined:
            print("Request permission here")
            
            showAlertMessage(vc: self, title: .Message, message: "undetermined")
            
            
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                // Handle granted
            })
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.isOpaque = false
        
        view.backgroundColor = .clear
        self.backImgView.backgroundColor = .black
        self.backImgView.alpha = 0.4
        //self.navigationController?.isNavigationBarHidden = false
        
        
      
        
        micView.layer.shadowColor = UIColor.black.cgColor
        micView.layer.shadowOpacity = 0.2
        micView.layer.shadowOffset = CGSize.zero
        micView.layer.shadowRadius = 30
        
        
        let themeFolderName = KidsCalciUserDefaults.getTheme()
        if themeFolderName != ""{
            let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            if paths.count > 0 {
                let dirPath = paths[0]
                let filePath = NSString(format:"%@/%@/%@", dirPath, themeFolderName,themeFolderName) as String
            
            let img = loadImageFromThemeFolder("speaker", folderPath: filePath)
            spekerImgView.image = img
            }
            
        }
        
        //background call
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
        
        
        /*let animation = CATransition()
        animation.delegate = self
        animation.duration = 2.0
        animation.timingFunction = CAMediaTimingFunction(name : kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = "rippleEffect"
        roundBackImgView.layer.add(animation, forKey: nil)*/
        //animateImage()
        
       
        
        let systemSoundID: SystemSoundID = 1113
        guard let url = Bundle.main.url(forResource: "beep", withExtension: "wav") else { return }
        //Change from record mode to play mode
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.play()
        
        } catch let error as NSError {
            print("Error \(error)")
        }
        
        
        AudioServicesPlaySystemSoundWithCompletion(systemSoundID) { [weak self] in

            guard let strongSelf = self else { return }
            strongSelf.speechRecognizer.delegate = self
            
            
            strongSelf.checkMicrophone()
            
            SFSpeechRecognizer.requestAuthorization { (authStatus) in
                //var isButtonEnabled = false
                switch authStatus {
                case .authorized:
                    //isButtonEnabled = true
                    print("User Enable access to speech recognition")
                    strongSelf.setupSpeechRecognition()
                
                
                case .denied:
                    //isButtonEnabled = false
                    print("User denied access to speech recognition")
                    
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else { return }
                        strongSelf.willMove(toParentViewController: nil)
                        strongSelf.view.removeFromSuperview()
                        strongSelf.removeFromParentViewController()
                        strongSelf.delegate?.CancelScreen()
                    }
                    strongSelf.showPermisssionAlert("Speech Recognition")
                   // return
                    
                    showAlertMessage(vc: strongSelf, title: .Message, message: "denied")
                case .restricted:
                    // isButtonEnabled = false
                    print("Speech recognition restricted on this device")
                    showAlertMessage(vc: strongSelf, title: .Message, message: "restricted")
                case .notDetermined:
                    // isButtonEnabled = false
                    showAlertMessage(vc: strongSelf, title: .Message, message: "notDetermined")
                    print("Speech recognition not yet authorized")
                }
                
            }
            
         //   strongSelf.setupSpeechRecognition()
            
        }
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
//            guard let strongSelf = self else { return }
//            strongSelf.startRecording()
//
//             }
        
        
    }
    
    

    func animateImage() {
        addRippleEffect(to: roundBackImgView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//      //  if (self.audioEngine != nil) {
//            do {
//                try self.audioEngine.start()
//            }
//            catch {
//                print(error)
//            }
//        //}
    }
    
    
    
    
    
    private var speechRecognitionTimeout: Timer?
    
    public var speechTimeoutInterval: TimeInterval = 1 {
        didSet {
            restartSpeechTimeout()
        }
    }
    
    private func restartSpeechTimeout() {
        speechRecognitionTimeout2?.invalidate()
        speechRecognitionTimeout?.invalidate()
        speechRecognitionTimeout = Timer.scheduledTimer(timeInterval:speechTimeoutInterval, target: self, selector: #selector(timedOut), userInfo: nil, repeats: false)
    }
    
    
    
    
    
    
    
    //Timer 2
    private var speechRecognitionTimeout2: Timer?
    private func restartSpeechTimeout2() {
        speechRecognitionTimeout2?.invalidate()
        DispatchQueue.main.async { [weak self] in
            guard let strongself = self else {return}
            strongself.speechRecognitionTimeout2 = Timer.scheduledTimer(timeInterval:15.0, target: strongself, selector: #selector(strongself.timedOutNew), userInfo: nil, repeats: false)
        }
        
    }
    
    @objc  func timedOutNew() {
        stopRecording()
        delegate?.CancelScreen()
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    
    
    
    
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
//        if available {
//            microphoneButton.isEnabled = true
//        } else {
//            microphoneButton.isEnabled = false
//        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
    @IBAction func cancelClick(_ sender: UIButton) {
        delegate?.CancelScreen()
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    
    func dissmissView()  {
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    
    
    
    
    private func setupSpeechRecognition() {
        self.speechSynthesizer = AVSpeechSynthesizer()
        self.speechRecognizer.delegate = self
        do {
            try self.startRecording()
        }
        catch {
            print(error)
        }
    }
    
    
    public func startRecording() throws {
        
        self.restartSpeechTimeout2()
        
        
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.audioEngine.stop()
            self.audioEngine.inputNode.removeTap(onBus: 0)
            self.recognitionTask = nil
            self.recognitionRequest = nil
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        
        // Configure request so that results are returned before audio recording is finished
        recognitionRequest.shouldReportPartialResults = true
        
        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            var isFinal = false
           guard let strongSelf = self else{return}
            
            if let result = result {
                isFinal = result.isFinal
                
                strongSelf.resultString = result.bestTranscription.formattedString
                //print("GET STRING \(strongSelf.resultString) ")
               // self.delegate?.speechRecognitionPartialResult(transcription: result.bestTranscription.formattedString)
            }
            
            if error != nil || isFinal {
                strongSelf.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                strongSelf.recognitionRequest = nil
                strongSelf.recognitionTask = nil
            }
            
            if isFinal {
                //self.delegate?.speechRecognitionFinished(transcription: result!.bestTranscription.formattedString)
                strongSelf.stopRecording()
                strongSelf.dissmissView()
                strongSelf.delegate?.returnExperation(strongSelf.resultString)
                
            }
            else {
                if error == nil {
                    strongSelf.restartSpeechTimeout()
                }
                else {
                    // cancel voice recognition

                }
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    
    
    @objc private func timedOut() {
        stopRecording()
       // self.delegate?.speechRecognitionTimedOut()
        
    }
    
    public func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0) // Remove tap on bus when stopping recording.
        recognitionRequest?.endAudio()
        speechRecognitionTimeout?.invalidate()
        speechRecognitionTimeout = nil
    }
    
    
    
    
    
    
    
    
    
    
    
    func addRippleEffect(to referenceView: UIView) {
        /*! Creates a circular path around the view*/
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: referenceView.bounds.size.width, height: referenceView.bounds.size.height))
        /*! Position where the shape layer should be */
        let shapePosition = CGPoint(x: referenceView.bounds.size.width / 2.0, y: referenceView.bounds.size.height / 2.0)
        let rippleShape = CAShapeLayer()
        rippleShape.bounds = CGRect(x: 0, y: 0, width: referenceView.bounds.size.width, height: referenceView.bounds.size.height)
        rippleShape.path = path.cgPath
        rippleShape.fillColor = UIColor.clear.cgColor
        rippleShape.strokeColor = UIColor.lightGray.cgColor
        rippleShape.lineWidth = 4
        rippleShape.position = shapePosition
        rippleShape.opacity = 0
        
        /*! Add the ripple layer as the sublayer of the reference view */
        referenceView.layer.addSublayer(rippleShape)
        /*! Create scale animation of the ripples */
        let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        scaleAnim.toValue = NSValue(caTransform3D: CATransform3DMakeScale(2, 2, 1))
        /*! Create animation for opacity of the ripples */
        let opacityAnim = CABasicAnimation(keyPath: "opacity")
        opacityAnim.fromValue = 1
        opacityAnim.toValue = nil
        /*! Group the opacity and scale animations */
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnim, opacityAnim]
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.duration = CFTimeInterval(0.7)
        animation.repeatCount = 1000
        animation.isRemovedOnCompletion = true
        rippleShape.add(animation, forKey: "rippleEffect")
    }
}

extension SpeakVC:CAAnimationDelegate{
    
}

extension SpeakVC{
    static func getStoryboardInstance() -> UINavigationController?{
        let storyborad = UIStoryboard(name: String(describing: self), bundle: nil)
        guard let navViewController = storyborad.instantiateInitialViewController()  as? UINavigationController else { return nil }
        return navViewController
    }
}
