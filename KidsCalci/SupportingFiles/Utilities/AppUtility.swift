//
//  AppUtility.swift

import UIKit
import RNCryptor




let portalIdentifier = "EMCITY"//"MYCITY123"//EMCITY


//MARK: - global functions
//load mainview
/*func loadMainView()   {
    guard let mainView = UIStoryboard(name: Screens.SideMenu.rawValue, bundle: nil).instantiateInitialViewController() as? CustomSideMenuViewController
        else{
            return
    }
    UIApplication.shared.keyWindow?.rootViewController = mainView
}*/

//MARK: - OTP Generation
func generateOTP() -> String {
    var fourDigitNumber: String {
        var result = ""
        repeat {
            // Create a string with a random number 0...9999
            result = String(format:"%04d", arc4random_uniform(10000) )
        } while Set<Character>(result).count < 4
        return result
    }
    return fourDigitNumber
}

//MARK: - Date formatter's metthod

func getGreetingsByTime()->String{
    let dateComponents = Calendar.current.dateComponents([.hour], from: Date())
    if let hour = dateComponents.hour {
        switch hour {
        case 0..<12:
            return "Good morning"
        case 12..<17:
            return  "Good afternoon"
        default:
            return  "Good evening"
        }
    }
    return ""
}
func getStringFromDateString(dateString: String, dateFormat:String, desireDateFormat:String) -> String? {
    guard let date = getDateFromString(dateString: dateString, dateFormat: dateFormat) else { return nil }
    guard let desireDateString = getStringFromDate(date: date, dateFormat: desireDateFormat, useTimeZone: false) else { return nil }
    return desireDateString
}

func getDateFromString(dateString: String, dateFormat:String) -> Date? {
    let formater = DateFormatter()
    formater.dateFormat = dateFormat//"yyyy-mm-dd HH:mm:ss"
    guard let date = formater.date(from: dateString) else{
        return nil
    }
    return date
}

func getStringFromDate(date: Date, dateFormat:String, useTimeZone:Bool) -> String? {
    let formater = DateFormatter()
    if useTimeZone{
    formater.timeZone = TimeZone(identifier: "Asia/Dubai")
    }
    formater.dateFormat = dateFormat//"yyyy-mm-dd HH:mm:ss"
    let date1 = formater.string(from: date)
    return date1
}

func getDateFromTimeStamp(unixTimeStamp: Double, dateFormat:String) ->String?{
    let date = Date(timeIntervalSince1970: unixTimeStamp/1000)
    let dateFormatter = DateFormatter()
    //dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
    //dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = dateFormat //Specify your format that you want
    let strdate = dateFormatter.string(from: date)
    return strdate
}

func getTimestampFromString(dateString: String, dateFormat:String)-> Double?{
    guard let date = getDateFromString(dateString: dateString, dateFormat: dateFormat)
        else{
            return nil
    }
    let dateStamp:TimeInterval = date.timeIntervalSince1970 * 1000
    return dateStamp
}

func getFraction() -> String{
    let formater = DateFormatter()
    formater.dateFormat = "yyyyMddHHmmss"
    let date = formater.string(from: Date())
    let randomDigit = generateOTP()
    return date + randomDigit
}
func getEncryptPassword(_ password:String, with fraction:String) ->  String{
    let shaHex = getEncryptPassword(password)
    print("shaHex: \(shaHex)")
    let fractionPassword = fraction + shaHex.uppercased()
    let ePasswordData = sha256(string:fractionPassword  )
    let ePassword = ePasswordData!.map { String(format: "%02hhx", $0) }.joined()
    print(ePassword)
    return ePassword.uppercased()
}

func getEncryptPassword(_ password:String) ->  String{
    let shaData = sha256(string:password)
    let shaHex =  shaData!.map { String(format: "%02hhx", $0) }.joined()
    print("shaHex: \(shaHex)")
    return shaHex.uppercased()
}


func sha256(string: String) -> Data? {
    guard let messageData = string.data(using:String.Encoding.utf8) else { return nil }
    var digestData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
    
    _ = digestData.withUnsafeMutableBytes {digestBytes in
        messageData.withUnsafeBytes {messageBytes in
            CC_SHA256(messageBytes, CC_LONG(messageData.count), digestBytes)
        }
    }
    return digestData
}


//MARK : - Compostion
extension String{
    func convertHtml() -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        
        do {
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return NSAttributedString()
        }
    }
}

////////// 971564804596

//json response keys
/////////////
//MARK: - API Methods

public enum APIMethods:String{
    case APPSIGNIN = "APP.SIGNIN"
    case APPMETADATA = "APP.META.DATA"
    case GETSUBCAT = "GET.SUB.CAT"
    case GETPORTALBIZ = "GET.PORTAL.BIZ"
    case GETONEBIZ = "GET.ONE.BIZ"
}




//MARK: - Side Menu Options
enum SideMenuOptions: String {
    case showHome = "showHome"
    case containSideMenu = "containSideMenu"
    case showFeedback = "showFeedback"
    case getSupport = "getSupport"
    case showSeries = "showSeries"
    case openThemes = "openThemes"
}

//MARK: - Storyboards
enum Screens: String {
    case LaunchScreen = "LaunchScreen"
    case Welcome = "Welcome"
    case Login = "Login"
    case Dashboard = "Dashboard"
    case SideMenu = "SideMenu"
}

//MAR: - welcome from
enum WelcomeScreen {
    case education, card, food, moneytransfer, goverment, bills
}

enum OSType: String {
    case ios = "ios"
    case android = "android"
    
}

enum FeedbackType: String {
    case love_it = "love_it"
    case its_okay = "its_okay"
    case needs_work = "needs_work"
    
}

///show alert message
//MARK: - For Alert Message
enum AlertTitleType:String {
    case Error = "Error"
    case Warning = "Warning"
    case Message = "Message"
    case Information = "Information"
    case none = ""
    case ThemeAlredyAplied = "This theme is already applied"
}

func showAlertMessage(vc: UIViewController, title:AlertTitleType, message:String) -> Void {
    let alertCtrl = UIAlertController(title: title.rawValue, message: message, preferredStyle: UIAlertControllerStyle.alert)
    let alertAction = UIAlertAction(title: AlertBtnOk, style: .cancel, handler: nil)
    
    alertCtrl.addAction(alertAction)
    vc.present(alertCtrl, animated: true, completion: nil)
}

func showAlertMessage(vc: UIViewController, title:String, message:String,actionTitle: String?, handler:((UIAlertAction)->Void)?) -> Void {
    let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    let alertAction = UIAlertAction(title: actionTitle, style: .cancel, handler: handler)
    
    alertCtrl.addAction(alertAction)
    vc.present(alertCtrl, animated: true, completion: nil)
}

func showConfirmMessage(vc: UIViewController, title:String, message:String,actionTitle: String?, handler:((UIAlertAction)->Void)?) -> Void {
    let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    let alertAction = UIAlertAction(title: actionTitle, style: .default, handler: handler)
    let alertCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertCtrl.addAction(alertCancel)
    alertCtrl.addAction(alertAction)
    vc.present(alertCtrl, animated: true, completion: nil)
}

//validation
extension String{
    func isValidEmail() -> Bool {
        print("validate emilId: \(self)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result
    }
}



///



protocol HideableHairlineViewController {
    func hideHairline()
    func showHairline()
}

extension HideableHairlineViewController where Self: UIViewController {
    
    func hideHairline() {
        findHairline()?.isHidden = true
    }
    
    func showHairline() {
        findHairline()?.isHidden = false
    }
    
    private func findHairline() -> UIImageView? {
        return navigationController?.navigationBar.subviews
            .flatMap { $0.subviews }
            .flatMap { $0 as? UIImageView }
            .filter { $0.bounds.size.width == self.navigationController?.navigationBar.bounds.size.width }
            .filter { $0.bounds.size.height <= 2 }
            .first
    }
    
}


////////
enum BGPatternColor {
    case blue
    case education
    case food
    case card
    case general
    case login
}
//MARK: - Theme

let mainColor: UIColor = #colorLiteral(red: 0.541176470588235, green: 0.756862745098039, blue: 0.227450980392157, alpha: 1)//#colorLiteral(red: 0.9843137255, green: 0.4666666667, blue: 0.02352941176, alpha: 1)//
let buttonBGColor: UIColor = #colorLiteral(red: 0.541176470588235, green: 0.756862745098039, blue: 0.227450980392157, alpha: 1)//#colorLiteral(red: 0.9843137255, green: 0.4666666667, blue: 0.02352941176, alpha: 1)
let menuBGColor: UIColor = #colorLiteral(red: 0.1411764706, green: 0, blue: 0.6392156863, alpha: 1)
let mainNavBarColor:UIColor = #colorLiteral(red: 0.541176470588235, green: 0.756862745098039, blue: 0.227450980392157, alpha: 1)//#colorLiteral(red: 0.9843137255, green: 0.4666666667, blue: 0.02352941176, alpha: 1)

//138,193,58
///
let heightForHeaderInSection:CGFloat = 180.0
//78,113,33


extension UIButton{
    func setButtonTheme(){
        setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        backgroundColor = buttonBGColor
        //let cornerRadius = self.frame.size.height/2
        layer.cornerRadius = 4.0
        /*guard let customFont = UIFont(name: "Verdana", size: UIFont.labelFontSize) else {
            fatalError("""
        Failed to load the "Geometria-Bold" font.
        Make sure the font file is included in the project and the font name is spelled correctly.
        """
            )
        }
        self.titleLabel?.font =  UIFontMetrics.default.scaledFont(for: customFont)
        self.titleLabel?.adjustsFontForContentSizeCategory = true*/
        
    }
}

extension UILabel{
    func setLabelTheme(){
        self.textColor = .black
        /*guard let customFont = UIFont(name: "Verdana", size: UIFont.labelFontSize) else {
            fatalError("""
         Failed to load the "Geometria-Bold" font.
         Make sure the font file is included in the project and the font name is spelled correctly.
         """
            )
        }
        
        self.font = UIFontMetrics.default.scaledFont(for: customFont)
        self.adjustsFontForContentSizeCategory = true*/
    }
    func setLabelTheme(_ fontSize:CGFloat){
        self.textColor = .black
       /* guard let customFont = UIFont(name: "Verdana", size: fontSize) else {
            fatalError("""
         Failed to load the "Geometria-Bold" font.
         Make sure the font file is included in the project and the font name is spelled correctly.
         """
            )
        }
        
        self.font = UIFontMetrics.default.scaledFont(for: customFont)
        self.adjustsFontForContentSizeCategory = true*/
    }
}

extension UITableView{
    func setTableViewBackgroundPattern(_ color: BGPatternColor){
        
        switch color {
        case .general:
            let imageView = UIImageView(image: #imageLiteral(resourceName: "new_landing_page_bg"))
            // center and scale background image
            imageView.contentMode = .scaleToFill
            self.backgroundView = imageView
        case .education:
            let imageView = UIImageView(image: #imageLiteral(resourceName: "bg_texture_gray"))
            // center and scale background image
            imageView.contentMode = .scaleAspectFill
            self.backgroundView = imageView
        case .food:
            let imageView = UIImageView(image: #imageLiteral(resourceName: "food_patter_transprient"))
            // center and scale background image
            imageView.contentMode = .scaleToFill
            self.backgroundView = imageView
        case .card:
            let imageView = UIImageView(image: #imageLiteral(resourceName: "money_pattern_png"))
            // center and scale background image
            imageView.contentMode = .scaleToFill
            self.backgroundView = imageView
        case .blue:
            let imageView = UIImageView(image: #imageLiteral(resourceName: "new_landing_page_bg"))
            // center and scale background image
            imageView.contentMode = .scaleToFill
            self.backgroundView = imageView
       
        case .login:
            let imageView = UIImageView(image: #imageLiteral(resourceName: "background_image"))
            // center and scale background image
            imageView.contentMode = .scaleToFill
            self.backgroundView = imageView
        }
    }
    
    
    /*
    func setTableViewViewBackground() {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "new_landing_page_bg"))
        // center and scale background image
        imageView.contentMode = .scaleToFill
        self.backgroundView = imageView
    }
    func setTableViewViewBackground2() {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "bg_texture_gray"))
        // center and scale background image
        imageView.contentMode = .scaleAspectFill
        self.backgroundView = imageView
    }
    
    
    func setCardTableViewBackground() {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "money_transfer_png"))
        // center and scale background image
        imageView.contentMode = .scaleToFill
        self.backgroundView = imageView
    }
    func setFoodTableViewBackground() {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "food_patter_transprient"))
        // center and scale background image
        imageView.contentMode = .scaleToFill
        self.backgroundView = imageView
    }
    func setTableViewViewBackground4() {
        //let imageView = UIImageView(image: #imageLiteral(resourceName: "background_image"))
        // center and scale background image
        imageView.contentMode = .scaleToFill
        self.backgroundView = imageView
    }*/
    
    func setTableViewBackgroundGradient( _ topColor:UIColor, _ bottomColor:UIColor) {
        
        let gradientBackgroundColors = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations = [0.0,0.5]
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientBackgroundColors
        gradientLayer.locations = gradientLocations as [NSNumber]
        
        gradientLayer.frame = self.frame
        let backgroundView = UIView(frame: self.frame)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        self.backgroundView = backgroundView
    }
}

extension UIImageView{
    func setBackgroundImageView(_ color:BGPatternColor)  {
        self.contentMode = .scaleToFill
        switch color {
        case .general:
            self.image = #imageLiteral(resourceName: "new_landing_page_bg")
        case .education:
            self.image = #imageLiteral(resourceName: "bg_texture_gray")
        case .food:
           self.image = #imageLiteral(resourceName: "food_patter_transprient")
        case .card:
            self.image = #imageLiteral(resourceName: "money_pattern_png")
        case .blue:
           self.image = #imageLiteral(resourceName: "new_landing_page_bg")
        case .login:
            self.image = #imageLiteral(resourceName: "background_image")
        }
    }
}

////
extension UIView {
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: -5, height: 5)
        self.layer.shadowRadius = 5
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    /*func setBackgroundPattern(_ color: BGPatternColor){
        
        switch color {
        case .blue:
            self.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "header"))
        case .education:
            self.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "education_texture"))
        case .food:
            if let image = UIImage(named: "food_patter_transprient"){
                self.backgroundColor = UIColor(patternImage: image)
            }
        case .card:
            if let image = UIImage(named: "money_pattern_png"){
                self.backgroundColor = UIColor(patternImage: image)
            }
        case .general:
            self.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "new_landing_page_bg"))
        case .login:
            self.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background_image"))
        }
    }*/
    
}

//////
//set navigation bar color and text color

func setAppNavigationBar() {
    // Override point for customization after application launch.
    
    if #available(iOS 11.0, *) {
        UINavigationBar.appearance().prefersLargeTitles = true
    } else {
        // Fallback on earlier versions
    }
    UINavigationBar.appearance().barTintColor = mainColor
    UINavigationBar.appearance().backgroundColor = mainColor
    UINavigationBar.appearance().tintColor = .white
    /*guard let customFont = UIFont(name: "Verdana", size: CGFloat(20)) else {
        fatalError("""
        Failed to load the "Geometria-Bold" font.
        Make sure the font file is included in the project and the font name is spelled correctly.
        """
        )
    }
    let font = UIFontMetrics.default.scaledFont(for: customFont)*/
    let attrs = [
        NSAttributedStringKey.foregroundColor: UIColor.white
        //,NSAttributedStringKey.font: font
    ]
    UINavigationBar.appearance().titleTextAttributes = attrs
    if #available(iOS 11.0, *) {
        UINavigationBar.appearance().largeTitleTextAttributes = attrs
    } else {
        // Fallback on earlier versions
    }
    UISearchBar.appearance().tintColor = .white
    UISearchBar.appearance().barTintColor = .white
    
    
}
func setStatusBar() {
    UIApplication.shared.statusBarStyle = .default
    
    /*let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
     if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
     statusBar.backgroundColor = .white
     }*/
    
}



extension CGFloat {
    static var random: CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random, green: .random, blue: .random, alpha: 1.0)
    }
}

extension UIImage {
    func image(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}


extension UINavigationController{
    
    func setBackButton()  {
        let yourBackImage = UIImage(named: "back_btn")
        navigationBar.backIndicatorImage = yourBackImage
        navigationBar.backIndicatorTransitionMaskImage = yourBackImage
    }
    
}
//MARK: - User Credentials
/*
 func getLoggedUser() -> User? {
 guard let data = UserDefaults.standard.data(forKey: "userObject")
 else{
 return nil
 }
 let user = try? JSONDecoder().decode(User.self, from: data)
 return user
 }
 
 
 func getLoggedUserCredentials( type:Int) -> Credential? {
 
 guard let data = UserDefaults.standard.data(forKey: "userObject")
 else{
 return nil
 }
 let user = try? JSONDecoder().decode(User.self, from: data)
 let credentials = user?.Credentials.filter { (credential) -> Bool in
 return credential.CredentialType == type
 }
 return credentials?.first
 }
 */
func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
    let decoder = JSONDecoder()
    guard let data = from,
        let response = try? decoder.decode(type.self, from: data) else { return nil }
    
    return response
}
